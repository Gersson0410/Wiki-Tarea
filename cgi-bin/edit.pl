#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $param1 = CGI -> new;
my $param2 = $param1 ->param('param1');
print $param1->header('');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.106";
my $dbh = DBI->connect($dsn,$user,$password);
my $sth = $dbh->prepare("SELECT markdown FROM Wiki WHERE name=?");
$sth->execute($param2);

my $texto;
while(my @row=$sth->fetchrow_array){
  $texto = $row[0];
}



