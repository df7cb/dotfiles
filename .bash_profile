#echo .bash_profile

# update git checkout
if [ -t 0 ] && [ -x /usr/bin/make ] && [ "$(find ~/.git/FETCH_HEAD -mtime +2 2>/dev/null)" ]; then
	. ~/.bashrc # get GIT_SSL_CAINFO
	make -C $HOME up
fi

. ~/.bashrc

[ "$TERM" = linux ] && case `tty` in */tty?) unicode_start 2> /dev/null ;; esac

if [ -x /usr/bin/finger ] ; then
	uptime
	finger
else
	w
fi

[ -f ~/.bash_profile-local ] && . ~/.bash_profile-local || true
