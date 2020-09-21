#!/bin/sh

while getopts "bc:n:p:u" opt ; do
	case $opt in
		b) BACKPORTS="true" ;;
		c) CHROOT="$OPTARG" ;;
		n) SESSION="$OPTARG" ;;
		p) PG_SUPPORTED_VERSIONS="$OPTARG" ;;
		u) NOUPDATE=1 ;;
		*) exit 5 ;;
	esac
done
# shift away args
shift $(($OPTIND-1))

: ${CHROOT:=sid-$(dpkg --print-architecture)}

case $CHROOT in exp*)
	CHROOT="sid"
	EXPERIMENTAL="-t experimental"
	;;
esac

if [ -z "$NOUPDATE" ]; then
	schroot -c source:$CHROOT -u root <<-EOF
		set -ex
		apt -y update
		apt -y -o DPkg::Options::=--force-confnew dist-upgrade
		apt -y install sudo
		if ! grep '^%sudo.*NOPASSWD' /etc/sudoers; then
			sed -i -e s/^%sudo.*/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
		fi
		apt-get -y autoremove # doesn't work with apt on jessie
	EOF
fi

# session name
if [ -f debian/changelog ]; then
	PKG=$(dpkg-parsechangelog -SSource)
	: ${SESSION:="$USER-$CHROOT-$PKG"}
else
	: ${SESSION:="$USER-$CHROOT"}
fi

# begin session
if schroot -c $CHROOT -n $SESSION -b; then
	trap "schroot -c session:$SESSION -e" EXIT
fi

if [ "${EXPERIMENTAL:-}" ]; then
	schroot -c session:$SESSION -u root -r <<-EOF
		set -ex
		sed -i -e '/sid/ { p; s/sid/experimental/ }' /etc/apt/sources.list
		apt -y update
	EOF
fi

# activate backports
if [ "${BACKPORTS:-}" ]; then
	schroot -c session:$SESSION -u root -r <<-EOF
		set -ex
		mv /etc/apt/sources.list.d/backports.list.disabled /etc/apt/sources.list.d/backports.list
		apt -y update
	EOF
fi

# install extra PG version
if [ "${PG_SUPPORTED_VERSIONS:-}" ]; then
	schroot -c session:$SESSION -u root -r <<-EOF
		set -ex
		sed -i -e "s/main/main $PG_SUPPORTED_VERSIONS/" /etc/apt/sources.list.d/pgdg.list
		echo "$PG_SUPPORTED_VERSIONS" > /etc/postgresql-common/supported_versions
		apt -y update
		DEBIAN_FRONTEND=noninteractive apt install -y postgresql-$PG_SUPPORTED_VERSIONS postgresql-server-dev-$PG_SUPPORTED_VERSIONS
	EOF
fi

# install build deps
if [ "$PKG" ]; then
	schroot -c session:$SESSION -u root -r <<-EOF
		set -ex
		DEBIAN_FRONTEND=noninteractive apt -y -o DPkg::Options::=--force-confnew ${EXPERIMENTAL:-} build-dep . # doesn't work on jessie
	EOF
fi

# run session
set -x
schroot -c session:$SESSION -r -- bash
