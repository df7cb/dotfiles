# Updated by Pine(tm) 4.21, copyright 1989-1999 University of Washington.
#
# Pine configuration file -- customize as needed.
#
# This file sets the configuration options used by Pine and PC-Pine.  If you
# are using Pine on a Unix system, there may be a system-wide configuration
# file which sets the defaults for these variables.  There are comments in
# this file to explain each variable, but if you have questions about
# specific settings see the section on configuration options in the Pine
# notes.  On Unix, run pine -conf to see how system defaults have been set.
# For variables that accept multiple values, list elements are separated
# by commas.  A line beginning with a space or tab is considered to be a
# continuation of the previous line.  For a variable to be unset its value
# must be blank.  To set a variable to the empty string its value should
# be "".  You can override system defaults by setting a variable to the
# empty string.  Switch variables are set to either "yes" or "no", and
# default to "no".
# Lines beginning with "#" are comments, and ignored by Pine.

# $Id$

########################### Essential Parameters ###########################

# Over-rides your full name from Unix password file. Required for PC-Pine.
personal-name=

# Sets domain part of From: and local addresses in outgoing mail.
user-domain=_MAILDOMAIN_

# List of SMTP servers for sending mail. If blank: Unix Pine uses sendmail.
smtp-server=""

# NNTP server for posting news. Also sets news-collections for news reading.
nntp-server=news.rz.uni-sb.de

# Path of (local or remote) INBOX, e.g. ={mail.somewhere.edu}inbox
# Normal Unix default is the local INBOX (usually /usr/spool/mail/$USER).
inbox-path=

###################### Collections, Folders, and Files #####################

# List of incoming msg folders besides INBOX, e.g. ={host2}inbox, {host3}inbox
# Syntax: optnl-label {optnl-imap-host-name}folder-path
incoming-folders=

# List of directories where saved-message folders may be. First one is
# the default for Saves. Example: Main {host1}mail/[], Desktop mail\[]
# Syntax: optnl-label {optnl-imap-hostname}optnl-directory-path[]
folder-collections=

# List, only needed if nntp-server not set, or news is on a different host
# than used for NNTP posting. Examples: News *[] or News *{host3/nntp}[]
# Syntax: optnl-label *{news-host/protocol}[]
news-collections=""

# List of folder pairs; the first indicates a folder to archive, and the
# second indicates the folder read messages in the first should
# be moved to.
incoming-archive-folders=

# List of context and folder pairs, delimited by a space, to be offered for
# pruning each month.  For example: {host1}mail/[] mumble
pruned-folders=deleted

# Over-rides default path for sent-mail folder, e.g. =old-mail (using first
# folder collection dir) or ={host2}sent-mail or ="" (to suppress saving).
# Default: sent-mail (Unix) or SENTMAIL.MTX (PC) in default folder collection.
default-fcc=

# Over-rides default path for saved-msg folder, e.g. =saved-messages (using first
# folder collection dir) or ={host2}saved-mail or ="" (to suppress saving).
# Default: saved-messages (Unix) or SAVEMAIL.MTX (PC) in default folder collection.
default-saved-msg-folder=

# Over-rides default path for postponed messages folder, e.g. =pm (which uses
# first folder collection dir) or ={host4}pm (using home dir on host4).
# Default: postponed-msgs (Unix) or POSTPOND.MTX (PC) in default fldr coltn.
postponed-folder=

# If set, specifies where already-read messages will be moved upon quitting.
read-message-folder=

# Over-rides default path for signature file. Default is ~/.signature
signature-file=

# List of file or path names for global/shared addressbook(s).
# Default: none
# Syntax: optnl-label path-name
global-address-book=

# List of file or path names for personal addressbook(s).
# Default: ~/.addressbook (Unix) or \PINE\ADDRBOOK (PC)
# Syntax: optnl-label path-name
address-book=

############################### Preferences ################################

