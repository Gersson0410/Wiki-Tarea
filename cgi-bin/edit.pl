#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $name = $q->param('name');
print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.104";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT markdown FROM Wiki WHERE name=?");
$sth->execute($name);
my @row;
my @text;
while (@row = $sth->fetchrow_array){
  push (@text,@row);
}

$sth->finish;
$dbh->disconnect;

my $body = renderBody($name,@text);
print renderHTMLpage('Edit',$body);

sub renderBody{
  my $name = $_[0];
  my $markdown = $_[1];
  my $body = <<"BODY";
     <h1>$name</h1>
     <form action="new.pl">
      <label for="markdown">Texto</label>
        <textarea id="cuadro_texto" name="markdown" required>$markdown</textarea>
      <br>
      <input type="hidden" name="name" value="$name">
      <input type="submit" id="boton_submit" value="Enviar">
    </form>
    <br>
    <a href="list.pl">Cancelar</a>
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
