#!/bin/bash
#set -x

echo
echo "`date` $0: start"

cd $HOME
. ./.bashrc

XVENDOR=$(xdpyinfo | grep '^vendor string' | sed -e 's/.*: *//')

# set up X server
$HOME/bin/xset.sh

if [[ "$XVENDOR" != *VNC* ]] ; then
	xsetroot -solid navy &
	xscreensaver -nosplash &
	diodon &
	nm-applet &
	udiskie --smart-tray &
	volumeicon &
	command -v gpg-agent >/dev/null && [ -z "$GPG_AGENT_INFO" ] && \
		eval `gpg-agent --daemon`
	command -v gnome-keyring-daemon >/dev/null && [ -z "$GNOME_KEYRING_CONTROL" ] && \
		eval `gnome-keyring-daemon`
	workrave &
	#type -p xplanet > /dev/null && xplanet -lat 51.191253 -lon 6.422786 &

	SHLVL=0 x-terminal-emulator &
	SHLVL=0 x-terminal-emulator &
	x-www-browser &

	[ -f ~/.xsession-local ] && . ~/.xsession-local
else
	xsetroot -solid limegreen
fi

if command -v awesome >/dev/null ; then
	exec awesome
else
	exec xterm
fi
