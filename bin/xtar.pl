#!/usr/bin/perl
# $Id$

my $targs = "xfv";
$targs = "xfvz" if $ARGV[0] =~ /gz$/;
$targs = "xfvj" if $ARGV[0] =~ /bz2$/;

open T, "tar $targs @ARGV |" or die "tar: $!";
$_ = <T> || 0 or exit 1;
($prefix) = m|(.+)/|;
print STDERR;

while(<T>) {
	print STDERR;
	"$prefix/###$_" =~ m|^(.*)/.*?###\1|;
	$prefix = $1;
}

if($prefix eq "") { exit 1 } else { print "$prefix\n"; exit 0 }
