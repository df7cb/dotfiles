#!/bin/sh
# $Id$

. $HOME/.path
test "$SHELL" = /bin/sh -a -x /usr/local/bin/bash && SHELL=/usr/local/bin/bash

#set up X server
xhost - >/dev/null
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap
xset s off
xset dpms 0 0 1800 2> /dev/null
xrdb -merge .Xdefaults

xsetroot -solid navy
xroot
xclock -g +41+0 &

fvwm2 -s &

[ -f ~/.xsession-local ] && . ~/.xsession-local

console=yes
export console
exec xterm +ut -vb -C -geometry 61x5+120-0 -T console
