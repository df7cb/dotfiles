#!/bin/sh
# $Id$
#set -v

cd $HOME

export XVENDOR=$(xdpyinfo | grep '^vendor string' | sed -e 's/.*: *//')

. .bashrc

if [ "$SHELL" = /bin/sh ] ; then
  #SHELL=`which zsh` || SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
  SHELL=`which bash` || SHELL=`which tcsh` || SHELL=/bin/sh
fi

#set up X server
xhost - >/dev/null
xkbd load
xrdb .Xdefaults
xset b 0 0  # xset b off does not work

if [[ "$XVENDOR" != *VNC* ]] ; then
	dpmsoff init
	xsetroot -solid navy
	( sleep 10 ; xroot ) &
	case $(xdpyinfo | grep '^XFree86 version' | cut -d ' ' -f 3) in
		4.3*) xclock -g x13+0+0 -strftime '%e.%m. %T' & ;; # 110x13
		*) xclock -g 116x12+0+0 & ;;
	esac
	type -p pland > /dev/null && pland -k &
	[ -p .aumix-pipe ] && rm -f .aumix-pipe
	[ -f .aumixrc-default ] && aumix -f .aumixrc-default -L
	type -p esd > /dev/null && esd -nobeeps -tcp -as 5 &

	update-display add

	[ -f ~/.xsession-local ] && . ~/.xsession-local
else
	xsetroot -solid limegreen
fi

# ugly hack to make SHLVL=1 in xterms spawned by fvwm
SHLVL=-1

#echo "export DISPLAY=$DISPLAY" > .display
#echo "# pid $$" >> ~/.display

# write ssh-agent info to file
if [ $SSH_AUTH_SOCK ] ; then
	echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK;" > .ssh/agent.sh
	echo "SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" >> .ssh/agent.sh
fi

LANG=de_DE.ISO-8859-1 fvwm2 -s &

if [[ "$XVENDOR" != *VNC* ]] ; then
	console=yes exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
else
	exec xterm +ut -vb -C -geometry 62x5+120-0 -T console
fi
