#!/usr/bin/perl

use Getopt::Std;
getopts('abc:');

print "\$opt_a = $opt_a\n";
print "\$opt_b = $opt_b\n";
print "\$opt_c = $opt_c\n";
