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

# session name
if [ -f debian/changelog ]; then
	PKG=$(dpkg-parsechangelog -SSource)
	: ${SESSION:="$PKG-$CHROOT-1"}
else
	: ${SESSION:="$CHROOT-1"}
fi

# begin session
if schroot -c $CHROOT -n $SESSION -b; then
	trap "set -x; schroot -c session:$SESSION -e" 0 2 3 15
fi

# install build deps
if [ "$PKG" ]; then
	schroot -c session:$SESSION -u root -r -- apt-get -y build-dep ./
fi

# run session
schroot -c session:$SESSION -r -- bash
