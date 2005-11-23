# $Id$ Christoph Berg <cb@df7cb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

source_rc () {
	if [ -e ~/$1 ] ; then . ~/$1
	elif [ -e ~cb/$1 ] ; then . ~cb/$1
	else echo "$0: $1 not found" 1>&2
	fi
}

# Environment
source_rc bin/os > /dev/null
source_rc .path
source_rc .env

# check whether we run interactively
[ "$PS1" ] || return
#echo ".bashrc: interactive"

source_rc .bash_bind

if [ "$BASH_VERSION" \> "2.04" ] ; then # new bash supporting '\j' and completion
	j='$([ $SHLVL -gt 1 ] && echo -n "${SHLVL}s " ; [ \j -gt 0 ] && echo -n "\jj ")'
	[ -f ~/.bash_completion ] && . ~/.bash_completion
else
	j='$([ $SHLVL -gt 1 ] && echo -n "${SHLVL}s ")'
fi
[ -f /etc/debian_chroot ] && h=$(cat /etc/debian_chroot).
u='[\[\033[1;31m\]$?\[\033[0m\]] \u@'$h'\h:\[\033[1;34m\]\w\[\033[0m\]'
case $TERM in
linux*|*vt100*|cons25)
	PS1="\\n$u $j\\l \\$" ;;
xterm*|rxvt|screen*|cygwin)
	PS1='\n\[\033]0;\u@'$h'\h:\w\007\]'$u' '$j'\$'
	if [ "$console" ] ; then
		PS1='\[\033]0;console@'$h'\h:\w\007'$u' '$j'\$'
		export -n console
	fi ;;
97801)	PS1='\n\[\033[2m\][\[\033[m\]$?\[\033[2m\]] \u@'$h'\h[\033[4m\]\w\[\033[2m\] '$j'\$\[\033[m\]' ;;
*)
	PS1='\n[$?] \u@'$h'w '$j'\$' ;;
esac
unset h j u

case $TERM in # update $DISPLAY in screen shells
	screen*) [ -f ~/.display ] && . ~/.display ;;
esac

# internal shell settings
auto_resume=
#FIGNORE='~'
HISTCONTROL=ignoredups
#histchars='!^#'
HISTFILESIZE=100
HISTIGNORE="..:[bf]g:cd:l:ls"
HISTSIZE=500
unset ignoreeof
shopt -s extglob no_empty_cmd_completion
#[ -t 0 ] && stty erase ^H &> /dev/null
#unset noclobber

[ -f ~/.bashrc-local ] && . ~/.bashrc-local
true

# vim:ts=4:sw=4:
