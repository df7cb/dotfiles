# template.pm
# cb 031004

my $template_file;
my %SUBST_STR;
my %SUBST_SUB;
my $template_output = 0;

sub template_file {
	$template_file = shift || die "template_file: no filename given";
}

# replace key by value
sub template_replace {
	my $k = shift;
	my $v = shift;
	$SUBST_STR{$k} = $v;
}

# replace key by return value of function (might take arguments).
# NOTE: one may use print in functions, but the print output will show up
# before any other stuff from the current line.
sub template_sub {
	my $k = shift;
	my $v = shift;
	$SUBST_SUB{$k} = $v;
}

sub template_print {
	my $l = shift;
	$l =~ s/__IF\((.*)\)\((.*)\)__/eval($1) ? $2 : "";/eg; # __IF(cond)(value)__
	foreach my $k (keys %SUBST_SUB) {
		my $f = $SUBST_SUB{$k};
		$k =~ /^__(\w+)__$/;
		my $k2 = "__$1\\((.*)\\)__";
		if($l =~ /$k2/) {
			my $return = &$f($1);
			$l =~ s/$k2/$return/g;
		}
		$l =~ s/$k/&$f()/eg;
	}
	foreach my $k (keys %SUBST_STR) {
		$l =~ s/$k/$SUBST_STR{$k}/g;
	}
	print $l;
}

sub template_output {
	die "template_output: no output file defined / already spilled out" unless $template_file;
	unless ($template_output) {
		open TEMPLATE, $template_file or die "$template_file: $!";
		$template_output = 1;
	}
	my $stop = shift;
	my $l;
	while(defined($l = <TEMPLATE>)) {
		last if ($stop and $l =~ /$stop/);
		template_print($l);
	}
}

# TODO: template_output should probably not be called upon die()
END {
	template_output if $template_file;
}

$| = 1;

1;
