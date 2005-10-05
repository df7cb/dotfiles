# muttwiki.pl
# vim:ts=4

use strict;
use POSIX;
# version info
use vars qw($VERSION %IRSSI);
use Irssi 20020325 qw (command_bind command_runsub command timeout_add timeout_remove signal_add_first);

$VERSION = "1.0";
%IRSSI = (
	authors			=> 'cb@df7cb.de',
	name			=> 'MuttWiki tracker',
	description		=> 'MuttWiki tracker',
	license			=> 'GPL',
	changed			=> '2004-12-07'
);

# privmsg handler
sub muttwiki_poll {
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
#MuttFaq/Appearance 6:17 pm (2 changes)  [undo spam] . . . . . DSL01.212.114.235.62.NEFkom.net
#Glanzmann 8:25 am  . . . . . Glanzmann
#RecentChanges 1:58 pm (edit) [reformatting] . . . . . Myon

my $f = "wget -O - -q 'http://wiki.mutt.org/index.cgi?action=rc&days=1&showedit=1' |";
my $s = "/home/cb/.irssi/muttwiki.dat";

my %S;
my %N;

if(-e $s) {
	open S, "$s" or die "$s: $!";
	while(<S>) {
		chomp;
		$S{$_} = 1;
	}
	close S;
}

open F, "$f" or die "$f: $!";
my $opened = 0;
while(<F>) {
	if(/^<li><a href=/) {
		chomp;
		s/<[^>]*>//g;
		s/^\(diff\)  //;
		s/\(\d+ changes\) //;
		s/\(edit\) //;
		s/ \d{1,2}:\d\d [ap]m //;
		s/(.*) \. \. \. \. \. (.*)/$2 changed $1/;
		unless($opened) {
			open S, ">$s" or die ">$s: $!";
			$opened = 1;
		}
		print S "$_\n";
		push @{$N{$2}}, $1 unless $S{$_};
	}
}
close S if $opened;
close F;

if(%N) {
	print $wh "MuttWiki: ", (join "; ", map { "$_ changed ". join ", ", @{$N{$_}}; } sort keys %N), "\n";
}

# announce mutt PRs
my $prfile = "/home/cb/.irssi/mutt-newpr";
if(-f $prfile) {
	open M, $prfile;
	while(<M>) {
		print $wh "New PR:$_";
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
		#$server->command("msg $dest $line");
		$server->command("msg -freenode #mutt $line");
	}
}

#Irssi::signal_add_last('event privmsg','on_event_privmsg');
command_bind 'muttwiki' => sub { muttwiki_poll(@_) };
