# $Id$ <cb@heim-d.uni-sb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
[ -f ~/bin/os ] && . ~/bin/os > /dev/null
[ -f ~/.path ] && . ~/.path
[ -f ~/.env ] && . ~/.env

# general stuff
shopt -s extglob
ulimit -Sc 0	# disable core dumps
umask 022

# check whether we run interactively
[ "$PS1" ] || return
#echo ".bashrc: interactive"

case $BASH_VERSION in
	2.0[4-9]*) # new bash supporting '\j' and completion
		j='$([ $SHLVL -gt 1 ] && echo -n "${SHLVL}s " ; [ \j -gt 0 ] && echo -n "\jj ")'
		[ -f ~/.bash_completion ] && . ~/.bash_completion ;;
	2.0[0-3]*) # old bash
		j='$([ $SHLVL -gt 1 ] && echo -n "${SHLVL}s ")' ;;
	*) echo "$0: unknown bash version $BASH_VERSION" 1>&2 ;;
esac
u='[\[\033[1;31m\]$?\[\033[0m\]] \u@\h:\[\033[1;34m\]\w\[\033[0m\]'
case $TERM in
linux*|*vt100*|cons25)
	PS1='\n'$u' '$j'\$' ;;
xterm*|rxvt|screen*|cygwin)
	PS1='\n\[\033]0;\u@\h:\w\007\]'$u' '$j'\$'
	if [ "$console" ] ; then
		PS1='\[\033]0;console@\h:\w\007'$u' '$j'\$'
		export -n console
	fi ;;
97801)	PS1='\n\[\033[2m\][\[\033[m\]$?\[\033[2m\]] \u@\h:\[\033[4m\]\w\[\033[2m\] '$j'\$\[\033[m\]' ;;
*)
	PS1='\n[$?] \u@\h:\w '$j'\$' ;;
esac
unset j u

case $TERM in # update $DISPLAY in screen shells
	screen*) [ -f ~/.display ] && . ~/.display ;;
esac

# internal shell settings
auto_resume=substring
#FIGNORE='~'
HISTCONTROL=ignoredups
#histchars='!^#'
HISTFILESIZE=100
HISTIGNORE="..:[bf]g:cd:l:ls"
HISTSIZE=500
unset ignoreeof
shopt -s no_empty_cmd_completion
#[ -f /etc/inputrc ] && export INPUTRC=/etc/inputrc
#[ -f ~/.inputrc ] && export INPUTRC=~/.inputrc
[ -t 0 ] && stty erase ^H &> /dev/null
#unset noclobber

[ -f ~/.bashrc-local ] && . ~/.bashrc-local
true
