# $Id$
#

sub addr_get_line {
	my $line = shift;
	chomp $line;

# Christoph;Berg;DF7CB;Uni 18, 2405;D;66123;Saarbrücken;9.3.1977;0681/9657944, 0179/4530792;5573;3065;cb@heim-d.uni-sb.de, cb@cs.uni-sb.de;rw4.cs.uni-sb.de/~cb/;vdl;

	my @line = split /;/, $line;
	$vorname	= $line[0] || "";
	$nachname	= $line[1] || "";
	$zusatz		= $line[2] || "";
	$strasse	= $line[3] || "";
	$land		= $line[4] || "";
	$plz		= $line[5] || "";
	$ort		= $line[6] || "";
	$geburtstag	= $line[7] || "";
	if($geburtstag ne "") {
		$geburtstag =~ /^(?:(\d+)\.(\d+)\.)?(\d*)$/;
		$geb_tag = $1;
		$geb_mon = $2;
		$geb_jahr = $3;
	} else {
		undef $geb_tag; undef $geb_mon; undef $geb_jahr;
	}
	$tel_priv	= $line[8] || "";
	$tel_arbeit	= $line[9] || "";
	$fax		= $line[10] || "";
	$email		= $line[11] || "";
	$www		= $line[12] || "";
	$kategorie	= $line[13] || "";
	$bemerkung	= $line[14] || "";

	return $line;
}

sub addr_set_line {
	return "$vorname;$nachname;$zusatz;$strasse;$land;$plz;$ort;$geburtstag;$tel_priv;$tel_arbeit;$fax;$email;$www;$kategorie;$bemerkung";
}

1;
