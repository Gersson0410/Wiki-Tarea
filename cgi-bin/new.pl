#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

#CGI part
#Cabecera
print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Página Creada</title>
  </head>
  <body>
HTML

my $cgi = CGI->new;
my $name = $cgi->param('name');
my $markdown = $cgi->param('markdown');

print "<h1>$name</h1>\n";
print "<p><pre>$markdown</pre></p>\n";

#Database part
my $user= 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.106";
my $dbh = DBI->connect($dsn, $user, $password) or die ("No se puedo conectar");
#Insertar datos
my $sth = $dbh->prepare("INSERT INTO wiki(name,markdown) VALUES(?,?)");
$sth->execute($name, $markdown);

print <<HTML;
    <h2><span>Página grabada</span></h2>
    <h2><a href="./list.pl">Listado de Páginas</h2>
  </body>
</html>
HTML
