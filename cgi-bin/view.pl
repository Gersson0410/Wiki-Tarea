#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="./../css/styles.css">
    <title>Ver Página</title>
  </head>
  <body>
HTML

my $q = CGI->new;
my $name = $q->param('name');

#Database part
my $user= 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.106";
my $dbh = DBI->connect($dsn, $user, $password) or die ("No se puedo conectar");
#Insertar datos
my $sth = $dbh->prepare("select markdown from wiki where name=?");
$sth->execute($name);
while(my @row = $sth->fetchrow_array){
  print "<p>@row</p>\n";
}
$sth->finish;
$dbh->disconnect;

