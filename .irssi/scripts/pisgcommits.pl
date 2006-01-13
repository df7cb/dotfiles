# pisgcommits.pl
# vim:ts=4

use strict;
use POSIX;
# version info
use vars qw($VERSION %IRSSI);
use Irssi 20020325 qw (command_bind command_runsub command timeout_add timeout_remove signal_add_first);

$VERSION = "1.0";
%IRSSI = (
	authors			=> 'cb@df7cb.de',
	name			=> 'pisgcommits',
	description		=> 'Pisg tracker',
	license			=> 'GPL',
	changed			=> '2006-01-13'
);

# privmsg handler
sub pisg_poll {
	my($data, $server, $item)=@_;
	#my($target,$text)=split(/ :/,$data,2);
	#my $dest=($data=~/^#/?$target:$nick);

	# fork to avoid delay
	my($rh,$wh);
	pipe($rh,$wh);
	my $pid=fork();
	if(defined($pid)) {
		# parent
		if($pid>0) {
			close($wh);
			Irssi::pidwait_add($pid);
			my $tag;
			my @args=($rh, \$tag, $data, $server, $item);
			$tag=Irssi::input_add(fileno($rh),INPUT_READ,\&pipe_input,\@args);
			return;
		}
		# child, do the stuff (write output to $wh)
		close($rh);
		# ------------------------------------------------------------------------

my $prfile = "/home/cb/.irssi/pisg-commits";
if(-f $prfile) {
	open M, $prfile;
	while(<M>) {
		print $wh "$_";
	}
	close M;
	unlink $prfile;
}

		# ------------------------------------------------------------------------
		close($wh);
		POSIX::_exit(1);
	}
}

sub pipe_input {
	my($rh, $tag, $data, $server, $item)=@{$_[0]};
	my $text;
	$text.=$_ foreach <$rh>;
	close($rh);
	Irssi::input_remove($$tag);
	foreach my $line (split("\n",$text)) {
		$server->command("msg -quakenet #pisg $line");
	}
}

#Irssi::signal_add_last('event privmsg','on_event_privmsg');
command_bind 'pisgcommits' => sub { pisg_poll(@_) };