# List of features; see Pine's Setup/options menu for the current set.
# e.g. feature-list= select-without-confirm, signature-at-bottom
# Default condition for all of the features is no-.
feature-list=enable-suspend,
	enable-tab-completion,
	enable-unix-pipe-cmd,
	compose-cut-from-cursor,
	enable-aggregate-command-set,
	enable-full-header-cmd,
	expunge-without-confirm,
	quit-without-confirm,
	signature-at-bottom,
	delete-skips-deleted,
	save-will-advance,
	enable-bounce-cmd,
	allow-talk,
	allow-changing-from,
	expunge-without-confirm-everywhere,
	enable-8bit-esmtp-negotiation,
	disable-take-last-comma-first,
	enable-8bit-nntp-posting,
	enable-alternate-editor-cmd,
	enable-arrow-navigation,
	enable-delivery-status-notification,
	enable-exit-via-lessthan-command,
	enable-flag-cmd,
	enable-flag-screen-implicitly,
	enable-goto-in-file-browser,
	enable-jump-shortcut,
	enable-mail-check-cue,
	enable-msg-view-addresses,
	enable-msg-view-attachments,
	enable-msg-view-urls,
	enable-msg-view-web-hostnames,
	enable-print-via-y-command,
	enable-reply-indent-string-editing,
	enable-search-and-replace,
	enable-partial-match-lists,
	expanded-view-of-distribution-lists,
	news-deletes-across-groups,
	print-offers-custom-cmd-prompt,
	print-includes-from-line,
	print-index-enabled,
	use-current-dir,
	use-sender-not-x-sender,
	quell-folder-internal-msg,
	enable-arrow-navigation-relaxed,
	show-plain-text-internally,
	show-selected-in-boldface,
	strip-from-sigdashes-on-reply,
	selectable-item-nobold,
	disable-keymenu,
	enable-fast-recent-test,
	quell-status-message-beeping,
	fcc-without-attachments,
	no-alternate-compose-menu,
	mark-for-cc,
	enable-msg-view-forced-arrows,
	expose-hidden-config

# Pine executes these keys upon startup (e.g. to view msg 13: i,j,1,3,CR,v)
initial-keystroke-list=""

# Only show these headers (by default) when composing messages
default-composer-hdrs=To:,
	Cc:,
	Fcc:,
	Attchmnt:,
	Subject:

# Add these customized headers (and possible default values) when composing
customized-hdrs=From:,
	Reply-To:,
	To:,
	Cc:,
	Bcc:,
	Lcc:,
	Newsgroups:,
	Approved:,
	Organization: "_ORGANIZATION_",
	Attchmnt:,
	Subject:

# When viewing messages, include this list of headers
viewer-hdrs=

# Determines default folder name for Saves...
# Choices: default-folder, by-sender, by-from, by-recipient, last-folder-used.
# Default: "default-folder", i.e. "saved-messages" (Unix) or "SAVEMAIL" (PC).
saved-msg-name-rule=by-nick-of-sender-then-sender

# Determines default name for Fcc...
# Choices: default-fcc, by-recipient, last-fcc-used.
# Default: "default-fcc" (see also "default-fcc=" variable.)
fcc-name-rule=default-fcc

# Sets presentation order of messages in Index. Choices:
# subject, from, arrival, date, size. Default: "arrival".
sort-key=

# Sets presentation order of address book entries. Choices: dont-sort,
# fullname-with-lists-last, fullname, nickname-with-lists-last, nickname
# Default: "fullname-with-lists-last".
addrbook-sort-rule=nickname-with-lists-last

# Sets the default folder and collectionoffered at the Goto Command's prompt.
goto-default-rule=

# Reflects capabilities of the display you have. Default: US-ASCII.
# Typical alternatives include ISO-8859-x, (x is a number between 1 and 9).
character-set=ISO-8859-1

# Specifies the program invoked by ^_ in the Composer,
# or the "enable-alternate-editor-implicitly" feature.
editor=vim

# Specifies the program invoked by ^T in the Composer.
speller=ispell

# Specifies the column of the screen where the composer should wrap.
composer-wrap-column=

# Specifies the string to insert when replying to  message.
reply-indent-string=

# Specifies the string to use when sending a  message with no to or cc.
empty-header-message=

# Program to view images (e.g. GIF or TIFF attachments).
image-viewer=xv

# If "user-domain" not set, strips hostname in FROM address. (Unix only)
use-only-domain-name=

########## Set within or by Pine: No need to edit below this line ##########

# Your default printer selection
printer=lpr

# List of special print commands
personal-print-command=

# Which category default print command is in
personal-print-category=2

# Set by Pine; controls display of "new version" message.
last-version-used=4.30

# This names the path to an alternative program, and any necessary arguments,
# to be used in posting mail messages.  Example:
#                    /usr/lib/sendmail -oem -t -oi
# or,
#                    /usr/local/bin/sendit.sh
# The latter a script found in Pine distribution's contrib/util directory.
# NOTE: The program MUST read the message to be posted on standard input,
#       AND operate in the style of sendmail's "-t" option.
sendmail-path=

# This names the root of the tree to which the user is restricted when reading
# and writing folders and files.  For example, on Unix ~/work confines the
# user to the subtree beginning with their work subdirectory.
# (Note: this alone is not sufficient for preventing access.  You will also
# need to restrict shell access and so on, see Pine Technical Notes.)
# Default: not set (so no restriction)
operating-dir=

