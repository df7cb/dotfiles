# $Id$
#

package addressbook;

sub addr_get_line {
	my $line = shift;
	chomp $line;

# Christoph;Berg;DF7CB;Uni 18, 2405;D;66123;Saarbrücken;9.3.1977;0681/9657944, 0179/4530792;5573;3065;cb@heim-d.uni-sb.de, cb@cs.uni-sb.de;rw4.cs.uni-sb.de/~cb/;vdl;

	my @line = split /;/, $line, -1;
	my $fields = {
		vorname		=> $line[0],
		nachname	=> $line[1],
		zusatz		=> $line[2],
		strasse		=> $line[3],
		land		=> $line[4],
		plz			=> $line[5],
		ort			=> $line[6],
		geburtstag	=> $line[7],
		tel_priv	=> $line[8],
		tel_arbeit	=> $line[9],
		fax			=> $line[10],
		email		=> $line[11],
		www			=> $line[12],
		kategorie	=> $line[13],
		bemerkung	=> $line[14],
	};

	if($fields->{geburtstag}) {
		$fields->{geburtstag} =~ /^(?:(\d+)\.(\d+)\.)?(\d*)$/;
		$fields->{geb_tag} = $1;
		$fields->{geb_mon} = $2;
		$fields->{geb_jahr} = $3;
	}

	bless $fields;
}

#sub addr_set_line {
#	return "$vorname;$nachname;$zusatz;$strasse;$land;$plz;$ort;$geburtstag;$tel_priv;$tel_arbeit;$fax;$email;$www;$kategorie;$bemerkung";
#}

1;
