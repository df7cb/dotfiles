# cb 001213

$ENV{'TZ'} = "CET";

use Pg;
@PG_RESULTSTATUS = qw/PGRES_EMPTY_QUERY PGRES_COMMAND_OK PGRES_TUPLES_OK PGRES_COPY_OUT PGRES_COPY_IN PGRES_BAD_RESPONSE PGRES_NONFATAL_ERROR PGRES_FATAL_ERROR/;
$POSTGRES_PW_FILE = "/home/httpd/secret/postgres-pw";
$POSTGRES_USER = "www";
$POSTGRES_USER_ID = 31; # 31 = postgres
$DO_QUERY_EXIT_ON_ERROR = 1;
$PRINT_TIMESTAMPS = 0;	# whether to print created... fields


sub get_postgres_pw {
	my $f = shift || $POSTGRES_PW_FILE;
	open PW, "$f" or die "$f: $!";
	my $postgres_pw = <PW>;
	close PW;
	chomp $postgres_pw;
	return $postgres_pw;
}

# find out who (integer) we are
sub get_postgres_user_id {
	my $user = shift || $POSTGRES_USER;
	my $result = do_query("select usesysid from pg_user where usename = '$user'");
	my $user_id;
	($user_id) = $result->fetchrow();
	$user_id ||= $POSTGRES_USER_ID; # default to 31=postgres
	return $user_id;
}

sub open_db {
	my $dbname = shift or die "open_db: no DB name given";
	my $user = shift || $POSTGRES_USER;
	my $postgres_pw = shift || get_postgres_pw();
	$conn = Pg::connectdb("dbname=$dbname user=$user password=$postgres_pw");

	if($conn->status != PGRES_CONNECTION_OK) {
		die "postgres: ". $conn->errorMessage;
	}

	# init stuff
	do_query("set datestyle = 'GERMAN'");
	$POSTGRES_USER_ID = get_postgres_user_id();
}


sub do_query {
	my $query = shift;
	my $ignore_errors = shift || 0;

	my $result = $conn->exec($query);
	if($result->resultStatus != PGRES_TUPLES_OK and
			$result->resultStatus != PGRES_COMMAND_OK and
			$DO_QUERY_EXIT_ON_ERROR and !$ignore_errors) {
		die "Postgres query '$query' returned ".
			$PG_RESULTSTATUS[$result->resultStatus]. ": ".
			$conn->errorMessage;
	}
	return $result;
}


sub do_query_print {
	my @args =  @_;

	print "$args[0]: ";
	my $result = do_query(@args);
	print "$PG_RESULTSTATUS[$result->resultStatus]\n";
	return $result;
}


# return type name for type oid
sub type {
	my $type_oid = shift;
	return $TYPE_CACHE{$type_oid} if exists $TYPE_CACHE{$type_oid};
	my $result = do_query("select typname from pg_type where oid = $type_oid");
	return "unknown" unless @row = $result->fetchrow;
	$TYPE_CACHE{$type_oid} = $row[0];
	return $row[0];
}


# render a sql query as a html table
sub html_query {
	my $query = shift;
	my $command = shift || "";

	# über welche Tabellen reden wir?
	$query =~ /from (.*?)\s*(where|order|$)/i or die "Konnte aus '$query' die Tabllen-Namen nicht extrahieren!";
	my @tables = split /\s*,\s*/, $1;
	map { s/ .*//; } @tables;
	$table ||= $tables[0]; # für queryexec

	# ausführen
	my $result = do_query($query);

	# drucken
	my $ntuples = $result->ntuples;
	my $nfields = $result->nfields;
	my @oid_prefix = ();
	my @oid_suffix = ();
	my $t;

	print "<table border>\n<tr>";
	# Titelzeile drucken
	foreach (0..$nfields-1) {
		my $cap = $result->fname($_);
		if($PRINT_TIMESTAMPS == 0 and $cap =~ /^(created|updated)(_by)?$/) { next; }
		print "<th>";
		if ($cap eq "oid") {
			print "<a href=$scriptname?command=new\&table=$tables[0]>Neu</a>";
		} else {
			print "<a href=$scriptname?$command\&order=$cap>$cap</a>";
		}

		$oid_prefix[$_] = "";
		$oid_suffix[$_] = "";
		if($cap eq "oid") {
			$t = shift @tables;
			$oid_prefix[$_] = "<a href=$scriptname?command=edit\&table=$t\&oid=";
			$oid_suffix[$_] = ">Edit</a>";
		}
	}
	print "\n";
	# Typen ausdrucken
	print "<tr>";
	foreach (0..$nfields-1) {
		if($PRINT_TIMESTAMPS == 0 and $result->fname($_) =~ /^(created|updated)(_by)?$/) { next; }
		print "<th>". type($result->ftype($_));
	}
	print "\n";

	# Inhalt drucken
	while (my @row = $result->fetchrow) {
		my $fnr = 0;
		print "\n<tr>";
		foreach (0..$nfields-1) {
			if($PRINT_TIMESTAMPS == 0 and $result->fname($_) =~ /^(created|updated)(_by)?$/) { next; }
			$_ ||= '';
			# print numbers ("0" isn't printed otherwise)
			if(type($result->ftype($_)) eq "int4") {
				printf "<td>%d", $row[$_];
			} else {
				# Hack: stud.uni-sb.de-hook einfügen
				$row[$_] = "<a href=stud?mail=$1>$row[$_]</a>" if
					/(\w+)\@stud/;
				printf "<td>$oid_prefix[$_]". $row[$_] . $oid_suffix[$_];
			}
		}
	}
	print "\n</table>\n";

	print "($ntuples Tupel mit $nfields Feldern)\n";
	my $print_timestamps_toggle = (! $PRINT_TIMESTAMPS) || 0;
	print "<a href=$scriptname?$command\&timestamps=$print_timestamps_toggle>Timestamps anzeigen</a>\n";
}

# render a sql query as a html table
sub print_result_table_text {
	my $result = shift;

	# drucken
	my $ntuples = $result->ntuples;
	my $nfields = $result->nfields;
	my $t;

	# Titelzeile drucken
	foreach (0..$nfields-1) {
		my $cap = $result->fname($_);
		print "$cap ";
	}
	print "\n";
	# Typen ausdrucken
	foreach (0..$nfields-1) {
		print type($result->ftype($_)) ." ";
	}
	print "\n";

	# Inhalt drucken
	while (my @row = $result->fetchrow) {
		my $fnr = 0;
		foreach (0..$nfields-1) {
			# $_ ||= 0;
			# print numbers ("0" isn't printed otherwise)
			if(type($result->ftype($_)) eq "int4") {
				printf "%d", $row[$_];
			} else {
				print $row[$_], " ";
			}
		}
		print "\n";
	}

	print "($ntuples Tupel mit $nfields Feldern)\n";
}

sub pga_query_name {
	my $name = shift;
	my $query = "select querycommand from pga_queries where queryname = '$name'";
	my $result = do_query($query);
	my ($command) = $result->fetchrow();
	return $command;
}

sub pga_query_oid {
	my $oid = shift;
	my $query = "select querycommand from pga_queries where oid = $oid";
	my $result = do_query($query);
	my ($command) = $result->fetchrow();
	return $command;
}

1;
