# template.pm
# cb 031004

my $template_file;
my %SUBST_STR;
my %SUBST_SUB;
my $template_output = 0;
my $template_stop_rest;

sub template_file {
	$template_file = shift || die "template_file: no filename given";
}

sub template_replace {
	my $k = shift;
	my $v = shift;
	$SUBST_STR{$k} = $v;
}

sub template_sub {
	my $k = shift;
	my $v = shift;
	$SUBST_SUB{$k} = $v;
}

sub template_output {
	die "template_output: no output file defined / already spilled out" unless $template_file;
	my $stop = shift;
	unless ($template_output) {
		open TEMPLATE, $template_file or die "$template_file: $!";
		$template_output = 1;
	}
	if($template_stop_rest) {
		print $template_stop_rest;
		undef $template_stop_rest;
	}
	while(<TEMPLATE>) {
		s/__IF\((.*)\)\((.*)\)__/eval($1) ? $2 : "";/eg; # __IF(cond)(value)__
		foreach my $k (keys %SUBST_SUB) {
			s/(.*)$k/print $1; &{$SUBST_SUB{$k}}/eg;
			my $a = $k;
			$a =~ s/__$/\\((.*)\\)__/;
			s/(.*)$a/print $1; &{$SUBST_SUB{$k}}($2)/eg;
		}
		foreach my $k (keys %SUBST_STR) {
			s/$k/$SUBST_STR{$k}/g;
		}
		if($stop and /(.*)$stop(.*)/s) {
			print $1;
			$template_stop_rest = $2;
			last;
		}
		print;
	}
	undef $template_file unless $stop;
}

# TODO: template_output should probably not be called upon die()
END {
	template_output if $template_file;
}

$| = 1;

1;
