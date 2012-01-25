# $Id$ Christoph Berg <cb@df7cb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
. ${CONF_HOME:-$HOME}/lib/locale.sh
. ${CONF_HOME:-$HOME}/lib/session.sh
. ${CONF_HOME:-$HOME}/bin/os > /dev/null
. ${CONF_HOME:-$HOME}/.path
. ${CONF_HOME:-$HOME}/.env

# check whether we run interactively
[ "$PS1" ] || return
#echo ".bashrc: interactive"

. ${CONF_HOME:-$HOME}/.bash_bind

if [ "$BASH_VERSION" \> "2.04" ] ; then # new bash supporting '\j' and completion
	job='$([ $SHLVL -gt 1 ] && echo -n " ${SHLVL}s" ; [ \j -gt 0 ] && echo -n " \jj")'
	[ -f ~/.bash_completion ] && . ~/.bash_completion
	#. /etc/bash_completion
else
	job='$([ $SHLVL -gt 1 ] && echo -n " ${SHLVL}s")'
fi
[ -f /etc/debian_chroot ] && chroot="$(cat /etc/debian_chroot)."
cyan='\[\033[0;46m\]' red='\[\033[1;31m\]' bold='\[\033[1m\]' blue='\[\033[34m\]' reset='\[\033[0m\]'
screentitle='\033k\u@'$chroot'\h\033\\'
xtitle='\033]0;\u@'$chroot'\h:\w\007'
ps1_pwd='${PS1_PWD:-$PWD}'
prompt="$cyan[$red\$?$cyan] \\A $bold\\u@$chroot\\h:$blue$ps1_pwd$red\$PS1_VCS$cyan$job"
case $TERM in
linux*|*vt100*|cons25)
	PS1="$prompt \\l \\\$$reset " ;;
screen*)
	PS1="\\[$screentitle$xtitle\\]$prompt \\\$$reset " ;;
xterm*|rxvt*|cygwin)
	PS1="\\[$xtitle\\]$prompt \\\$$reset " ;;
*)
	PS1="$bold[\$?] \\A \\u@$chroot\\h:$ps1_pwd$job \\\$$reset " ;;
esac
unset cyan red bold blue reset
unset screentitle xtitle ps1_pwd prompt

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

[ -f ~/.bashrc-local ] && . ~/.bashrc-local
true
