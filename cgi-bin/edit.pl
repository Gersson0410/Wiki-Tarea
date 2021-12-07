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

print <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset= "UTF-8">
</head>

<body>
  <h2>$param2</h2>
     <form action="new.pl">
          <input type="hidden" name="" value="$param2">
          <label for="">Texto:</label>
          <br>
          <textarea
          $texto
          <br>
 
   <input type="submit" value="Enviar">
  </form>
  <nav class="menu">
  <a href="list.pl">Cancelar</a>
  </nav>
HTML



