#!/usr/bin/perl
# $Id$

if (@ARGV < 2) {
	die "usage: $0 file... directory\n";
}

$dir = pop @ARGV;

if (! -d $dir) {
	print STDERR "nv: create $dir? ";
	$_ = <STDIN>;
	exit 2 unless /^y/i;
	mkdir $dir, 0777 or die "mkdir: $!";
}

exit 1 if system "mv -iv '" .join("' '", map { s/'/'\\''/g; $_; } @ARGV). "' '$dir' 1>&2";

print "$dir\n";
