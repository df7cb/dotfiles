#!/usr/bin/perl
# $Id$

my $cmd = "tar xfv";
$cmd = "tar xfvz" if $ARGV[0] =~ /gz$/;
$cmd = "tar xfvj" if $ARGV[0] =~ /bz2$/;
$cmd = "unzip" if $ARGV[0] =~ /zip$/;

open T, "$cmd @ARGV |" or die "$cmd: $!";
$_ = <T> || 0 or exit 1;
($prefix) = m|(.+)/|;
print STDERR;

while(<T>) {
	print STDERR;
	"$prefix/###$_" =~ m|^(.*)/.*?###\1|;
	$prefix = $1;
}

if($prefix eq "") { exit 1 } else { print "$prefix\n"; exit 0 }
