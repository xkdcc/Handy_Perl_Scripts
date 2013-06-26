#!/usr/bin/env perl

=pod

=head1 subtitle_tool.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

Handle subtitle files.
My original purpose is to convert English language movie's subtitle file to the format I like.
Then I can listen to the voice of the movies and check the plain lines on my smart phone:)

=head2 DESCRIPTION

=begin html

Easy to go.

=end html

=head2 USAGE        

=begin html

<pre>

Easy to go.

</pre>

=end html

=head2 REQUIREMENTS

=head2 BUGS

=begin html

<B>N/A</B>

=end html

=head2 NOTES

=begin html

<table border=0>
 <tr>  <td width=626 valign=top style='width:469.8pt;border:solid #FFD966 1.0pt;background:#FFF2CC;'>   <p>
<pre>  
Now this perl script is to deal with lyric in srt format.
Sample of srt file:
===============================================================================
14
00:00:46,070 --> 00:00:47,970
早上好
Good morning.

15
00:00:47,970 --> 00:00:52,700
一小时前  我辞去了库克县州检察官职务
An hour ago, I resigned as state's attorney of Cook County.

16
00:00:52,700 --> 00:00:54,200
我心情沉重
I did this with a heavy heart

17
00:00:54,200 --> 00:00:57,430
将与那些诽谤性指控抗争到底
And a deep commitment to fight these scurrilous charges.
===============================================================================

Base on current algorithm, it can't handle following exception:
===============================================================================
52
00:03:02,160 --> 00:03:05,700
6个月后

53
===============================================================================
Because current algorithm expect 5 lines as a section in srt file. Above example just has 4 lines.
That is not ususal case, so I don't want to fix it.
You can quick look thought the output file and find out it and remove the exceptions from origianl srt file and run this script again :)

</pre>  
 </p>  </td> </tr>
</table>

=end html

=head2 AUTHOR

=begin html

<B>Author:</B>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Brant Chen (xkdcc@163.com) </br>
<B>Organization: </B>&nbsp     </br>

=end html

=head2 SEE ALSO

=head2 VERSION_INFOR

=begin html

<B>Version:</B>&nbsp&nbsp 1.0                     </br>
<B>Created:</B>&nbsp&nbsp 2013-6-26 10:37:29 </br>
<B>Revision:</B>&nbsp 1.0                         </br>

=end html

=cut

use strict;
use warnings;
use Encode;
use FindBin qw( $RealBin );

BEGIN {

}

my $ans     = "";
my $infile  = "";
my $outfile = "";
my $line;
my @output_lines = ();
my @output_temp = ();
my ($i, $j, $sec_i, $sec_count)=(0, 0, 0, 6); # $sec_count, means you want how many line to in a section, all lines in this section are in the same language.

print "\n\n";

print "Target File path that you want to handle: ";
chomp( $ans = <STDIN> );

if ( $ans eq "" ) {
  print "[ERR] Bad input. Bye.\n";
  exit 1;
}

# Check relative path and absolute path.
if ( !-e $ans && !-e $RealBin . "/" . $ans ) {
  print "[ERR] File [" . $ans . "] not exist.\n";
  print "      Bad luck. Bye.\n";
  exit 1;
}

$infile = $ans;
unless ( open( IN, $infile ) ) {
  die "[ERR] Open input file [" . $infile . "] failed.\n";
}

$outfile = $infile . ".out";

$i=1;
while ( $line = <IN> ) {
  chomp($line);
  $line = encode("gb2312", decode("utf8", $line));
  
  if ($i%5==1) {
    # Purge @output_temp every $sec_count
    # Because every section in srt file is 5 lines.   
    if ($sec_i > $sec_count * 5) {
      $sec_i = 0;    
      push @output_lines, "\n";
      push @output_lines, @output_temp;
      push @output_lines, "\n";
      @output_temp = ();
    }
    
    $sec_i++;    
    if ($sec_i == 1) {
      push @output_lines, $line . "\n";
    }    
  }
  elsif ($i%5==2) {  
    if ($sec_i == 2) {
      push @output_lines, $line . "\n" ;
    }
  }
  elsif ($i%5==3) {    
    push @output_lines, $line . "\n";
  }  
  elsif ($i%5==4) {
    push @output_temp, $line . "\n";
  }
  $i++;
  $sec_i++;    
}
close(IN);

# Purge the rest @output_temp
if(@output_temp){    
  push @output_lines, "\n";
  push @output_lines, @output_temp;
  push @output_lines, "\n";
  @output_temp = ();
}

unless ( open( OUTFILE, ">$outfile" ) ) {
  die "[ERR] Open output file [" . $outfile . "] failed.\n";
}
print OUTFILE @output_lines;
close(OUTFILE);

print "[INF] Done.\n";

END {

}

