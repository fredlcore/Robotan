#!/usr/bin/perl

open (EEPROM, "$ARGV[0]");
while ($line = <EEPROM>) {
  $dump .= $line;
}

$dump_layout = unpack("C", substr($dump, 1, 1));

@structure = (
  "Model code", "0x%X", "C", 0x00, 1, 1,
  "Password", "%04d", "n", 0x57, 2, 1,
  "First charge (Y/M/D)", "20%02d/%02d/%02d", "CCC", 0x89,3, 1,
  "Last service (Y/M/D)", "20%02d/%02d/%02d", "CCC", 0x83,3, 1,
  "Total work time", "%d hours", "L>", 0x53, 4, 1/60,
  "Last error (Y/M/D)", "20%d/%02d/%02d", "CCC", 0x4b,3, 1,
  "Last Bluetooth device", "%02X:%02X:%02X:%02X:%02X:%02X","CCCCCC", 0x0f, 6, 1
);

for ($x=0; $x<scalar @structure; $x=$x+6) {
  $desc = $structure[$x];
  $format = $structure[$x+1];
  $pattern = $structure[$x+2];
  $index = $structure[$x+3];
  $len = $structure[$x+4];
  $factor = $structure[$x+5];
  if ($index > 0x6E && $dump_layout < 0x14) {
    $index--;
  }
  print sprintf("$desc: $format\n", unpack($pattern, substr($dump, $index-$offset, $len)) * $factor);
}
