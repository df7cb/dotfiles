#!/bin/sh

: ${CHROOT:=sid}

while getopts "c:n:u" opt ; do
	case $opt in
		c) CHROOT="$OPTARG" ;;
		n) SESSION="$OPTARG" ;;
		u) NOUPDATE=1 ;;
		*) exit 5 ;;
	esac
done
# shift away args
shift $(($OPTIND-1))

if [ -z "$NOUPDATE" ]; then
	schroot -c source:$CHROOT -u root -- apt-get -y update
	schroot -c source:$CHROOT -u root -- apt-get -y dist-upgrade
fi

: ${SESSION:="$LOGNAME-$CHROOT-1"}

schroot -c $CHROOT -n $SESSION -b && END=1
if [ -f debian/changelog ]; then
	schroot -c session:$SESSION -u root -r -- apt-get -y build-dep ./
fi
schroot -c session:$SESSION -r -- bash
if [ "$END" ]; then
	schroot -c session:$SESSION -e
fi
