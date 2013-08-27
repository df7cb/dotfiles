# $Id$ Christoph Berg <cb@df7cb.de>
# login shells: /etc/profile, then ~/.[bash_]profile; interactive: ~/.bashrc
#echo .bashrc

# Environment
#. ${CONF_HOME:-$HOME}/lib/locale.sh
export LANG=de_DE.utf8 LANGUAGE=de:en_US:en TZ=CET
#. ${CONF_HOME:-$HOME}/lib/session.sh
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
unset screentitle xtitle ps1_pwd prompt

export u=0 s=0
ps1_times () {
	local tmpfile="$HOME/.var/bashtimes-$$"
	times > $tmpfile
	eval $(perl -w -le '<>; $_ = <>;
		/(\d+)m([\d.]+)s (\d+)m([\d.]+)s/;
		$u = 60.0*$1 + $2; $s = 60.0*$3 + $4;
		$du = $u-$ENV{u};  $ds = $s-$ENV{s};
		printf STDERR "\033[47muser %.3fs system %.3fs\033[0m\n", $du, $ds
			if ($du > 1.0 or $ds > 1.0);
		print "u=$u;s=$s" ' $tmpfile )
	/bin/rm -f $tmpfile
}
PROMPT_COMMAND="ps1_times; ps1_vcs"

# internal shell settings
auto_resume=
#FIGNORE='~'
HISTCONTROL=ignoredups
#histchars='!^#'
HISTFILESIZE=1000
HISTIGNORE="..:[bf]g:cd:l:ls"
HISTSIZE=5000
unset ignoreeof
shopt -s extglob no_empty_cmd_completion

[ -f ~/.bashrc-local ] && . ~/.bashrc-local
true
