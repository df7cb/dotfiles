# $Id$ <cb@heim-d.uni-sb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
. ~/.path
. ~/.env

j='$([ $SHLVL -gt 1 ] && echo -n "${SHLVL}s " ; [ \j -gt 0 ] && echo -n "\jj ")'
u='[\[\033[1;31m\]$?\[\033[0m\]] \u@\h:\[\033[1;34m\]\w\[\033[0m\]'
case $TERM in
linux*|*vt100*|cons25)
	PS1='\n'$u' '$j'\$' ;;
xterm*|rxvt|screen*|cygwin)
	PS1='\n\[\033]0;\u@\h:\w\007\]'$u' '$j'\$'
	[ "$console" ] && PS1='\[\033]0;console@\h:\w\007'$u' '$j'\$' ;;
97801)	PS1='\n\[\033[2m\][\[\033[m\]$?\[\033[2m\]] \u@\h:\[\033[4m\]\w\[\033[2m\] '$j'\$\[\033[m\]' ;;
*)
	PS1='\n[$?] \u@\h:\w '$j'\$' ;;
esac
export PS1
unset j u

# internal shell settings
auto_resume=substring
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
