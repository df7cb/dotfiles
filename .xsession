#!/bin/sh
# .xsession cb 990804

PATH=~/bin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
export PATH
test "$SHELL" = /bin/sh -a -x /usr/local/bin/bash && SHELL=/usr/local/bin/bash

#set up X server
xhost - >/dev/null
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap
xset s off
xset dpms 0 0 1800
xrdb -merge .Xdefaults

xsetroot -solid navy
xroot
xclock -g +41+0 &

fvwm2 &

#procmeter -geometry 499x85-0-0 -horizontal cpu-user load disk mem-used fpkt-rx fpkt-tx &

console=yes
export console
exec xterm +ut -vb -C -geometry 61x5+120-0 -T console
