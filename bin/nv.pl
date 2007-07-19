#!/usr/bin/perl -w
# $Id$

use strict;

if (@ARGV < 2) {
	die "usage: $0 file... directory\n";
}

my $dir = pop @ARGV;
my $dir2;

if (! -d $dir) {
	if (-e $dir) {
		if (not grep { $dir = $_ } @ARGV) {
			print STDERR "$dir exists, but is not a file that would be moved\n";
			exit 2;
		}
		$dir2 = $dir.$$;
	}

	print STDERR "nv: create $dir? ";
	$_ = <STDIN>;
	exit 2 unless /^[yjo]/i;

	mkdir $dir2 || $dir, 0777 or die "mkdir: $!";
}

exit 1 if system "mv -iv '" .
	join("' '", map { s/'/'\\''/g; $_; } @ARGV) .
	"' '". ($dir2 || $dir) ."' 1>&2";

if ($dir2) {
	rename $dir2, $dir or die "$dir: $!";
}

print "$dir\n";
