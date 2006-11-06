use Irssi 20020101.0250 ();
$VERSION = "2";
%IRSSI = (
    authors     => 'Christoph Berg',
    contact     => 'myon@debian.org',
    name        => 'bugcomplete',
    description => 'Tab complete bug numbers',
    license     => '',
    url         => '',
);

use strict;

sub sig_bugcomplete {
	my ($complist, $window, $word, $linestart, $want_space) = @_;

	if ($word =~ /^#(\d+)/) {
		push @$complist, "http://bugs.debian.org/$1";
	}
}

Irssi::signal_add_last('complete word', 'sig_bugcomplete');
