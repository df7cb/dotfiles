check_proc ()
{
	pgrep -u $USER $1 | grep -q $2
}

clean_session ()
{
	for f in ~/.var/*.display ; do
		if [ -e $f ] ; then
			[ -e /tmp/.X11-unix/$(basename $f .display) ] || rm -f $f
		fi
	done
	for f in ~/.var/*.ssh-agent ; do
		if [ -e $f ] ; then
			check_proc ssh-agent $(basename $f .ssh-agent) || rm -f $f
		fi
	done
	for f in ~/.var/*.gpg-agent ; do
		if [ -e $f ] ; then
			check_proc gpg-agent $(basename $f .gpg-agent) || rm -f $f
		fi
	done
}

create_session ()
{
	[ -d ~/.var ] || mkdir -m0700 ~/.var
	clean_session

	# misc vars
	[ -f ~/.var/tz ] || echo "export TZ='CET'" > ~/.var/tz
	[ ! "$TZ" ] && . ~/.var/tz

	# X11 display
	if [ "$DISPLAY" ] ; then
		if [ -e /tmp/.X11-unix/$DISPLAY ] ; then
			echo "export DISPLAY='$DISPLAY'" > ~/.var/$DISPLAY.display
		else
			unset DISPLAY
		fi
	fi
	if [ ! "$DISPLAY" ] ; then
		for f in ~/.var/*.display ; do
			[ -e $f ] && . $f
		done
	fi

	# ssh-agent
	if [ "$SSH_AGENT_PID" ] ; then
		if check_proc ssh-agent $SSH_AGENT_PID ; then
			echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK' SSH_AGENT_PID='$SSH_AGENT_PID'" > ~/.var/$SSH_AGENT_PID.ssh-agent
		else
			unset SSH_AUTH_SOCK SSH_AGENT_PID
		fi
	fi
	if [ ! "$SSH_AGENT_PID" ] ; then
		for f in ~/.var/*.ssh-agent ; do
			[ -e $f ] && . $f
		done
	fi

	# gpg-agent
	if [ "$GPG_AGENT_INFO" ] ; then
		local pid
		pid=`echo $GPG_AGENT_INFO | cut -d: -f2`
		if check_proc gpg-agent $pid ; then
			echo "export GPG_AGENT_INFO='$GPG_AGENT_INFO'" > ~/.var/$pid.gpg-agent
		else
			unset GPG_AGENT_INFO
		fi
	fi
	if [ ! "$GPG_AGENT_INFO" ] ; then
		for f in ~/.var/*.gpg-agent ; do
			[ -e $f ] && . $f
		done
	fi
}

create_session