# This variable takes a list of programs that message text is piped into
# after MIME decoding, prior to display.
display-filters=_LEADING("-----BEGIN PGP PUBLIC KEY")_ /usr/local/bin/pgp -kaf,
	_LEADING("-----BEGIN PGP MES")_ /usr/local/bin/pgp -mf,
	_LEADING("-----BEGIN PGP SIGNED MES")_ /usr/local/bin/pgpwrap

# This defines a program that message text is piped into before MIME
# encoding, prior to sending
sending-filters=/home/cb/bin/detex,
	/home/cb/bin/pgp_cb,
	/home/cb/bin/pgp_df7cb,
	/usr/local/bin/pgp -feast _RECIPIENTS_ -u cb@fsinfo

# A list of alternate addresses the user is known by
alt-addresses=cb@fsinfo.cs.uni-sb.de,
	df7cb@fsinfo.cs.uni-sb.de,
	berg@studcs.uni-sb.de,
	berg@fsinfo.cs.uni-sb.de,
	chbe0025@stud.uni-sb.de,
	cb@heim-d.uni-sb.de,
	cb@wjpserver.cs.uni-sb.de,
	cb@wurzelausix.cs.uni-sb.de

# This is a list of formats for address books.  Each entry in the list is made
# up of space-delimited tokens telling which fields are displayed and in
# which order.  See help text
addressbook-formats=

# This gives a format for displaying the index.  It is made
# up of space-delimited tokens telling which fields are displayed and in
# which order.  See help text
index-format=msgno date time24 status fromorto subject size

# The number of lines of overlap when scrolling through message text
viewer-overlap=0

# Number of lines from top and bottom of screen where single
# line scrolling occurs.
scroll-margin=2

# The number of seconds to sleep after writing a status message
status-message-delay=

# The approximate number of seconds between checks for new mail
mail-check-interval=60

# Full path and name of NEWSRC file
newsrc-path=

# Path and filename of news configation's active file.
# The default is typically "/usr/lib/news/active".
news-active-file-path=

# Directory containing system's news data.
# The default is typically "/usr/spool/news"
news-spool-directory=

# Path and filename of the program used to upload text from your terminal
# emulator's into Pine's composer.
upload-command=

# Text sent to terminal emulator prior to invoking the program defined by
# the upload-command variable.
# Note: _FILE_ will be replaced with the temporary file used in the upload.
upload-command-prefix=

# Path and filename of the program used to download text via your terminal
# emulator from Pine's export and save commands.
download-command=

# Text sent to terminal emulator prior to invoking the program defined by
# the download-command variable.
# Note: _FILE_ will be replaced with the temporary file used in the downlaod.
download-command-prefix=

# Sets the search path for the mailcap cofiguration file.
# NOTE: colon delimited under UNIX, semi-colon delimited under DOS/Windows/OS2.
mailcap-search-path=

# Sets the search path for the mimetypes cofiguration file.
# NOTE: colon delimited under UNIX, semi-colon delimited under DOS/Windows/OS2.
mimetype-search-path=

# Sets the time in seconds that Pine will attempt to open a network
# connection.  The default is 30, the minimum is 5, and the maximum is
# system defined (typically 75).
tcp-open-timeout=

# Sets the time in seconds that Pine will attempt to open a UNIX remote
# shell connection.  The default is 15, min is 5, and max is unlimited.
# Zero disables rsh altogether.
rsh-open-timeout=

# Sets the version number Pine will use as a threshold for offering
# its new version message on startup.
new-version-threshold=

# If set, specifies where form letters should be stored.
form-letter-folder=

# Sets presentation order of folder list entries. Choices: ,
# 
# Default: "alpha-with-directories-last".
folder-sort-rule=

# Sets message which cursor begins on. Choices: first-unseen, first-recent,
# first, last. Default: "first-unseen".
incoming-startup-rule=

# If no user input for this many hours, Pine will exit if in an idle loop
# waiting for a new command.  If set to zero (the default), then there will
# be no timeout.
user-input-timeout=36

# Sets the name of the command used to open a UNIX remote shell connection.
# The default is tyically /usr/ucb/rsh.
rsh-path=

# Sets the format of the command used to open a UNIX remote
# shell connection.  The default is "%s %s -l %s exec /etc/r%sd"
# NOTE: the 4 (four) "%s" entries MUST exist in the provided command
# where the first is for the command's path, the second is for the
# host to connnect to, the third is for the user to connect as, and the
# fourth is for the connection method (typically "imap")
rsh-command=

