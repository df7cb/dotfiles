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
xrdb .Xdefaults
dpmsoff init

xsetroot -solid navy
( sleep 10 ; xroot ) &
xclock -g 116x12+0+0 &
which pland > /dev/null && pland -k &

# ugly hack to make SHLVL=1 in xterms spawned by fvwm
SHLVL=-1

[ -f ~/.xsession-local ] && . ~/.xsession-local

fvwm2 -s &

console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
