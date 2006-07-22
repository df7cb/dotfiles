#
# $Id$
#
# NickServ interface
#  Original code by Sami Haahtinen / ZaNaGa 
#  Protected channel support added by David McNett <nugget@slacker.com>
#

use strict;

my $cvsid = '$Id$';
my $version = '?';
if( $cvsid =~ /\$Id: [^ ]+ (\d+\.\d+)/ ) {
	$version = $1;
}
my $nickserv_passfile = glob "~/.irssi/nickserv.users";
my $nickserv_chanfile = glob "~/.irssi/nickserv.channels";
my @users = ();
my @chans = ();
my %nickservs = ( 
	openprojects => [ 'NickServ', 'NickServ@services.' ],
	sourceirc    => [ 'NickServ', 'services@sourceirc.net' ],
	cuckoonet    => [ 'NickServ', 'services@irc.cuckoo.com' ],
	slashnet     => [ 'NickServ', 'services@services.slashnet.org' ],
	roxnet       => [ 'NickServ', 'services@ircsystems.net' ],
    oftc         => [ 'NickServ', 'services@services.oftc.net' ],
    techno       => [ 'NickServ', 'services@campus-sbg.at' ],
    euirc        => [ 'NickServ', 'anope@services.eu-irc.net' ],
    cacert       => [ 'NickServ', 'services@wireless' ],
);

use Irssi;
use Irssi::Irc;

sub join_channels {
	my ($server) = @_;
	my $current_ircnet = $server->{'tag'};

	Irssi::print("joining channels for $current_ircnet");
	foreach $_ (@chans) {
		my ($channel, $ircnet) = split(/:/);
		if ($current_ircnet =~ /^$ircnet$/i) {
			Irssi::print("joining $channel");
			$server->send_message("ChanServ", "UNBAN $channel", "-nick");
			sleep 1;
			Irssi::Server::channels_join($server, $channel, 0);
		}
	}
}

sub get_nickpass {
	my ($current_nick, $current_ircnet) = @_;

	foreach $_ (@users) {
		my ($nick, $ircnet, $password) = split(/:/);
		if ($current_nick =~ /^$nick$/i and $current_ircnet =~ /^$ircnet$/i) {
			return $password;
		}
	}
	return 0;
}

sub got_nickserv_msg {
	my ($nick, $server, $text) = @_;
	my $password;

	if ($password = get_nickpass($server->{'nick'}, $server->{'tag'})) {
		# The below is for OPN style.. i need to figure out a way to
		# make this portable
		if ($text =~ /This nickname is owned by someone else/i) {
			Irssi::print("got authrequest from $nick/" . $server->{'tag'});
			$server->send_message("nickserv", "IDENTIFY $password", "-nick");
			Irssi::signal_stop();
		} elsif ($text =~ /^This nickname is registered and protected\.  If it is your/) {
		        Irssi::print("got authrequest from $nick/" . $server->{'tag'});
			$server->send_message("nickserv", "IDENTIFY $password", "-nick");
			Irssi::signal_stop();
		} elsif ($text =~ /^This nick is registered\.  Please choose another\./) {
		        Irssi::print("got authrequest from $nick/" . $server->{'tag'});
			$server->send_message("nickserv", "IDENTIFY $password", "-nick");
			Irssi::signal_stop();
		} elsif ($text =~ /nick, type.+msg NickServ IDENTIFY.+password.+Otherwise,|please choose a different nick./i) {
			Irssi::signal_stop();
		} elsif ($text =~ /Password accepted - you are now recognized./ ||
		         $text =~ /Wow, you managed to remember your password.  That's a miracle by your usual standard./ ) {
			Irssi::print("Got a positive response from $nick/" . $server->{'tag'});
			join_channels($server);
			Irssi::signal_stop();
		}
	}
}

sub event_nickserv_message {
	my ($server, $data, $nick, $address) = @_;
	my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;

	foreach my $key (keys %nickservs) {
		if ( ($nickservs{$key}->[0] =~ /^$nick$/i) 
			and ($nickservs{$key}->[1] =~ /^$address$/i) ) {
			got_nickserv_msg($nick, $server, $text)
		}
	}
}

