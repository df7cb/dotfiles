#!/bin/sh
# $Id$

. $HOME/.path
if [ "$SHELL" = /bin/sh ] ; then
  SHELL=`which zsh` || SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
fi

#set up X server
xhost - >/dev/null
XKBD=`xkbd` && xmodmap .xmodmap-$XKBD
xset s 900
xset dpms 0 0 960 2> /dev/null
xrdb -merge .Xdefaults

xsetroot -solid navy
( sleep 10 ; xroot ) &
xclock -g 116x12+41+0 &

fvwm2 -s &

[ -f ~/.xsession-local ] && . ~/.xsession-local

console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
