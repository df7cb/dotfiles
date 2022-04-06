# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
for L in de_DE.utf8 en_US.utf8 C.UTF-8 $LANG; do
	if LC_ALL=C locale -a | fgrep -q $L; then
		LANG=$L
		break
	fi
done
unset L
: ${LANGUAGE:=de:en_US:en} ${TZ:=${LC_TZ:-CET}}
export LANG LANGUAGE TZ

. ${CONF_HOME:-$HOME}/lib/myon-profile.sh
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
[ -f /etc/debian_chroot ] && chroot="$(cat /etc/debian_chroot)." && export GPG_TTY="$(tty)"
cyan='\[\033[0;46m\]' red='\[\033[1;31m\]' bold='\[\033[1m\]' blue='\[\033[34m\]' purple='\[\033[35m\]' reset='\[\033[0m\]'
screentitle='\033k\u@'$chroot'\h\033\\'
xtitle='\033]0;\u@'$chroot'\h:\w\007'
ps1_pwd='${PS1_PWD:-$PWD}'
prompt="$cyan[$red\$?$cyan] \\A $bold\\u@$chroot\\h:$blue$ps1_pwd$purple\$PS1_VCS\$PS1_QUILT$cyan$job"
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
unset cyan red bold blue purple reset
unset job screentitle xtitle ps1_pwd prompt

PROMPT_COMMAND="ps1_vcs"

# internal shell settings
auto_resume=
#FIGNORE='~'
#histchars='!^#'
HISTFILESIZE=10000
HISTSIZE=10000
HISTTIMEFORMAT="%F %T  "

[ -f ~/.bashrc-local ] && . ~/.bashrc-local
true
