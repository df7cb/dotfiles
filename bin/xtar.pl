#!/usr/bin/perl
# $Id$

open T, "tar xfvz @ARGV |" or die "tar: $!";
$_ = <T> || 0 or exit 1;
($prefix) = m|(.+)/|;
print STDERR;

#print STDERR "prefix: $prefix\n";
while(<T>) {
	print STDERR;
	"$prefix/###$_" =~ m|^(.*)/.*?###\1|;
	$prefix = $1;
	#print STDERR "prefix: $prefix _: $_\n";
}

if($prefix eq "") { exit 1 } else { print "$prefix\n"; exit 0 }
