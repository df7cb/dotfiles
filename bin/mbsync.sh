#!/bin/sh

CHANNEL="$1"
HOST=$(echo "$CHANNEL" | sed -e 's/[.\/ -].*//')
LOCK=$HOME/mail.mbsync.$HOST.lock

if ip addr show dev eth0 2> /dev/null | fgrep -q 192.168.17. ; then
	SOCKS=tsocks
fi

$SOCKS flock -n "$LOCK" mbsync -q "$CHANNEL"
