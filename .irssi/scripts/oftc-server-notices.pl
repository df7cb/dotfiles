use Irssi;
use Irssi::Irc;

# .irssi/scripts/autorun for this, gets your servernotice in different
# colors, so you can see whats going on a bit easier.

sub sig_mynotice {
    return if $already_processed;

    $already_processed = 1;

    my ($server, $msg, $nick, $address, $target) = @_;

    $msg =~ s/(!\w+)\.oftc\.net/$1/ig;
#    $msg =~ s/\.openprojects\.net//ig;
#    $msg =~ s/Notice -- //ig;
#    $msg =~ s/\*\*\* //ig;

#    $nick =~ s/\.openprojects\.net//ig;
#    $nick =~ s/\.oftc\.net//ig;

    $colour_format = '%n'; ## Default for non-hilighted messages

    # Chat/nonautomatic stuff
    if ( $msg =~ s/^ChatOps -- from /ChatOps - /ig ) { $colour_format = '%g'; };
    if ( $msg =~ s/^Global -- from /Global - /ig ) { $colour_format = '%G'; };
    if ( $msg =~ /ChanServ invited/ ) { $colour_format = '%C'; };

    # Routing stuff
    if ( $msg =~ /Server already present from/ ) { $colour_format = '%m'; };

    if ( $msg =~ /Server .* not enabled for connecting/ ) { $colour_format = '%M'; };
    if ( $msg =~ /Connect to.*failed/ ) { $colour_format = '%M'; };
    if ( $msg =~ /connect.*from/i ) { $colour_format = '%M'; };


    if ( $msg =~ /Lost server/ ) { $colour_format = '%R'; };
    if ( $msg =~ /was connected to/ ) { $colour_format = '%R'; };
    if ( $msg =~ /exiting server/ ) { $colour_format = '%R'; };
    if ( $msg =~ /Link.*dropped/ ) { $colour_format = '%R'; };
    if ( $msg =~ /closing link/ ) { $colour_format = '%R'; };

    if ( $msg =~ /introducing.*server/ ) { $colour_format = '%G'; };
    if ( $msg =~ /Routing.*has synched to network data/ ) { $colour_format = '%G'; };
    if ( $msg =~ /Connecting to/ ) { $colour_format = '%G'; };

    if ( $msg =~ /Link with.*established/ ) { $colour_format = '%m'; };
    if ( $msg =~ /Input from.*now compressed/ ) { $colour_format = '%m'; };
    if ( $msg =~ /synch to/ ) { $colour_format = '%m'; };

    # Warning stuff
    if ( $msg =~ /User.*possible spambot/ ) { $colour_format = '%y'; };
    if ( $msg =~ /Acess check/ ) { $colour_format = '%y'; };

    if ( $msg =~ /Received unauthorized connection/ ) { $colour_format = '%Y'; };
    if ( $msg =~ /Nick collision on/ ) { $colour_format = '%Y'; };
    if ( $msg =~ /Nick .*collision on/ ) { $colour_format = '%Y'; };
    if ( $msg =~ /Flood/ ) { $colour_format = '%Y'; };

    if ( $msg =~ /SAMODE/ ) { $colour_format = '%R'; };
    if ( $msg =~ /IGNORING BAD NICK/ ) { $colour_format = '%R'; };
    if ( $msg =~ /Bad Nick: / ) { $colour_format = '%R'; };
    if ( $msg =~ /Remote nick .* on UNKNOWN server/ ) { $colour_format = '%R'; };
    if ( $msg =~ /Can't allocate fd for auth/ ) { $colour_format = '%R'; };
    if ( $msg =~ /No more connections allowed/ ) { $colour_format = '%R'; };
    if ( $msg =~ /All connections in use/ ) { $colour_format = '%R'; };
    if ( $msg =~ /Access denied/ ) { $colour_format = '%R'; };
    if ( $msg =~ /count off by/ ) { $colour_format = '%R'; };

    # Informational
    if ( $msg =~ /Activating cloak for:/ ) { $colour_format = '%c'; };
    if ( $msg =~ /Got SIGHUP/ ) { $colour_format = '%c'; };
    if ( $msg =~ /rehash/ ) { $colour_format = '%c'; };
    if ( $msg =~ /Can't open/ ) { $colour_format = '%C'; };
    if ( $msg =~ /requested by/ ) { $colour_format = '%m'; };

    if ( $msg =~ /Client connecting/ ) { $colour_format = '%g'; };
    if ( $msg =~ /Client exiting/ ) { $colour_format = '%g'; };
    if ( $msg =~ /Nick change: / ) { $colour_format = '%g'; };
    if ( $msg =~ /Channel .* created by / ) { $colour_format = '%y'; };
    if ( $msg =~ /Client exiting.*Server closed connection/ ) { $colour_format = '%y'; };

    if ( $msg =~ /Invalid username: / ) { $colour_format = '%g'; };

    if ( $msg =~ /kline/i ) { $colour_format = '%R'; };
    if ( $msg =~ /K-line/ ) { $colour_format = '%R'; };

    if ( $msg =~ /notable TS delta/ ) { $colour_format = '%R'; };

    $server->command('/^format notice_server '.$colour_format.'{servernotice $0}$1');
    #$server->command('/^format notice_server '.$colour_format.'{servernotice $[-10]0}$1');

    Irssi::signal_emit("message irc notice", $server, $msg,
               $nick, $address, $target);
    Irssi::signal_stop();
    $already_processed = 0;
}

Irssi::signal_add('message irc notice', 'sig_mynotice');

