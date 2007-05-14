check_proc ()
{
	pgrep -u $USER $1 | grep -q $2
}

clean_session ()
{
	for f in ~/.var/*.unix.display ; do
		[ -e $f ] || continue
		[ -e /tmp/.X11-unix/X$(basename $f .unix.display) ] || rm -f $f
	done
	for f in ~/.var/*.tcp.display ; do
		[ -e $f ] || continue
		netstat -tln | grep -q ":$(basename $f .tcp.display) " || rm -f $f
	done
	for f in ~/.var/*.ssh-agent ; do
		[ -e $f ] || continue
		check_proc ssh-agent $(basename $f .ssh-agent) || rm -f $f
	done
	for f in ~/.var/*.gpg-agent ; do
		[ -e $f ] || continue
		check_proc gpg-agent $(basename $f .gpg-agent) || rm -f $f
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
		case $DISPLAY in
		:*) local display
			display=`echo $DISPLAY | sed -e 's/^://' -e 's/\..*//'`
			if [ -e /tmp/.X11-unix/X$display ] ; then
				echo "export DISPLAY='$DISPLAY'" > ~/.var/$display.unix.display
			else
				unset DISPLAY
			fi
			;;
		localhost:*) local display port
			display=`echo $DISPLAY | sed -e 's/^localhost://' -e 's/\..*//'`
			port=$(($display + 6000))
			if netstat -tln | grep -q ":$port " ; then
				echo "export DISPLAY='$DISPLAY'" > ~/.var/$port.tcp.display
			else
				unset DISPLAY
			fi
			;;
		*)
			echo "$0: could not handle DISPLAY $DISPLAY" 1>&2
			;;
		esac
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
