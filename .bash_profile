#echo .bash_profile

# update git checkout
if [ "$(find ~/.git/FETCH_HEAD -mtime +2 2>/dev/null)" ]; then
	. ~/.bashrc # get GIT_SSL_CAINFO
	if [ -x /usr/bin/make ]; then
		( cd ; make up )
	else
		( cd ; git pull )
	fi
fi

. ~/.bashrc

[ "$TERM" = linux ] && case `tty` in */tty?) unicode_start 2> /dev/null ;; esac
mesg y 2> /dev/null

if [ -x /usr/bin/finger ] ; then
	uptime
	finger
else
	w
fi

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
