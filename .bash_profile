# $Id$
#echo .bash_profile

. ~/.bashrc

mesg y
finger

if [ "$DISPLAY" ] ; then
	echo "export DISPLAY=$DISPLAY # pid $$ `tty` `date`" >> ~/.display
fi

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
