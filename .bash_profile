# $Id$
#echo .bash_profile

. ~/.bashrc

mesg y 2> /dev/null
uptime
finger

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
