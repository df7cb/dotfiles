# $Id$ <cb@heim-d.uni-sb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
. ~/.path

case $TERM in
linux*|*vt100*|screen*|cons25)
	PS1='\n[\[\033[1;31m\]$?\[\033[0m\]] \u@\h:\[\033[1;34m\]\w\[\033[0m\] \$' 
	LSCOLOR='--color=auto' ;;
xterm*|rxvt)
	PS1='\n[\[\033]0;\u@\h:\w\007\033[1;31m\]$?\[\033[0m\]] \u@\h:\[\033[1;34m\]\w\[\033[0m\] \$' 
	[ "$console" ] && PS1='[\[\033]0;console@\h:\w\007\033[1;31m\]$?\[\033[0m\]] \u@\h:\[\033[1;34m\]\w\[\033[0m\] \$'
	LSCOLOR='--color=auto' ;;
97801)	PS1='\n\[\033[2m\][\[\033[m\]$?\[\033[2m\]] \u@\h:\[\033[4m\]\w\[\033[2m\] \$\[\033[m\]' ;;
*)
	PS1='\n[$?] \u@\h:\w \$' ;;
esac
export PS1

. ~/.env

# internal shell settings
#FIGNORE='~'
HISTCONTROL=ignoredups
#histchars='!^#'
HISTFILESIZE=100
HISTSIZE=500
unset ignoreeof
[ -f /etc/inputrc ] && export INPUTRC=/etc/inputrc
[ -f ~/.inputrc ] && export INPUTRC=~/.inputrc
stty erase  >& /dev/null
#unset noclobber

# general stuff
ulimit -Sc 0	# disable core dumps
umask 022

[ -f ~/.bashrc-local ] && . ~/.bashrc-local || true
