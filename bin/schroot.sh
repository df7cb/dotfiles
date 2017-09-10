#!/bin/sh

: ${CHROOT:=sid}

while getopts "c:n:p:u" opt ; do
	case $opt in
		c) CHROOT="$OPTARG" ;;
		n) SESSION="$OPTARG" ;;
		p) PG_SUPPORTED_VERSIONS="$OPTARG" ;;
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

# install extra PG version
if [ "${PG_SUPPORTED_VERSIONS:-}" ]; then
	schroot -c session:$SESSION -u root -r <<-EOF
		set -x
		sed -i -e "s/main/main $PG_SUPPORTED_VERSIONS/" /etc/apt/sources.list.d/pgdg.list
		echo "$PG_SUPPORTED_VERSIONS" > /etc/postgresql-common/supported_versions
		apt-get -y update
		apt-get install -y postgresql-$PG_SUPPORTED_VERSIONS postgresql-server-dev-$PG_SUPPORTED_VERSIONS
		EOF
fi

# install build deps
if [ "$PKG" ]; then
	schroot -c session:$SESSION -u root -r -- apt-get -y build-dep ./
fi

# run session
schroot -c session:$SESSION -r -- bash
