# Run a challenge response oper thingie
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


# This script needs "rsa_respond" out of the hybrid ircd to actually work.
# svn for that is svn+ssh://helium.oftc.net/svn/oftc-hybrid
# And you need to have an rsa keypair in your oper block. Create one with
# openssl genrsa -des3 1024 > oper-whatever.key
# openssl rsa -pubout < oper-whatever.key > oper-whatever.pub
# and send the .pub to your noc :)

# You have two settings to change after loading this script, just type
# /set challenge to see them. Then you can use it in the future to oper by
# typing /cr YOUROPERNICK


use strict;
use Irssi;

use vars qw($VERSION %IRSSI);


$VERSION = '0.0.0.0.1.alpha.0.2';
%IRSSI = (
    authors     => 'Joerg Jaspert',
    contact     => 'joerg@debian.org',
    name  => 'challenge',
    description => 'Performs challenge-response oper auth',
    license     => 'GPL v2 (and no later)',
);


# Gets called from user, $arg should only contain the oper name
sub challenge_oper {
  my ($arg, $server, $window) = @_;

  if (length($arg) < 2) { # a one char oper name? not here
	print CLIENTCRAP "%B>>%n call it like /cr YOUROPERNICK";
	return;
  } else {
    $server->redirect_event('challenge', 1, "", -1, undef,
			    {
			     "" => "redir challenge received",
			    });
	$server->send_raw("challenge $arg");
  }
}


# This event now actually handles the challenge, the rest was just setup
sub event_challenge_received{
  my ($server, $data) = @_;
  # Data contains "nick :challenge"
  my (undef, $challenge) = split(/:/, $data);

  my $key = Irssi::settings_get_str('challenge_oper_key');
  my $respond = Irssi::settings_get_str('challenge_rsa_path');

  my $pid = open(RSA, "$respond $key $challenge |") or die "Damn, couldnt run $respond";
  my $response = <RSA>;
  close (RSA);
  $server->send_raw("challenge +$response");
  my $window = Irssi::active_win();
  $window->command("redraw");
}


# ---------- Do the startup tasks ----------

Irssi::command_bind('cr', 'challenge_oper');

# Add the settings
Irssi::settings_add_str("challenge.pl", "challenge_oper_key", "/home/joerg/.irssi/oper-ganneff.key");
Irssi::settings_add_str("challenge.pl", "challenge_rsa_path", "/home/joerg/bin/respond");

# Ok, setup the redirect event, so we can later handle the challenge thing.
Irssi::Irc::Server::redirect_register("challenge",
									  0, # not a remote one
									  5, # wait at max 5 seconds for a reply
									  undef, # no start event
									  {
									   "event 386" => -1, # act on the 386, the rsa challenge
									  },
									  undef, # no optional event
									 );
Irssi::signal_add({'redir challenge received' => \&event_challenge_received,});
