#!/bin/sh
# $Id$

. $HOME/.path
if [ "$SHELL" = /bin/sh ] ; then
	SHELL=`which zsh` || SHELL=`which bash`
	|| SHELL=`which tcsh` || SHELL=/bin/sh
fi

#set up X server
xhost - >/dev/null
XMODMAP=`os kbd`
[ -f $XMODMAP ] && xmodmap $XMODMAP
xset s off
xset dpms 0 0 900 2> /dev/null
xrdb -merge .Xdefaults

xsetroot -solid navy
( sleep 10 ; xroot ) &
xclock -g 116x12+41+0 &

fvwm2 -s &

[ -f ~/.xsession-local ] && . ~/.xsession-local

console=yes
export console
exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