# List of programs to open Internet URLs (e.g. http or ftp references).
url-viewers="/usr/bin/lynx -child _URL_",
	"/usr/local/bin/lynx -child _URL_"

# List of mail drivers to disable. See technical notes.
disable-these-drivers=

# Set by Pine; contains data for caching remote address books.
remote-abook-metafile=

# How many extra copies of remote address book should be kept. Default: 3
remote-abook-history=

# Specifies the introduction to insert when replying to a message.
reply-leadin=On _DAYDATE_ _TIME24_, _FROM_ wrote:

# Patterns and their actions are stored here.
#patterns=LIT:pattern="/NICK=DF7CB/TO=dl0uds,tnt" action="/ROLE=1/FROM=Christoph Berg DF7CB <df7cb@heim-d.uni-sb.de>/FCC=owner-tnt-devel/SIG=.signature-df7cb/RTYPE=NC/FTYPE=YES",
#	LIT:pattern="/NICK=default" action="/ROLE=1/RTYPE=YES/FTYPE=YES"
patterns=

# Controls display of color
color-style=use-termdef

# Sets the time in seconds that Pine will attempt to open a UNIX secure
# shell connection.  The default is 15, min is 5, and max is unlimited.
# Zero disables ssh altogether.
ssh-open-timeout=

# Sets the name of the command used to open a UNIX secure shell connection.
# Tyically this is /usr/local/bin/ssh.
ssh-path=

# Sets the format of the command used to open a UNIX secure
# shell connection.  The default is "%s %s -l %s exec /etc/r%sd"
# NOTE: the 4 (four) "%s" entries MUST exist in the provided command
# where the first is for the command's path, the second is for the
# host to connnect to, the third is for the user to connect as, and the
# fourth is for the connection method (typically "imap")
ssh-command=

# Minimum number of minutes between checks for remote address book changes.
# 0 means never check except when opening a remote address book.
# -1 means never check. Default: 5
remote-abook-validity=

# Choose: black,blue,green,cyan,red,magenta,yellow,or white.
normal-foreground-color=white
normal-background-color=black
reverse-foreground-color=black
reverse-background-color=green
title-foreground-color=black
title-background-color=cyan
status-foreground-color=blue
status-background-color=green
keylabel-foreground-color=cyan
keylabel-background-color=black
keyname-foreground-color=cyan
keyname-background-color=blue
selectable-item-foreground-color=yellow
selectable-item-background-color=black
quote1-foreground-color=cyan
quote1-background-color=black
quote2-foreground-color=green
quote2-background-color=black
quote3-foreground-color=magenta
quote3-background-color=black
prompt-foreground-color=
prompt-background-color=
index-to-me-foreground-color=
index-to-me-background-color=
index-important-foreground-color=
index-important-background-color=
index-deleted-foreground-color=white
index-deleted-background-color=red
index-answered-foreground-color=white
index-answered-background-color=blue
index-new-foreground-color=black
index-new-background-color=green
index-recent-foreground-color=
index-recent-background-color=
index-unseen-foreground-color=
index-unseen-background-color=

# When viewing messages, these are the header colors
viewer-hdr-colors=/HDR=Subject/FG=yellow/BG=black,
	/HDR=From/FG=green/BG=black,
	/HDR=to/FG=green/BG=black

# Contains the actual signature contents as opposed to the signature filename.
# If defined, this overrides the signature-file. Default is undefined.
literal-signature=

# Allows a default answer for the prune folder questions. Choices: yes-ask,
# yes-no, no-ask, no-no, ask-ask, ask-no. Default: "ask-ask".
pruning-rule=ask-no

# Network read warning timeout. The default is 15, the minimum is 5, and the
# maximum is 1000.
tcp-read-warning-timeout=

# Network write warning timeout. The default is 0 (unset), the minimum
# is 5 (if not 0), and the maximum is 1000.
tcp-write-warning-timeout=

# If this much time has elapsed at the time of a tcp read or write
# timeout, pine will ask if you want to break the connection.
# Default is 60 seconds, minimum is 5, maximum is 1000.
tcp-query-timeout=

# Patterns and their actions are stored here.
patterns-roles=

# Patterns and their actions are stored here.
patterns-filters=

# Patterns and their actions are stored here.
patterns-scores=

# Patterns and their actions are stored here.
patterns-indexcolors=LIT:pattern="/NICK=Index Color Rule/FROM=cb@/FLDTYPE=EMAIL" action="/ISINCOL=1/INCOL=\/FG=cyan\/BG=black"

# Set by Pine; controls beginning-of-month sent-mail pruning.
last-time-prune-questioned=
