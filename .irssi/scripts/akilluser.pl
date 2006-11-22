# AKILL a specified nick, either with the defined reason or with something given
# in the command
#
# (C) 2006 by Joerg Jaspert <joerg@debian.org>
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
    name  => 'akilluser',
    description => 'AKILLS a nick',
    license     => 'GPL v2 (and no later)',
);

########################################################################
# Kill it

sub akill_nick {
  my ($arg, $server, $channel) = @_;

  $arg =~ /(\S+)\s?(.*)?/;
  my $nick = $1;
  my $reason = $2;
  if (length($reason) < 2) {
	$reason = Irssi::settings_get_str('akill_reason');
  }
  my $channame = $channel->{name};

  my $nickh=$channel->nick_find($nick);
  if ($nickh->{host} =~ /.*oftc.net/) {         # Do not AKILL staff from oftc.
	Irssi::print("Not AKILLing OFTC staff");
	return;
  }

  $nickh->{host} =~ /(\S+)@(\S+)/;
  my $user = $1;
  my $khost = $2;
  my $window = Irssi::active_win();
  $window->print("AKILLed $nick (ident $user) at $khost with \"$reason\"");
  $server->command("quote os akill add *\@$khost $reason");
}


########################################################################
# ---------- Do the startup tasks ----------

# Add the settings
Irssi::settings_add_str("akilluser.pl", "akill_reason", 'This host violated network policy. If you feel an error has been made, please contact support@oftc.net, thanks.');

Irssi::command_bind('akill', 'akill_nick');