sub create_users {
	Irssi::print("Creating basic userfile in $nickserv_passfile. please edit it and run /nickserv_read");
	if(!(open NICKUSERS, ">$nickserv_passfile")) {
		Irssi::print("Unable to create file $nickserv_passfile");
	}

	print NICKUSERS "# This file should contain all your protected nicks\n";
	print NICKUSERS "# with the corresponding ircnet tag and password.\n";
	print NICKUSERS "#\n";
	print NICKUSERS "# Nick and IrcNet Tag are case insensitive\n";
	print NICKUSERS "#\n";
	print NICKUSERS "# Nick          IrcNet Tag      Password\n";
	print NICKUSERS "# --------      ----------      --------\n";

	close NICKUSERS;
	chmod 0600, $nickserv_passfile;
}

sub create_chans {
	Irssi::print("Creating basic channelfile in $nickserv_chanfile. please edit it and run /nickserv_read");
	if(!(open NICKCHANS, ">$nickserv_chanfile")) {
		Irssi::print("Unable to create file $nickserv_chanfile");
	}

	print NICKCHANS "# This file should contain a list of all channels\n";
	print NICKCHANS "# which you don't want to join until after you've\n";
	print NICKCHANS "# successfully identified with NickServ.  This is\n";
 	print NICKCHANS "# useful for channels which are access-controlled.\n";
	print NICKCHANS "#\n";
	print NICKCHANS "# Channel       IrcNet Tag\n";
	print NICKCHANS "# --------      ----------\n";

	close NICKCHANS;
	chmod 0600, $nickserv_chanfile;
}

sub read_users {
	my $count = 0;

	# Lets reset @users so we can call this as a function.
	@users = ();

	if (!(open NICKUSERS, "<$nickserv_passfile")) {
		create_users;
	};
	
	Irssi::print("Running checks on the userfile.");

	# first we test the file with mask 066 (we don't actually care if the
	# file is executable by others.. what could they do with it =)
	
	# Well, according to my calculations umask 066 should be 54, go figure.

	my $mode = (stat($nickserv_passfile))[2];
	if ($mode & 54) {
		Irssi::print("your password file should be mode 0600. Go fix it!");
		Irssi::print("use command: chmod 0600 $nickserv_passfile");
	}
	
	# and then we read the userfile.
	# apaprently Irssi resets $/, so we set it here.

	$/ = "\n";
	while( my $line = <NICKUSERS>) {
		if( $line !~ /^(#|\s*$)/ ) { 
			my ($nick, $ircnet, $password) = 
				$line =~ /\s*(\S+)\s+(\S+)\s+(\S+)/;
			push @users, "$nick:$ircnet:$password";
			$count++;
		}
	}
	Irssi::print("Found $count accounts");

	close NICKUSERS;
}

sub read_chans {
	my $count = 0;

	# Lets reset @users so we can call this as a function.
	@chans = ();

	if (!(open NICKCHANS, "<$nickserv_chanfile")) {
		create_chans;
	};
	
	Irssi::print("Running checks on the channelfile.");

	# first we test the file with mask 066 (we don't actually care if the
	# file is executable by others.. what could they do with it =)
	
	my $mode = (stat($nickserv_chanfile))[2];
	if ($mode & 066) {
		Irssi::print("your channels file should be mode 0600. Go fix it!");
		Irssi::print("use command: chmod 0600 $nickserv_chanfile");
	}
	
	# and then we read the channelfile.
	# apaprently Irssi resets $/, so we set it here.

	$/ = "\n";
	while( my $line = <NICKCHANS>) {
		if( $line !~ /^(#|\s*$)/ ) { 
			my ($channel, $ircnet) = 
				$line =~ /\s*(\S+)\s+(\S+)/;
			push @chans, "$channel:$ircnet";
			$count++;
		}
	}
	Irssi::print("Found $count channels");

	close NICKCHANS;
}

sub read_files {
	read_users();
	read_chans();
}


Irssi::signal_add("event notice", "event_nickserv_message");
Irssi::command_bind('nickserv_read', 'read_files');

read_files();
Irssi::print("Nickserv Interface $version loaded...");
