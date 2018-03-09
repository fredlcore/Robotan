package main;

use strict;
use warnings;
use Data::Dumper;
use HttpUtils;
use JSON;

sub Robotan_Initialize($) {
  my ($hash) = @_;

  $hash->{NOTIFYDEV} = "global";
  $hash->{NotifyFn} = "Robotan_Notify";
  $hash->{SetFn}     = "Robotan_Set";
  $hash->{DefFn}     = "Robotan_Define";
  $hash->{AttrList}  = "General_Mowing_Days General_Border_Mowing_Days " .$readingFnAttributes;
  $hash->{FW_deviceOverview} = 1;

  RemoveInternalTimer($hash);
}

###################################
sub Robotan_Define($$) {
  my ($hash, $def) = @_;

  my @a = split("[ \t][ \t]*", $def);

  return "Wrong syntax: use define <name> Robotan <ip-address> <interval>" if(int(@a) != 4);

  my $name = $a[0];
  my $url=$a[2];
  my $interval=$a[3];

  $hash->{NAME} = $name;
  $hash->{INTERVAL} = $interval if $interval;
  $hash->{URL} = $url if $url;

  my $defptr = $modules{BSB}{defptr}{$hash->{URL}};
  return "Robotan $hash->{URL} already defined as '$defptr->{NAME}'" if( defined($defptr) && $defptr->{NAME} ne $name);

  $modules{Robotan}{defptr}{$hash->{URL}} = $hash;

  readingsSingleUpdate($hash, 'state', 'initialized', 1 );

  RemoveInternalTimer($hash);
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
sub Robotan_Set($$@) {
  my ($hash, $name, $cmd, @params) = @_;

  $hash->{".triggerUsed"} = 1;

  my $list = 'Start_Time_1 End_Time_1 Mowing_Days:multiple-strict,1,2,3,4,5,6,7 Border_Mowing_Days:multiple-strict,0,1,2,3,4,5,6,7 General_Mowing_Days:multiple-strict,1,2,3,4,5,6,7 General_Border_Mowing_Days:multiple-strict,0,1,2,3,4,5,6,7 Mow_Today:0,1';
  $list =~ s/ $//;
  return "Unknown argument $cmd, choose one of $list" if ($cmd eq "?");

  Log 3, "$name: setting " . $cmd . " to '" . $params[0]. "'";

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
    $gmd =~ s/$wday//;
    $gmd =~ s/,,/,/;
    if ($params[0] eq "1") {
      $gmd .= ",$wday";
    }
    $cmd = "Mowing_Days";
    $params[0] = $gmd;
    Log 3, "$name: setting mowing days to $gmd";
  }

  if ($cmd =~ /Mowing_Days/) {
    $params[0] = "0" unless defined $params[0];
    my $value = 0;
    if ($params[0] gt "0") {
      my @days = split(',', $params[0]);
      foreach my $day (@days) {
        $value = $value + (2**($day-1));
      }
    }
    $params[0] = $value;
  }

  my $param_nr=0;
  if ($cmd eq "Start_Time_1") {
    $param_nr=40;
  }
  if ($cmd eq "End_Time_1") {
    $param_nr=41;
  }
  if ($cmd eq "Mowing_Days") {
    $param_nr=38;
    if ($params[0] lt "1") {
      Log 3, "$name: cannot set empty mowing days!";
      return undef;
    }
  }
  if ($cmd eq "Border_Mowing_Days") {
    $param_nr=39;
  }
  my $url = "http://".$hash->{URL}."/cmd?".$param_nr."=".$params[0];
  Log 3, "$name: $url";
  my $param = {
    url => $url,
    timeout => 20,
    hash => $hash,
    method => "GET",
    callback => \&Robotan_Eval_HTTP
  };
  $param->{cl} = $hash->{CL} if( ref($hash->{CL}) eq 'HASH' );

  HttpUtils_NonblockingGet($param);

  RemoveInternalTimer($hash);
  my $interval = $hash->{INTERVAL};
  my $nexttimer = gettimeofday()+10;
  InternalTimer($nexttimer, "Robotan_GetStatus", $hash, 1);
  $hash->{NEXT_UPDATE} = localtime($nexttimer);

  return undef;
}

###################################
sub Robotan_GetStatus($) {
  my ($hash) = @_;
  my $name = $hash->{NAME};

  RemoveInternalTimer($hash);
  my $interval = $hash->{INTERVAL};
  my $nexttimer = gettimeofday()+$interval;
  InternalTimer($nexttimer, "Robotan_GetStatus", $hash, 1);
  $hash->{NEXT_UPDATE} = localtime($nexttimer);

  return if( IsDisabled($name) );

  Log 3, "$name: getting status";

  my $target = $hash->{URL};
  my $url = "http://".$target."/json";

  my $param = {
    url => $url,
    timeout => 20,
    hash => $hash,
    method => "GET",
    callback => \&Robotan_Parse
  };
  $param->{cl} = $hash->{CL} if( ref($hash->{CL}) eq 'HASH' );

  HttpUtils_NonblockingGet($param);
}

###################################
sub Robotan_Parse($$$) {
  my ($param, $err, $data) = @_;
  my $hash = $param->{hash};
  my $name = $hash->{NAME};
  my $decoded = eval { decode_json($data) };

  if ($err gt " ") {
    readingsSingleUpdate($hash, "state", "error", 1);
    $hash->{LAST_ERROR_MSG} = "$err";
    $hash->{LAST_ERROR_TIME} = localtime(gettimeofday);
    return undef;
  }

  readingsBeginUpdate($hash);
  foreach my $p ( keys %{$decoded} ) {
    my $reading = $decoded->{$p}{name};
    my $value = $decoded->{$p}{value};
    $reading =~ s/ /_/g;

    if ($reading eq "Authenticated") {
      if ($value eq "1") {
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

    readingsBulkUpdate($hash, $reading, $value);
  }
  readingsEndUpdate($hash,1);

  if (!$attr{$name}{General_Mowing_Days}) {
    my $gmd = ReadingsVal($name, 'Mowing_Days', '');
    my $days = "";
    for (my $x=0; $x<8; $x++) {
      if (($gmd & 2**$x) > 0) {
        $days .= $x+1 . ",";
      }
    }
    chop ($days);
    if ($days gt " ") {
      $attr{$name}{General_Mowing_Days} = $days;
    }
  }
  if (!$attr{$name}{General_Border_Mowing_Days}) {
    my $gbmd = ReadingsVal($name, 'Border_Mowing_Days', '');
    my $days = "";
    if ($gbmd gt "") {
      for (my $x=0; $x<8; $x++) {
        if (($gbmd & 2**$x) > 0) {
          $days .= $x+1 . ",";
        }
      }
    }
    chop ($days);
    if ($days lt "0") {
      $days = "0";
    }
    $attr{$name}{General_Border_Mowing_Days} = $days;
  }
}

###################################
sub Robotan_Eval_HTTP ($$$) {
  my ($param, $err, $data) = @_;
  my $hash = $param->{hash};
  my $name = $hash->{NAME};

  if ($err gt " ") {
    readingsSingleUpdate($hash, "state", "error", 1);
    $hash->{LAST_ERROR_MSG} = "$err";
    $hash->{LAST_ERROR_TIME} = localtime(gettimeofday);
  }
  return undef;
}

###################################

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
1;

=pod
=begin html

Robotan module

=end html
=cut
