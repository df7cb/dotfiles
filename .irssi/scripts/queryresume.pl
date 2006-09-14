# QueryResume by Stefan Tomanek <stefan@pico.ruhr.de>
#
# Modified by Joerg Jaspert <joerg@debian.org> and Christoph Berg
#  <myon@debian.org>:
# - Works in channels or queries now.
# - doesnt print the box, so it restores how the window looked before you
#   closed it, including timestamps (code stolen from buf.pl).
# - One exception - it only restores chat text, not crap like whois.

use strict;

use vars qw($VERSION %IRSSI);
$VERSION = '2003021201';
%IRSSI = (
    authors     => 'Stefan \'tommie\' Tomanek',
    contact     => 'stefan@pico.ruhr.de',
    name        => 'QueryResume',
    description => 'restores the last lines of a query on re-creation',
    license     => 'GPLv2',
    modules     => 'Date::Format File::Glob',
    changed     => $VERSION,
);  

use Irssi 20020324;
use Date::Format;
use File::Glob ':glob';

my $timestamp_re = '^--- (?:Log opened|Day changed) ([^:]+) ';

sub sig_window_item_new ($$) {
    my ($win, $witem) = @_;
    return unless (ref $witem && $witem->{type} eq 'QUERY');
    #return unless (ref $witem);
    my @data;
    my $filename = Irssi::settings_get_str('autolog_path');
    my $servertag = $witem->{server}->{tag};
    my $name = lc $witem->{name};
    $filename =~ s/\$tag\b|\$\{tag\}|\$1\b|\$\{1\}/$servertag/g;
    $filename =~ s/\$0\b|\$\{0\}/$name/g;
    my @lt = localtime(time);
    my $zone;
    $filename = strftime($filename, @lt, $zone);
    $filename =~ s/(\[|\])/\\$1/g;
    local *F;
    open(F, "<".bsd_glob($filename)) or return;
    my $lines = Irssi::settings_get_int('queryresume_lines');
    my $timestamp_line;
    my $timestamp_day = "";

    #--- Log opened Do Jul 06 00:00:01 2006
    #--- Day changed Do Jul 06 2006
    #02:03 -!- Irssi: Starting query in oftc with Ganneff
    #--- Log closed Fr Jul 07 00:00:36 2006

    foreach (<F>) {
	next if (/^--- Log closed/ || /^[\d:]+ [(-]![-)] /);
	if (/$timestamp_re/o) {
	    if ($timestamp_day eq $1) {
		next;
	    } else {
		pop(@data) if ($timestamp_line); # remove repeated timestamp lines
		$timestamp_line = 1;
		$timestamp_day = $1;
		s/ \d\d:\d\d:\d\d//;
	    }
	} else {
	    $timestamp_line = 0;
	}
	push(@data, $_);
	if (@data > $lines) {
	    if ($data[0] =~ /$timestamp_re/o) {
		splice @data, 1, 1; # keep the first timestamp line
		if ($data[1] =~ /$timestamp_re/o) { # nothing interesting left for this day
		    shift @data;
		}
	    } else {
		shift @data;
	    }
	}
    }
    pop @data if ($data[-1] =~ /$timestamp_re/o);
    my $text = join '', @data;

    my $view = $win->view;
    $view->remove_all_lines();
    $view->redraw();
    $win->gui_printtext_after(undef, MSGLEVEL_NEVER, "--- Reading log $filename\n$text");
    $view->redraw();
}

Irssi::settings_add_int($IRSSI{name}, 'queryresume_lines', 15);

Irssi::signal_add('window item new', 'sig_window_item_new');

# vim:sw=4:
