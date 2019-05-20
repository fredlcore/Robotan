package main;

use strict;
use warnings;
use HttpUtils;
use JSON;
my $Robotan_hasJSON = 1;

my $queueErrors = 0;

sub Robotan_Initialize($) {
  my ($hash) = @_;

  $hash->{NOTIFYDEV} = "global";
  $hash->{NotifyFn} = "Robotan_Notify";
  $hash->{GetFn}     = "Robotan_Get";
  $hash->{SetFn}     = "Robotan_Set";
  $hash->{DefFn}     = "Robotan_Define";
  $hash->{AttrList}  = "General_Mowing_Days General_Border_Mowing_Days " .$readingFnAttributes;

  eval "use JSON";
  $Robotan_hasJSON = 0 if($@);

  RemoveInternalTimer($hash);
}

###################################
sub Robotan_Define($$) {
  my ($hash, $def) = @_;

  return "install JSON to use Robotan" if( !$Robotan_hasJSON );

  my @a = split("[ \t][ \t]*", $def);

  return "Wrong syntax: use define <name> Robotan <ip-address> <interval>" if(int(@a) != 4);

  my $name = $a[0];
  my $url=$a[2];
  my $interval=$a[3];

  $hash->{NAME} = $name;
  $hash->{INTERVAL} = $interval if $interval;
  $hash->{URL} = $url if $url;
  $hash->{httpQueue} = [];

  my $defptr = $modules{Robotan}{defptr}{$hash->{URL}};
  return "Robotan $hash->{URL} already defined as '$defptr->{NAME}'" if( defined($defptr) && $defptr->{NAME} ne $name);

  $modules{Robotan}{defptr}{$hash->{URL}} = $hash;

  readingsSingleUpdate($hash, 'state', 'initialized', 1 );

  RemoveInternalTimer($hash, "Robotan_GetStatus");
  my $nexttimer = gettimeofday()+10;
  InternalTimer($nexttimer, "Robotan_GetStatus", $hash);
  $hash->{NEXT_UPDATE} = localtime($nexttimer);

  return undef;
}

###################################
sub Robotan_Notify {
  my ($hash,$dev) = @_;

  return if($dev->{NAME} ne "global");
  return if(!grep(m/^INITIALIZED|REREADCFG$/, @{$dev->{CHANGED}}));

  return undef;
}

###################################
sub Robotan_Undefine($$) {
  my ($hash, $arg) = @_;

  delete $modules{Robotan}{defptr}{$hash->{IP}};

  return undef;
}

###################################
sub Robotan_Attr {
  my ($cmd, $name, $attrName, $attrVal) = @_;

  if( $cmd eq "set" ) {
    $attr{$name}{$attrName} = $attrVal;
    return $attrName ." set to ". $attrVal if( $init_done );
  }

  return;
}

###################################
sub Robotan_GetStatus($) {
  my ($hash) = @_;
  my $name = $hash->{NAME};

  RemoveInternalTimer($hash, "Robotan_GetStatus");
  my $interval = $hash->{INTERVAL};
  my $nexttimer = gettimeofday()+$interval;
  InternalTimer($nexttimer, "Robotan_GetStatus", $hash, 1);
  $hash->{NEXT_UPDATE} = localtime($nexttimer);

  return if( IsDisabled($name) );

  Log3 $name, 3, "$name: getting status";

  my $cmd = "/json";
  Log3 $name, 4, "$name: adding $cmd to http queue...";
  unshift(@{$hash->{httpQueue}}, $cmd);
  &Robotan_ProcessHttpQueue($hash);
}

###################################
sub Robotan_ParseStatus($$) {
  my ($hash, $data) = @_;
  my $name = $hash->{NAME};
  my $decoded = eval { decode_json($data) };

  readingsBeginUpdate($hash);
  foreach my $p ( keys %{$decoded} ) {
    my $reading = $decoded->{$p}{name};
    my $value = $decoded->{$p}{value};
    $reading =~ s/ /_/g;

    if ($reading eq "Functionality") {
      if ($value gt "0") {
        readingsBulkUpdate($hash, "state", "authenticated");
      } else {
        readingsBulkUpdate($hash, "state", "not authenticated");
      }
    }

    if ($reading =~ /Mowing_Days/) {
      my $days = "";
      for (my $x=0; $x<8; $x++) {
        if (($value & 2**$x) > 0) {
          $days .= $x+1 . ",";
        }
      }
      chop ($days);
      $value = $days;
    }

    if (!$attr{$name}{General_Mowing_Days} && $reading eq "Mowing_Days") {
      if ($value gt " ") {
        $attr{$name}{General_Mowing_Days} = $value;
      }
    }

    if (!$attr{$name}{General_Border_Mowing_Days} && $reading eq "Border_Mowing_Days") {
      if ($value lt "0") {
        $value = "0";
      }
      $attr{$name}{General_Border_Mowing_Days} = $value;
    }
    readingsBulkUpdate($hash, $reading, $value);
  }
  readingsEndUpdate($hash,1);
}

