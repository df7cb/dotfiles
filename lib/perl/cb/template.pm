# template.pm
# cb 031004

my %SUBST_STR;
my %SUBST_SUB;

sub template_file {
	foreach my $f (@_) {
		next unless $f;
		return if open TEMPLATE, $f;
	}
	die "@_: $!"
}

# replace key by value
sub template_replace {
	my $k = shift || warn "template_replace: key undefined";
	my $v = shift;
	warn "template_replace: value for key $k undefined" unless defined($v);
	$SUBST_STR{$k} = $v;
}

# replace key by return value of function (might take arguments).
# NOTE: one may use print in functions, but the print output will show up
# before any other stuff from the current line.
sub template_sub {
	my $k = shift || warn "template_sub: key undefined";
	my $v = shift;
	warn "template_sub: value for key $k undefined" unless defined($v);
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
			if(defined $return) {
				$l =~ s/$k2/$return/g;
			} else {
				warn "$k returned undef";
			}
		}
		if($l =~ /$k/) {
			my $return = &$f();
			if(defined $return) {
				$l =~ s/$k/$return/g;
			} else {
				warn "$k returned undef";
			}
		}
	}
	foreach my $k (keys %SUBST_STR) {
		$l =~ s/$k/$SUBST_STR{$k}/g;
	}
	print $l;
}

sub template_output {
	my $stop = shift;
	my $l;
	while(defined($l = <TEMPLATE>)) {
		last if ($stop and $l =~ /$stop/);
		template_print($l);
	}
}

# TODO: template_output should probably not be called upon die()
END {
	template_output;
}

$| = 1;

1;
