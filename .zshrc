# $Id$
# .zshenv -> .zprofile (login) -> .zshrc (interactive) -> .zlogin (login)

# echo ".zshrc"

source ~/.zshkeys

case $TERM in
linux*|*vt100*|screen*|cons25)
	prompt="
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%40<..<%B%{[34m%}%/%{[0m%}%b %#"
	LSCOLOR='--color=auto' ;;
xterm*|rxvt)
	prompt="%{]0;%n@%m:%/%}
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%40<..<%B%{[34m%}%/%{[0m%}%b %#"
	[ "$console" ] && prompt="%{]0;console@%m:%/%}[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%30<..<%B%{[34m%}%/%{[0m%}%b %#"
	LSCOLOR='--color=auto' ;;
*)
	prompt="
[%B%?%b] %U%n@%m%u:%40<..<%B%/%b %#" ;;
esac

[ -z "$USER" ] && if [ "$LOGNAME" ] ; then export USER=$LOGNAME
		else export USER=`logname` ; fi
export EDITOR=vim
#export HOSTNAME=`/bin/hostname`
#export HISTSIZE=500
#export LANG=de
#[ -f /etc/inputrc ] && export INPUTRC=/etc/inputrc
#[ -f ~/.inputrc ] && export INPUTRC=~/.inputrc
#export IRCSERVER="irc.uni-stuttgart.de irc.rz.uni-karlsruhe.de"
export LESS=-aiMq
export LESSCHARSET=latin1
type -p lesspipe > /dev/null && export LESSOPEN='|lesspipe %s'
#export LOGNAME=$USER
[ -z $MAIL ] && export MAIL="/var/spool/mail/$USER"
if type -p manpath > /dev/null 
	then unset MANPATH ; export MANPATH=`manpath -q`
	else export MANPATH="/usr/man:/usr/X11R6/man:/usr/local/man"
fi
export PAGER=less
export TZ=CET
[ -f ~/.lynx_bookmarks.html ] && export WWW_HOME=~/.lynx_bookmarks.html
[ -f ~/.netscape/bookmarks.html ] && export WWW_HOME=~/.netscape/bookmarks.html

# internal shell settings

#FIGNORE='~'
#HISTCONTROL=ignoredups
#histchars='!^#'
#HISTFILESIZE=100
#unset ignoreeof
#unset noclobber

# Aliases

#check for GNU utils
if cp --version >& /dev/null ; then
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
alias ctar='tar cvfz'
alias d=date
alias e='$EDITOR'
alias f=finger
alias l='ls -al'
alias ll='ls -l'
type -p gmake > /dev/null && alias make=gmake
alias md=mkdir
alias o=less
alias p=pine
alias pine='pine -d0'
alias pwd='/bin/pwd;builtin pwd'
alias q=exit
alias quit=exit
alias rd=rmdir
alias ttar='tar tvfz'
type -p ytalk > /dev/null && alias talk='ytalk -x'
#alias which='type -path'
alias xtar='tar xvfz'
alias X='mesg n;exec startx'
alias y='echo "Sind wir schon wieder auf der yes-Taste eingeschlafen?"'

# Functions

cd() { builtin cd $1 && ls ; }
nd() { mkdir $1 && cd $1 ; }

# General stuff

#ulimit -Sc 0	# disable core dumps
#umask 022

#[ -f ~/.bashrc-local ] && . ~/.bashrc-local || true
