#!/bin/sh

HOST=$(eval echo \${$#} | sed -e 's/[.\/ -].*//')
LOCK=$HOME/mail/.mbsync.$HOST.lock

if netstat -tln | grep -q 127.0.0.1:1080 ; then
	SOCKS=tsocks
fi

$SOCKS flock -n "$LOCK" mbsync "$@"
