#!/bin/sh
# $Id$
#set -v

cd $HOME

. .bashrc

if [ "$SHELL" = /bin/sh ] ; then
  #SHELL=`which zsh` || SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
  SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
fi

#set up X server
xhost - >/dev/null
xkbd load
xrdb .Xdefaults
dpmsoff init
xset b 0 0  # xset b off does not work

xsetroot -solid navy
( sleep 10 ; xroot ) &
xclock -g 116x12+0+0 &
type -p pland > /dev/null && pland -k &
[ -f .aumixrc-default ] && aumix -f .aumixrc-default -L
type -p esd > /dev/null && esd -nobeeps -tcp -as 5 &

# ugly hack to make SHLVL=1 in xterms spawned by fvwm
SHLVL=-1

[ -f ~/.xsession-local ] && . ~/.xsession-local

#echo "export DISPLAY=$DISPLAY" > .display
#echo "# pid $$" >> ~/.display

# write ssh-agent info to file
if [ $SSH_AUTH_SOCK ] ; then
	echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK;" > .ssh/agent.sh
	echo "SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" >> .ssh/agent.sh
fi

fvwm2 -s &

console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
