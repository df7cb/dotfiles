# $Id$
# .bashrc: cb 990719 Christoph Berg <cb@heim-d.uni-sb.de>
#echo .bashrc

# Environment

export PATH_SYS=$PATH
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin
[ $UID = '0' ] && PATH=/usr/local/sbin:/sbin:/usr/sbin:$PATH
#[ -d ~/bin/`os` ] && PATH="~/bin/`os`:$PATH"
[ -d ~/bin ] && PATH=~/bin:$PATH

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

# "which" is needed later
alias which='type -path'
[ -z "$USER" ] && if [ "$LOGNAME" ] ; then export USER=$LOGNAME
		else export USER=`logname` ; fi
export EDITOR=vim
#export HOSTNAME=`/bin/hostname`
export HISTSIZE=500
#export LANG=de
[ -f /etc/inputrc ] && export INPUTRC=/etc/inputrc
[ -f ~/.inputrc ] && export INPUTRC=~/.inputrc
#export IRCSERVER="irc.uni-stuttgart.de irc.rz.uni-karlsruhe.de"
export LESS=-aiMq
export LESSCHARSET=latin1
which lesspipe > /dev/null && export LESSOPEN='|lesspipe %s'
#export LOGNAME=$USER
[ -z $MAIL ] && export MAIL="/var/spool/mail/$USER"
if which manpath > /dev/null 
	then unset MANPATH ; export MANPATH=`manpath -q`
	else export MANPATH="/usr/man:/usr/X11R6/man:/usr/local/man"
fi
export PAGER=less
export TZ=CET
[ -f ~/.lynx_bookmarks.html ] && export WWW_HOME=~/.lynx_bookmarks.html
[ -f ~/.netscape/bookmarks.html ] && export WWW_HOME=~/.netscape/bookmarks.html

# internal shell settings

#FIGNORE='~'
HISTCONTROL=ignoredups
#histchars='!^#'
HISTFILESIZE=100
noclobber=

# Aliases

#check for GNU utils
if sleep --version >& /dev/null ; then
	alias cp='cp -iv'
	alias mv='mv -iv'
	alias rm='rm -iv'
	alias ls="ls -F $LSCOLOR"
else
	alias cp='cp -i'
	alias mv='mv -i'
	alias rm='rm -i'
	alias ls='ls -F'
fi

alias +='pushd .'
alias -- -=popd
alias ..='cd ..'
alias ...='cd ../..'
alias /='cd /'
alias ctar='tar cvfz'
alias d=date
alias e='$EDITOR'
alias f=finger
alias l='ls -al'
alias ll='ls -l'
which gmake > /dev/null && alias make=gmake
alias md=mkdir
alias o=less
alias p=pine
alias pine='pine -d0'
alias pwd='builtin pwd ; /bin/pwd'
alias q=exit
alias rd=rmdir
which ytalk > /dev/null && alias talk='ytalk -x'
alias ttar='tar tvfz'
alias xtar='tar xvfz'
alias X='exec startx'

# Functions

cd() { builtin cd $1 && ls ; }
nd() { mkdir $1 && cd $1 ; }

# General stuff

ulimit -Sc 0
umask 022
#if [ `id -gn` = `id -un` -a `id -u` -gt 14 ] && umask 002

[ -f ~/.bashrc-local ] && . ~/.bashrc-local || true
