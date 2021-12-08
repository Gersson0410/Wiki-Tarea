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

my $body = renderBody(@text);
print renderHTMLpage('View',$name,$body);

sub renderBody{

  my @lines = @_;
  my $texto = "";
  #convierto el string en array para usar la funcion matchLine
  my @lineas = split "\n", $lines[0];
  my $num_lineas = @lineas;

  for (my $i=0; $i<$num_lineas; $i++){
    my $linea_convertida = "";
    if ($lineas[$i] =~ /^(```)/){
      $i++;
      my $code = "<pre><code>\n";
      my $code2 = "</code></pre><br>\n";
      my $textcode = "";
      for ($i; !($lineas[$i] =~ /^(```)/) && $i<$num_lineas; $i++){
        $textcode.="   $lineas[$i]\n";
      }
      $texto.="$code$textcode$code2";
    }
    else {
      $linea_convertida = matchLine($lineas[$i]); }
    $texto.="$linea_convertida";
  }

  my $body = <<"BODY";
   $texto
BODY
  return $body;
}

sub matchLine{
  my $linea = $_[0];

  #El primer if para descartar las lineas en blanco
  if (!($linea =~ /^\s*$/ )){

    while ($linea =~ /(.*)(\_)(.*)(\_)(.*)/){
      $linea = "$1<em>$3</em>$5";
    }

    while ($linea =~ /(.*)(\[)(.*)(\])(\()(.*)(\))(.*)/) {
      $linea = "$1<a href='$6'>$3</a>$8";
    }

    while ($linea =~ /(.*)(\*\*\*)(.*)(\*\*\*)(.*)/) {
      $linea = "$1<strong><em>$3</em></strong>$5";
    }

    while ($linea =~ /(.*)(\*\*)(.*)(\*\*)(.*)/) {
      $linea = "$1<strong>$3</strong>$5";
    }

    while ($linea =~ /(.*)(\*)(.*)(\*)(.*)/) {
      $linea = "$1<em>$3</em>$5";
    }

    while ($linea =~ /(.*)(\~\~)(.*)(\~\~)(.*)/){
      $linea = "$1<del>$3</del>$5";
    }

    if ($linea =~ /^(\#)([^#\S].*)/) {
      return $linea = "<h1>$2</h1>\n";
    }
        elsif ($linea =~ /^(\#\#)([^#\S].*)/) {
      return $linea = "<h2>$2</h2>\n";
    }

    elsif ($linea =~ /^(\#\#\#)([^#\S].*)/) {
      return $linea = "<h3>$2</h3>\n";
    }

    elsif ($linea =~ /^(\#\#\#\#)([^#\S].*)/) {
      return $linea = "<h4>$2</h4>\n";
    }

    elsif ($linea =~ /^(\#\#\#\#\#)([^#\S].*)/) {
      return $linea = "<h5>$2</h5>\n";
    }

    elsif ($linea =~ /^(\#\#\#\#\#\#)([^\S].*)/) {
      return $linea = "<h6>$2</h6>\n";
    }

    else {
      return $linea = "<p>$linea</p>\n";
    }
  }
}

sub renderHTMLpage{
  my $title = $_[0];
  my $titulo = $_[1];
  my $body = $_[2];
  my $link_delete = "<a href='delete.pl?fn=$titulo' id='linkboton'>X</a>";
  my $link_edit = "<a href='edit.pl?fn=$titulo' id='linkboton'>E</a>";
  my $html = <<"HTML";
    <!DOCTYPE html>
     <html lang="es">
     <head>
     <title>$title</title>
     <link rel="stylesheet" href="../css/styles.css">
     <meta charset="UTF-8">
     </head>
       <body>
        <h2><a href="list.pl">Retroceder</a> - $link_delete $link_edit</h2>
         $body
       </body>
    </html>
HTML
  return $html;
}
