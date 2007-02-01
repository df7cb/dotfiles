# AKILL a specified nick, either with the defined reason or with something given
# in the command
#
# (C) 2006 by Joerg Jaspert <joerg@debian.org>
# (C) 2007 by Christoph Berg <cb@df7cb.de>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this script; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


use strict;
use Irssi;

use vars qw($VERSION %IRSSI);


$VERSION = '0.0.0.0.1.alpha.0.0.1';
%IRSSI = (
    authors     => 'Joerg Jaspert',
    contact     => 'joerg@debian.org',
    name        => 'akilluser',
    description => 'AKILLS a nick',
    license     => 'GPL v2 (and no later)',
);

########################################################################
# Kill it

sub akill_nick {
  my ($arg, $server, $channel) = @_;

  $arg =~ /(\S+)\s?(.*)?/;
  my ($target, $reason) = ($1, $2);
  my ($user, $host);

  if ($target =~ /(.+)@(.+)/) {
    ($user, $host) = ($1, $2);
  } else {
    if (!$channel) {
      Irssi::print("Not joined to a channel");
      return;
    }
    my $nickh = $channel->nick_find($target);
    if (!$nickh->{host}) {
      Irssi::print("User $target not found on $channel->{name}");
      return;
    }
    if ($nickh->{host} =~ /\.oftc\.net$/) {         # Do not AKILL staff from oftc.
      Irssi::print("Not AKILLing OFTC staff");
      return;
    }
    $nickh->{host} =~ /(\S+)@(\S+)/;
    ($user, $host) = ("*", $2);
  }

  if ("$user$host" !~ /[\w\d]/) {
    Irssi::print("AKILLing $user\@$host looks insane");
    return;
  }

  if (length($reason) < 2) {
    $reason = Irssi::settings_get_str('akill_reason');
  }
  if ($reason !~ /\@oftc\.net/) {
    $reason .= " " . Irssi::settings_get_str('akill_trailer');
  }

  my $window = Irssi::active_win();
  $window->print("AKILLed $target ($user\@$host) with \"$reason\"");
  $server->command("quote os akill add $user\@$host $reason");
}


########################################################################
# ---------- Do the startup tasks ----------

# Add the settings
Irssi::settings_add_str("akilluser.pl", "akill_reason", 'This host violated network policy.');
Irssi::settings_add_str("akilluser.pl", "akill_trailer", 'Mail support@oftc.net if you think this in error.');

Irssi::command_bind('akill', 'akill_nick');
