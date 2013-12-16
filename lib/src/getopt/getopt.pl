#!/usr/bin/perl

use Getopt::Std;
getopts('abc:');

print "\$opt_a = $opt_a\n";
print "\$opt_b = $opt_b\n";
print "\$opt_c = $opt_c\n";


use Getopt::Long;
Getopt::Long::config('bundling');
if (!GetOptions (
		'-h'              =>  \$params->{'help'},
		'--help'          =>  \$params->{'help'},
		'--version'       =>  \$params->{'version'},
		'--local-user=s'  =>  \$params->{'local-user'},
		'-m:s'              =>  \$params->{'mail'},
		'--mail:s'          =>  \$params->{'mail'},
		'--key-file=s@'   =>  \$params->{'key-files'},
	)) {
	usage(\*STDERR, 1);
};