###################################
sub Robotan_Get($$@) {
  my ($hash, $name, $cmd, @params) = @_;

  my $list = 'readingsUpdate:noArg';

  if( $cmd eq 'readingsUpdate' ) {
    Robotan_GetStatus($hash);
    return undef;
  }

  $list =~ s/ $//;
  return "Unknown argument $cmd, choose one of $list";
}

###################################
sub Robotan_Set($$@) {
  my ($hash, $name, $cmd, @params) = @_;

  $hash->{".triggerUsed"} = 1;

  my $list = 'Play/Pause:noArg Home/Work:noArg Spiral:noArg Straight:noArg Left:noArg Right:noArg Start_Time_1 End_Time_1 Mowing_Days:multiple-strict,1,2,3,4,5,6,7 Border_Mowing_Days:multiple-strict,0,1,2,3,4,5,6,7 General_Mowing_Days:multiple-strict,1,2,3,4,5,6,7 General_Border_Mowing_Days:multiple-strict,0,1,2,3,4,5,6,7 Mow_Today:0,1';
  $list =~ s/ $//;
  return "Unknown argument $cmd, choose one of $list" if ($cmd eq "?");

  Log3 $name, 3, "$name: setting " . $cmd . " to '" . $params[0]. "'";

  if ($cmd eq "General_Mowing_Days" || $cmd eq "General_Border_Mowing_Days") {
    $attr{$name}{$cmd} = $params[0];
    return undef;
  }

  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  if ($cmd eq "Mow_Today") {
    if ($wday eq "0") {
      $wday = "7";
    }
    my $gmd = $attr{$name}{General_Mowing_Days};
    my $md = ReadingsVal($name, "Mowing_Days", "");
    my $gbmd = $attr{$name}{General_Border_Mowing_Days};
    my $bmd = ReadingsVal($name, "Border_Mowing_Days", "");
    my $mow_today = $params[0];

    if ((($md !~ /$wday/) && $mow_today==0) || (($md =~ /$wday/) && $mow_today==1)) {
      Log3 $name, 3, "$name: Mow_Today: Nothing to do";
      return undef;
    }

    $gmd =~ s/$wday//;
    if ($mow_today == 1) {
      $gmd .= ",$wday";
    }
    $gmd =~ s/,,/,/;

    $cmd = "Mowing_Days";
    $params[0] = $gmd;
    &Robotan_Set($hash, $name, $cmd, @params);

#    if ((($bmd =~ /$wday/) && $mow_today==0) || (($bmd !~ /$wday/) && ($gbmd =~ /$wday/) && $mow_today==1)) {
#      $gbmd =~ s/$wday//;
#      if ($params[0] eq "1") {
#        $gbmd .= ",$wday";
#      }
#      $gbmd =~ s/,,/,/;
#
#      $cmd = "Border_Mowing_Days";
#      $params[0] = $gbmd;
#      &Robotan_Set($hash, $name, $cmd, @params);
#    }

    my $status = ReadingsVal($name, "Status", "0");
    if (($status == 255 && $mow_today == 1) || ($status != 255 && $mow_today == 0)) {
      Log3 $name, 3, "$name: sending home/work";
      $cmd = "Home/Work";
      $params[0] = '';
      &Robotan_Set($hash, $name, $cmd, @params);
      return undef;
    }
  }

  if ($cmd =~ /Mowing_Days/) {
    $params[0] = "0" unless defined $params[0];
    $params[0] =~ s/^,//;
    my $value = 0;
    if ($params[0] gt "0") {
      my @days = split(',', $params[0]);
      foreach my $day (@days) {
        if ($day gt "0") {
          $value = $value + (2**($day-1));
        }
      }
    }
    $params[0] = $value;
  }

  my $param_nr=0;

  if ($cmd =~ /Left/) {
    $param_nr=1;
  }

  if ($cmd =~ /Right/) {
    $param_nr=2;
  }

  if ($cmd =~ /Straight/) {
    $param_nr=3;
  }

  if ($cmd =~ /Spiral/) {
    $param_nr=4;
  }

  if ($cmd =~ /Home/) {
    $param_nr=5;
  }

  if ($cmd =~ /Play/) {
    $param_nr=6;
  }

  if ($cmd eq "Start_Time_1") {
    $param_nr=22;
  }
  if ($cmd eq "End_Time_1") {
    $param_nr=23;
  }
  if ($cmd eq "Mowing_Days") {
    $param_nr=20;
    if ($params[0] lt "1") {
      Log3 $name, 3, "$name: cannot set empty mowing days ($params[0])!";
      return undef;
    }
  }
  if ($cmd eq "Border_Mowing_Days") {
    $param_nr=21;
  }

  $params[0]="" unless defined $params[0];
  $cmd = "/cmd?".$param_nr."=".$params[0];
  Log3 $name, 4, "$name: adding $cmd to http queue...";

  unshift(@{$hash->{httpQueue}}, $cmd);
  &Robotan_ProcessHttpQueue($hash);

  RemoveInternalTimer($hash, "Robotan_GetStatus");
  my $interval = $hash->{INTERVAL};
  my $nexttimer = gettimeofday()+10;
  InternalTimer($nexttimer, "Robotan_GetStatus", $hash, 1);
  $hash->{NEXT_UPDATE} = localtime($nexttimer);

  return undef;
}

