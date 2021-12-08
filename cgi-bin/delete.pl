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
    <title>Página Eliminada</title>
  </head>
  <body>
HTML

#CGI part
my $cgi = CGI->new;
my $name = $cgi->param('name');

#Database part
my $user= 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.104";
my $dbh = DBI->connect($dsn, $user, $password) or die ("No se puede conectar");
#Eliminar datos
my $sth = $dbh->prepare("DELETE from Wiki WHERE name=?");
$sth->execute($name);

$dbh->disconnect;

print <<HTML;
    <h1 class="title-delete">Página eliminada con éxito</h1>
    <h2 class="link-list"><a href="list.pl">Volver a la lista</a></h2>
  </body>
</html>
HTML


