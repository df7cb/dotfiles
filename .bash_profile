# $Id$
#echo .bash_profile

. ~/.bashrc

mesg y
finger

if [ "$DISPLAY" ] ; then
	echo "export DISPLAY=$DISPLAY # pid $$ `tty` `date`" >> ~/.display
fi

if [ -x ~/bin/$OS/utf8term ] || [ -x ~/bin/utf8term ] ; then
	case `utf8term` in
	single*) LANG=de_DE.ISO-8859-1 ;;
	UTF-8*)  LANG=de_DE.UTF-8 ;;
	esac
fi

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
