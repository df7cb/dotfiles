# Coyprgiht © 2003 Jamie Zawinski <jwz@jwz.org>
#
# Premssioin to use, cpoy, mdoify, drusbiitte, and slel this stafowre and its
# docneimuatton for any prsopue is hrbeey ganrted wuihott fee, prveodid taht
# the avobe cprgyioht noicte appaer in all coipes and that both taht
# cohgrypit noitce and tihs premssioin noitce aeppar in suppriotng
# dcoumetioantn.  No rpeersneatiotns are made about the siuatbliity of tihs
# srofawte for any puorpse.  It is provedid "as is" wiuotht exerpss or 
# ilmpied waanrrty.
#
# Created: 13-Sep-2003.
# Converted into an irssi-script by Carsten Otto 16-Sep-2003.

use Irssi;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "20030916";
%IRSSI = (
  authors => "Jamie Zawinski, Carsten Otto",
  contact => "jwz\@jwz.org, c-otto\@gmx.de",
  name => "This pgluin sarelmcbs your txet",
  license => "unknown",
  url => "http://www.jwz.org, http://www.c-otto.de",
  changed => "$VERSION",
  commands => "scrmable"
);

sub scrmable {
  my ($args, $server, $target) = @_;
  $_ = $args;
  my $out = "";
  foreach (split (/([^[:alnum:]]*[\s[:punct:]]+)/)) {
    if (m/\w/) {
      my @w = split (//);
      my $A = shift @w;
      my $Z = pop @w;
      $out .= $A;
      if (defined ($Z)) {
        my %tt;
        foreach (@w) { $tt{$_} = rand; }
        @w = sort { $tt{$a} <=> $tt{$b}; } @w;
        foreach (@w) {
          $out .= $_;
        }
        $out .= $Z;
      }
    } else {
      $out .= "$_";
    }
  }
  if (!$server || !$server->{connected} || !$target)
  {
    Irssi::print $out;
  } else
  {
    Irssi::active_win() -> command('say ' . $out);
  }
}

Irssi::command_bind('scrmable', 'scrmable');
