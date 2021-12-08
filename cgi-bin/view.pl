#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $param1 = CGI -> new;
my $param2 = $param1 ->param('param1');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.106";
my $dbh = DBI->connect($dsn,$user,$password);
my $sth = $dbh->prepare("SELECT markdown FROM Wiki WHERE name=?");
$sth->execute($param2);
my $texto = $sth->fetchrow_array;
$sth->finish;

$dbh->disconnect;

print $param1->header('text/html;charset-UTF-8');
print STDERR "$param2\n";

my @splittedtext = splitString($texto);

my $markdownHTML = generaMarkdown(@splittedtext);
print STDERR "$markdownHTML\n";

my $html = mostrarHTML($markdownHTML,$param2);
print "$html\n";

sub mostrarHTML{
  my @textLines = @_;
  my $markdownHTML = "";

  foreach my $line(@textLines){
 if($line=~/^######([^#]+)([a-zA-Z0-9]+)/){
   $markdownHTML="<h6>".$1.$2."</h6>";
}elsif($line=~/^##([^#]+)([a-zA-Z0-9]+)/){
   $markdownHTML="<h2>".$1.$2."</h2>";
}elsif($line=~/^#([^#]+)([a-zA-Z0-9]+)/){
   $markdownHTML="<h1>".$1.$2."</h1>";
}
if($line=~/^[*]{3}(.+)[*]{3}$/){
   $markdownHTML="<p><strong><em>".$1."</em></strong></p>";
}elsif($line=~/^[~]{2}(.+)[~]{2}$/){
   $markdownHTML="<p>~".$1."~~</p>";
}elsif($line=~/^[*]{2}(.+)[_](.+)[_](.+)[*]{2}$/){
   $markdownHTML="<p><strong>".$1."<em>".$2."</em>".$3."</strong></p>";
}elsif($line=~/^[*]{2}(.+)[*]{2}$/){
   $markdownHTML="<p><strong>".$1."</strong></p>";
}elsif($line=~/^```(.+)```$/){
   $markdownHTML="<p><code>\n".$1."\n"."</code></p>";
}elsif($line=~/^[*]{1}(.+)[*]{1}$/){
   $markdownHTML="<p><em>".$1."</em></p>";
}elsif($line=~/(.+)\[([a-zA-Z0-9]+)\]\(([a-zA-Z0-9]+)\)/){
  $markdownHTML="<p>".$1."<a href='".$3."'>".$2."</a></p>";
}else{
  $markdownHTML="<p>".$line."</p>";
} 
 }
return $markdownHTML; 
}

sub splitString{
  my $texto =$_[0];
  my @splittedString = split(/\n/, $texto);
  return @splittedString;
} 