###################################
sub Robotan_EvalHttp ($$$) {
  my ($param, $err, $data) = @_;
  my $hash = $param->{hash};
  my $name = $hash->{NAME};
  my $origCmd = $param->{origCmd};
  my $cmd;

  if ($err gt " ") {
    readingsSingleUpdate($hash, "state", "error", 1);
    $hash->{LAST_ERROR_MSG} = "$err";
    $hash->{LAST_ERROR_TIME} = localtime(gettimeofday);
    Log3 $name, 3, "$err";
  }
  $hash->{LAST_HTTP_CODE} = $param->{code};
  $hash->{LAST_PATH} = $param->{path};

  Log3 $name, 4, "$name: HTTP response code: " . $param->{code};
  if ($param->{path} eq "/json") {
    &Robotan_ParseStatus($hash, $data);
    Log 5, "$data";
  } else {
    Log3 $name, 4, "$data";
  }

  if ($data =~ /Writing finished/sgi) {
    $queueErrors = 0;
  }

  if ($data =~ /Writing failed/sgi) {
    if (ReadingsVal($name, "Status", "0") != 255) {
      if ($queueErrors == 0) {
        Log3 $name, 3, "Writing failed, sending Pause, original command, Pause...";
        $cmd = "/cmd?6=";	# Play/Pause
        unshift(@{$hash->{httpQueue}}, $cmd);
        Log3 $name, 3, "Queueing $cmd";
        unshift(@{$hash->{httpQueue}}, $origCmd);
        Log3 $name, 3, "Queueing $origCmd";
        unshift(@{$hash->{httpQueue}}, $cmd);
        Log3 $name, 3, "Queueing $cmd";
      } else {
        Log3 $name, 3, "Won't try to write because of previous write failures - set to pause manually and change parameter";
      }
    } else {
      Log3 $name, 3, "Writing failed despite robot seems to be charging, requeueing...";
      unshift(@{$hash->{httpQueue}}, $origCmd);
      Log3 $name, 3, "Queueing $origCmd";
    }
    $queueErrors++;
    readingsSingleUpdate($hash, "state", "writing error - device not in pause/charging?", 1);
  }

  RemoveInternalTimer($hash, 'Robotan_ProcessHttpQueue');
  InternalTimer(gettimeofday(), 'Robotan_ProcessHttpQueue', $hash );
  return undef;
}

###################################
sub Robotan_ProcessHttpQueue($) {
  my ($hash) = @_;
  my $name = $hash->{NAME};
  my $url = $hash->{URL};
  my $queue_anz = scalar @{$hash->{httpQueue}};
  my $cmd = pop(@{$hash->{httpQueue}});

  if (!defined($cmd)) {
    return "Nothing to process...";
  }

  Log3 $name, 4, "$name: $queue_anz commands still in http queue.";
  my $uri = "http://".$url . $cmd;
  Log3 $name, 3, "$name: processing queue item: $cmd";

  my $param = {
    url => $uri,
    timeout => 20,
    hash => $hash,
    method => "GET",
    callback => \&Robotan_EvalHttp
  };
  $param->{origCmd} = $cmd;
  HttpUtils_NonblockingGet($param);
  $queue_anz = scalar @{$hash->{httpQueue}};
  Log3 $name, 4, "$name: $queue_anz commands still in http queue.";
}

###################################
1;

=pod
=begin html

Robotan module

=end html
=cut
