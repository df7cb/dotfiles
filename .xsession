#!/bin/sh
#echo '$Id$'
#set -x

cd $HOME
. $HOME/.path

if [ "$SHELL" = /bin/sh ] ; then
	if SHELL=`which bash` ; then
		echo "$0: starting bash"
		exec $SHELL $0
		echo "failed"
	fi
	SHELL=/bin/sh
fi

export LANG=de_DE.UTF-8
echo "`date` $0: start"
locale

. $HOME/.bashrc

export XVENDOR=$(xdpyinfo | grep '^vendor string' | sed -e 's/.*: *//')

#set up X server
xhost - >/dev/null
xkbd load
xrdb .Xdefaults
xset b 0 0  # xset b off does not work
xset r rate 400 30

if [[ "$XVENDOR" != *VNC* ]] ; then
	dpmsoff init
	xsetroot -solid navy
	( sleep 10 ; xroot ) &
	case $(xdpyinfo | grep '^XFree86 version' | cut -d ' ' -f 3) in
		4.3*|4.4*) xclock -g x13+0+0 -strftime '%e.%m. %T' & ;; # 110x13
		*) xclock -g 116x12+0+0 & ;;
	esac
	type -p pland > /dev/null && pland -k &
	[ -p .aumix-pipe ] && rm -f .aumix-pipe
	[ -f .aumixrc-default ] && aumix -f .aumixrc-default -L
	type -p esd > /dev/null && esd -nobeeps -tcp -as 5 &

	if [ "`echo .ssh/*.pub`" != ".ssh/*.pub" ] ; then # there are keys
		[ -z "$SSH_AUTH_SOCK" ] && eval `ssh-agent`
		[ "$SSH_AUTH_SOCK" ] && ssh-add < /dev/null
	fi
	update-display add

	[ -f ~/.xsession-local ] && . ~/.xsession-local
else
	xsetroot -solid limegreen
fi

# ugly hack to make SHLVL=1 in xterms spawned by fvwm
SHLVL=-1

#LANG=de_DE.ISO-8859-1 fvwm2 -s &
fvwm &

if [[ "$XVENDOR" != *VNC* ]] ; then
	console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
else
	exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
fi

# vim:ts=4:sw=4:
