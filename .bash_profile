# $Id$
#echo .bash_profile

. ~/.bashrc

mesg y
finger

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
