# $Header$
# cb 011110

$ENV{'TZ'} = "CET";


sub oerks {
	print_contenttype() unless $contenttype_printed;
	$_ = join ' ', @_;
	s/</&lt;/g; s/>/&gt;/g;
	# </ul></td></tr></table>
	print "<p><font color=red>Suddenly, the script named $0 died for some strange reason:\n<pre>$_</pre></font>\n";
	print "<p>Fehlermeldungen bitte an $ENV{SERVER_ADMIN} senden!\n";
	print "<br>Please mail error messages to $ENV{SERVER_ADMIN}!\n";
	my $time = scalar(localtime);
	my $options = $ENV{QUERY_STRING} || "";
	my $path = $ENV{PATH_INFO} || "";
	print STDERR "[$time] [die] $0: @_ [QUERY_STRING=$options PATH_INFO=$path]";
	exit 1;
}
# install handler
$SIG{__DIE__} = \&oerks;

# make warnings more readable in the apache error log
sub warn_oerks {
	my $time = scalar(localtime);
	my $options = $ENV{QUERY_STRING} || "";
	my $path = $ENV{PATH_INFO} || "";
	print STDERR "[$time] [warn] $0: @_ [QUERY_STRING=$options PATH_INFO=$path]";
}
# install handler
$SIG{__WARN__} = \&warn_oerks;


sub print_contenttype {
	my $contenttype = shift || "text/html";
	print "Content-Type: $contenttype\n\n";
	$contenttype_printed = 1;
}


sub lokalzeit {
	my @wday =("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag");
	my @month = ("Januar", "Februar", "M\&auml;rz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember");

	my @zeit = localtime $_[0];
	return sprintf "%s, %d. %s %u, %u:%02u", $wday[$zeit[6]],
		$zeit[3], $month[$zeit[4]], $zeit[5] + 1900,
		$zeit[2], $zeit[1];
};


sub yymmdd2txt {
	my $date = shift;
	my @month = ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember");
	return 1900 + $1
		if $date =~ /^([56789]\d)$/;        # 94
	return 2000 + $1
		if $date =~ /^([01234]\d)$/;        # 01
	return "$1"
		if $date =~ /^((?:19|20)\d\d)$/;        # 2001
	return "$month[$2 - 1] $1"
		if $date =~ /^((?:19|20)\d\d)(\d\d)$/;  # 200104
	return "$month[$2 - 1] ". (($1 > 50 ? 1900 : 2000) + $1)
		if $date =~ /^(\d\d)(\d\d)$/;           # 9805
	return "$3. $month[$2 - 1] ". (($1 > 50 ? 1900 : 2000) + $1)
		if $date =~ /^(\d\d)(\d\d)0?(\d\d?)$/;  # 001213
		# übler Hack: führende Null im Tag weglassen
	return "$3. $month[$2 - 1] $1"
		if $date =~ /^(\d\d\d\d)(\d\d)0?(\d\d?)$/;  # 20001213
	return $date;  # nicht erkannt
}

sub yymmdd2txtlatin1 { # kann irgendwann gelöscht werden
	return yymmdd2txt(shift);
}


sub encode_special {
	my $str = shift;
	$str =~ s/([^\w\d_.\/-])/sprintf "%%%02X", ord($1)/ge;
	return $str;
}


sub decode_special {
	my $str = shift;
	$str =~ s/\%([\dA-Fa-f]{2})/chr(hex($1))/ge;
	return $str;
}


sub html_quotemeta {
	my $str = shift;
	$str =~ s/</&lt;/g;
	$str =~ s/>/&gt;/g;
	return $str;
}


#sub html_quoteall {
#	my $str = shift;
#	$str =~ s/&/&amp;/g;
#	$str =~ s/([^\w\^&<>;,.#_ -])/"&#".ord($1).";"/ge;
#	$str =~ s/</&lt;/g;
#	$str =~ s/>/&gt;/g;
#	return $str;
#}


sub smileyfy {
	$_ = shift;
	my $smiledir = "/icons/smile";

	#s/</\&lt;/g;
	#s/>/\&gt;/g;
	s|:-?\)|<img src=$smiledir/smile.gif>|g;
	s|\(-?:|<img src=$smiledir/elims.gif>|g;
	s|(?<!t);-?\)|<img src=$smiledir/grins.gif>|g;
	s|:-?\(|<img src=$smiledir/oerks.gif>|g;
	s|:-?\]|<img src=$smiledir/zmile.gif>|g;
	s|\[-?:|<img src=$smiledir/elimz.gif>|g;
	s|:-/|<img src=$smiledir/hmpf.gif>|g;  # NICHT :/ wegen http://
	s*:-?\|*<img src=$smiledir/hmm.gif>*g;
	s*((http://|mailto:)[\w\d/.?~@%#=&-]+)*"<a href=\"$1\">" . (length($1) < 50 ? $1 : "[Link]") ."</a>"*egi unless /<a/i;
	return $_;
}


sub useful_header {
	$_ = shift;
	return 0 if $_ eq "AUTH_TYPE";
	return 0 if $_ eq "CONTENT_LENGTH";
	return 0 if $_ eq "CONTENT_TYPE";
	return 0 if $_ eq "DOCUMENT_ROOT";
	return 0 if $_ eq "GATEWAY_INTERFACE";
	return 0 if $_ eq "HTTP_ACCEPT";
	return 0 if $_ eq "HTTP_ACCEPT_CHARSET";
	return 0 if $_ eq "HTTP_ACCEPT_ENCODING";
	return 0 if $_ eq "HTTP_ACCEPT_LANGUAGE";
	return 0 if $_ eq "HTTP_CACHE_CONTROL";
	return 0 if $_ eq "HTTP_CONNECTION";
	return 0 if $_ eq "HTTP_HOST";
	return 0 if $_ eq "HTTP_KEEP_ALIVE";
	return 0 if $_ eq "HTTP_PRAGMA";
	return 0 if $_ eq "PATH";
	return 0 if $_ eq "REQUEST_METHOD";
	return 0 if $_ eq "REQUEST_URI";
	return 0 if $_ eq "SCRIPT_FILENAME";
	return 0 if $_ eq "SCRIPT_NAME";
	return 0 if $_ eq "SERVER_ADDR";
	return 0 if $_ eq "SERVER_ADMIN";
	return 0 if $_ eq "SERVER_NAME";
	return 0 if $_ eq "SERVER_PORT";
	return 0 if $_ eq "SERVER_PROTOCOL";
	return 0 if $_ eq "SERVER_SIGNATURE";
	return 0 if $_ eq "SERVER_SOFTWARE";
	return 0 if $_ eq "TZ";
	return 0 if $_ eq "UNIQUE_ID";
	return 1;
}


sub printenv {
	print "<pre>\n";
	foreach (sort keys %ENV) {
		print "$_=$ENV{$_}\n";
	}
	print "</pre>\n";
}

1;
