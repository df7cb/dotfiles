#!/usr/bin/perl
# $Id$

my $cmd = "";
$cmd = "tar xfv"  if $ARGV[0] =~ /\.tar$/;
$cmd = "tar xfvz" if $ARGV[0] =~ /\.(tgz|tar\.gz|tar\.Z)$/;
$cmd = "tar xfvj" if $ARGV[0] =~ /\.tar\.bz2$/;
$cmd = "unzip" if $ARGV[0] =~ /\.zip$/;
$cmd = "unarj x" if $ARGV[0] =~ /\.arj$/;

if ($cmd eq "") {
	print STDERR "$0 error: suffix not recognized: $ARGV[0]\n";
	exit(1);
}

my $args = join " ", map { "\"$_\""; } @ARGV;
open T, "$cmd $args |" or die "$cmd: $!";
$_ = <T> || 0 or exit 1;
($prefix) = m|(.+)/|;
print STDERR;

while(<T>) {
	print STDERR;
	"$prefix/###$_" =~ m|^(.*)/.*?###\1|;
	$prefix = $1;
}

if($prefix eq "") { exit 1 } else { print "$prefix\n"; exit 0 }
