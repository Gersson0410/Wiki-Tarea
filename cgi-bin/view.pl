#!/usr/bin/perl
use strict;
use warnings;
 
my $line = <STDIN>;
my $dict = ();
print "\n";

if($line=~/^#{6}(.+)/){
   $dict=$1;
     print "<h6>".$dict."</h6>";
}elsif($line=~/^#{2}(.+)/){
   $dict=$1;
    print "<h2>".$dict."</h2>";
}elsif($line=~/^#(.+)/){
   $dict=$1;
    print "<h1>".$dict."</h1>";
}
if($line=~/^[*]{3}(.+)[*]{3}$/){
   $dict=$1;
   print "<p><strong><em>".$dict."</em></strong></p>";
}elsif($line=~/^[*]{2}(.+)[*]{2}$/){
   $dict=$1;
   print "<p><strong>".$dict."</strong></p>";
}elsif($line=~/^[*]{1}(.+)[*]{1}$/){
   $dict=$1;
   print "<p><em>".$dict."</em></p>";
}elsif($line=~/^[~]{2}(.+)[~]{2}$/){
   $dict=$1;
   print "<p>~".$dict."~~</p>";
}
print "\n";
