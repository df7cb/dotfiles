#!/bin/bash
#echo '$Id$'
#set -x

echo
echo "`date` $0: start"

cd $HOME
. lib/locale.sh
. ./.path

if [ "$SHELL" = /bin/sh ] ; then
	if SHELL=`which bash` ; then
		echo "$0: starting bash"
		exec $SHELL $0
		echo "failed"
	fi
	SHELL=/bin/sh
fi

. ./.env

XVENDOR=$(xdpyinfo | grep '^vendor string' | sed -e 's/.*: *//')

# set up X server
xhost - >/dev/null
xkbd load
xrdb .Xdefaults
xset b 0 0  # xset b off does not work
xset r rate 400 30

if [[ "$XVENDOR" != *VNC* ]] ; then
	dpmsoff init
	xsetroot -solid navy &
	if type -p clipit > /dev/null ; then
		clipit &
	elif type -p autocutsel > /dev/null ; then
		autocutsel &
	fi
	type -p wicd-client > /dev/null && wicd-client --tray &
	if type -p ssh-agent > /dev/null ; then
		[ -z "$SSH_AUTH_SOCK" ] && eval `ssh-agent`
		if [ "$SSH_AUTH_SOCK" ] ; then
			for key in .ssh/*.pub ; do
				[ -f "$key" ] || break
				KEY="$KEY .ssh/$(basename $key .pub)"
			done
			[ "$KEY" ] && ssh-add $KEY < /dev/null # there are keys
			unset KEY
		fi
	fi
	type -p gpg-agent > /dev/null && [ -z "$GPG_AGENT_INFO" ] && \
		eval `gpg-agent --daemon`
	type -p gnome-keyring-daemon > /dev/null && [ -z "$GNOME_KEYRING_CONTROL" ] && \
		eval `gnome-keyring-daemon`
	#type -p workrave > /dev/null && workrave &
	type -p xscreensaver > /dev/null && xscreensaver -nosplash &
	#type -p xplanet > /dev/null && xplanet -lat 51.191253 -lon 6.422786 &
	xroot loop &
	[ -f ~/.xsession-local ] && . ~/.xsession-local
	( sleep 2 ; type -p awesome-clock > /dev/null && awesome-clock 0 ) &
else
	xsetroot -solid limegreen
fi

# ugly hack to make SHLVL=1 in xterms spawned by fvwm
SHLVL=-1

while ! awesome ; do sleep 2 ; done
