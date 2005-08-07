# $Id$
#

package addressbook;

use Text::Iconv;
my $iconv;

sub iconv {
	$iconv = Text::Iconv->new(@_);
}

sub addr_get_line {
	my $line = shift;
	chomp $line;
	$line = $iconv->convert($line) if $iconv;

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
		koordinaten	=> $line[15],
	};

	if($fields->{geburtstag}) {
		$fields->{geburtstag} =~ /^(?:(\d+)\.(\d+)\.)?(\d*)$/ or warn "line $.: $fields->{nachname}: parse errror $fields->{geburtstag}\n";
		$fields->{geb_tag} = $1;
		$fields->{geb_mon} = $2;
		$fields->{geb_jahr} = $3;
	}
	if($fields->{koordinaten}) {
		$fields->{koordinaten} =~ s/,/./g;
		$fields->{koordinaten} =~ /^([\d.]+)\/([\d.]+)$/ or warn "line $.: $fields->{nachname}: parse errror $fields->{koordinaten}\n";
		$fields->{koord_lat} = $1;
		$fields->{koord_long} = $2;
	}

	bless $fields;
}

#sub addr_set_line {
#	return "$vorname;$nachname;$zusatz;$strasse;$land;$plz;$ort;$geburtstag;$tel_priv;$tel_arbeit;$fax;$email;$www;$kategorie;$bemerkung";
#}

1;
