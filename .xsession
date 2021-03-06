#!/bin/bash
#set -x

echo
echo "`date` $0: start"

cd $HOME
. ./.bashrc

if [ "$SHELL" = /bin/sh ] ; then
	if SHELL=`which bash` ; then
		echo "$0: starting bash"
		exec $SHELL $0
		echo "failed"
	fi
	SHELL=/bin/sh
fi

exists ()
{
	type -p $1 > /dev/null
}

. ./.env

XVENDOR=$(xdpyinfo | grep '^vendor string' | sed -e 's/.*: *//')

# set up X server
xhost - >/dev/null
xmodmap .xmodmap-pc
xrdb .Xdefaults
[ -f .Xdefaults-local ] && xrdb -merge .Xdefaults-local
xset b 0 0  # xset b off does not work
xset r rate 400 30

if [[ "$XVENDOR" != *VNC* ]] ; then
	dpmsoff init
	xsetroot -solid navy &
	xscreensaver -nosplash &
	synclient TapButton1=1 SingleTapTimeout=50 #HorizTwoFingerScroll=1
	diodon &
	nm-applet &
	udiskie --smart-tray &
	volumeicon &
	exists gpg-agent && [ -z "$GPG_AGENT_INFO" ] && \
		eval `gpg-agent --daemon`
	exists gnome-keyring-daemon && [ -z "$GNOME_KEYRING_CONTROL" ] && \
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

if exists awesome ; then
	exec awesome
else
	exec xterm
fi
