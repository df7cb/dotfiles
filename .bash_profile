# $Id$
#echo .bash_profile

. ~/.bashrc

mesg y
finger

[ "$DISPLAY" ] && update-display add

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
