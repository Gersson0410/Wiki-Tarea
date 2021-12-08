#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $name = $q->param("name");
my $markdown = $q->param("markdown");
print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.104";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT name FROM Wiki WHERE name=?");
$sth->execute($name);
my @row;
my @titles;
while (@row = $sth->fetchrow_array){
  push (@titles,@row);
}
$sth->finish;
my $estado="";

if($titles[0]eq($name)){
  my $sth1 = $dbh->prepare ("UPDATE Wiki SET markdown=? WHERE name=?");
  $sth1->execute($markdown, $name);
  $sth1->finish;
  $estado="Página actualizada";
}
else{
  my $sth2 = $dbh->prepare("INSERT INTO Wiki (name, markdown) VALUES (?,?)");
  $sth2->execute($name, $markdown);
  $sth2->finish;
  $estado="Página grabada";
}
$dbh->disconnect;

my $body = renderBody($name,$markdown,$estado);
print renderHTMLpage('Edit',$body);

sub renderBody{
  my $name = $_[0];
  my $markdown = $_[1];
  my $estado = $_[2];
  my $body = <<"BODY";
  <h1>$name</h1>
    <pre>
$markdown
    </pre>
    <hr>
    <h2>$estado</h2>
    <h3><a href="view.pl?name=$name">Ver Página</a> - <a href="list.pl">Listado de Páginas</a></h3>
BODY
  return $body;
}

sub renderHTMLpage{
  my $title = $_[0];
  my $body = $_[1];
  my $html = <<"HTML";
  <!DOCTYPE html>
  <html lang="es">
    <head>
      <title>$title</title>
      <link rel="stylesheet" href="../css/styles.css">
      <meta charset="UTF-8">
    </head>
    <body>
      $body
    </body>
  </html>
HTML
  return $html;
}
