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
		export DEBIAN_FRONTEND=noninteractive
		export UCF_FORCE_CONFFNEW=y UCF_FORCE_CONFFMISS=y
		set -ex
		if grep -q '^deb ' /etc/apt/sources.list && ! grep -q '^deb-src ' /etc/apt/sources.list; then \
			sed -i -e '/^deb / { p; s/^deb /deb-src / }' /etc/apt/sources.list; \
		fi
		test -e /etc/dpkg/dpkg.cfg.d/01unsafeio || echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/01unsafeio
		test -e /etc/apt/apt.conf.d/20norecommends || echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/20norecommends
		test -e /etc/apt/apt.conf.d/50i18n || echo 'Acquire::Languages { "en"; };' > /etc/apt/apt.conf.d/50i18n
		apt -y update
		apt -y install build-essential debhelper devscripts fakeroot git nano- sudo vim
		if ! grep '^%sudo.*NOPASSWD' /etc/sudoers; then
			sed -i -e 's/^%sudo.*/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
		fi
		apt -y -o DPkg::Options::=--force-confnew dist-upgrade
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
		export DEBIAN_FRONTEND=noninteractive
		export UCF_FORCE_CONFFNEW=y UCF_FORCE_CONFFMISS=y
		set -ex
		dpkg-query -s postgresql-common >/dev/null 2>&1 || apt -y install postgresql-common
		echo "$PG_SUPPORTED_VERSIONS" > /etc/postgresql-common/supported_versions
		/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -v$PG_SUPPORTED_VERSIONS -i
	EOF
fi

# use older debhelper version
debhelper_compat ()
{
	local level="$1"
	if [ -f debian/compat ]; then
		pkglevel="$(cat debian/compat)"
	else
		pkglevel="$(grep -o 'debhelper-compat (= [0-9]*' debian/control | sed -e 's/.* //')"
	fi
	if [ -z "$pkglevel" ]; then
		echo "Could not determine debhelper compat level"
		exit 1
	fi
	#echo "Package is using debhelper compat level $pkglevel"
	[ "$level" -ge "$pkglevel" ] && return
	if [ "$level" -ge 11 ]; then
		sed -i -e "s/debhelper[^,]*/debhelper-compat (= $level)/" debian/control*
	else
		sed -i -e "s/debhelper[^,]*/debhelper (>= $level)/" debian/control*
		echo "$level" > debian/compat
	fi
	echo "Using debhelper $level"
}

# install build deps
if [ "$PKG" ]; then
	case $CHROOT in
		jessie*|stretch*) debhelper_compat 10 ;;
		buster*) debhelper_compat 12 ;;
		bullseye*) debhelper_compat 13 ;;
		bookworm*) debhelper_compat 13 ;;
		xenial*) debhelper_compat 9 ;;
		bionic*) debhelper_compat 11 ;;
		eoan*|focal*) debhelper_compat 12 ;;
		groovy*|hirsute*|impish*) debhelper_compat 13 ;;
	esac

	schroot -c session:$SESSION -u root -r <<-EOF
		export DEBIAN_FRONTEND=noninteractive
		export UCF_FORCE_CONFFNEW=y UCF_FORCE_CONFFMISS=y
		set -ex
		apt -y -o DPkg::Options::=--force-confnew ${EXPERIMENTAL:-} build-dep . # doesn't work on jessie
	EOF
fi

# run session
set -x
schroot -c session:$SESSION -r -- bash
