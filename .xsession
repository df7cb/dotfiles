#!/bin/sh
# $Id$

cd $HOME

. $HOME/.path
if [ "$SHELL" = /bin/sh ] ; then
  #SHELL=`which zsh` || SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
  SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
fi

#set up X server
xhost - >/dev/null
XKBD=`xkbd` && xmodmap .xmodmap-$XKBD
xrdb -merge .Xdefaults
dpmsoff init

xsetroot -solid navy
( sleep 10 ; xroot ) &
xclock -g 116x12+41+0 &

fvwm2 -s &

[ -f ~/.xsession-local ] && . ~/.xsession-local

console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
