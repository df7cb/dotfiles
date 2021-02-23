# rm -f .bash* .profile && git clone https://github.com/df7cb/dotfiles.git . && make && . .bashrc

DCLEAN = bin/dbuild bin/dconfigure bin/dinstall bin/dbinary bin/dpatch_ bin/dunpatch
QUILT = bin/qadd bin/qapplied bin/qdiff bin/qedit bin/qimport bin/qnew bin/qpop bin/qpush bin/qrefresh bin/qtop
all: cleanup .less .xinitrc bin/ctar .priv $(DCLEAN) $(QUILT) .ssh/config

## targets ##

.less: .lesskey
	lesskey

.ssh/config:
	ln -s config.public $@

.xinitrc:
	ln -s .xsession .xinitrc

bin/ctar:
	ln -s ttar bin/ctar

$(DCLEAN):
	ln -s dclean $@

$(QUILT):
	ln -s qwrapper $@

.PHONY: .priv
.priv:
	@if [ -d .priv ] ; then $(MAKE) -C .priv ; fi

tmp /tmp/$(USER):
	mkdir -m 0700 $@

install-profile:
	sudo cp lib/myon-profile.sh /etc/profile.d/myon-profile.sh

deploy-profile:
	test "$(HOST)"
	ssh $(HOST) sudo tee /etc/profile.d/myon-profile.sh < lib/myon-profile.sh

/etc/apt/preferences.d/debian.pref: lib/debian.pref
	sudo cp $< $@

install-dev: install-profile /etc/apt/preferences.d/debian.pref
	if [ ! -x /usr/bin/sudo ] && [ $$(id -u) = 0 ]; then apt-get install sudo; fi
	test -e /etc/dpkg/dpkg.cfg.d/01unsafeio || echo force-unsafe-io | sudo tee /etc/dpkg/dpkg.cfg.d/01unsafeio
	test -e /etc/apt/apt.conf.d/20norecommends || echo 'APT::Install-Recommends "false";' | sudo tee /etc/apt/apt.conf.d/20norecommends
	test -e /etc/apt/apt.conf.d/50i18n || echo 'Acquire::Languages { "en"; };' | sudo tee /etc/apt/apt.conf.d/50i18n
	test -e /etc/apt/apt.conf.d/90keep-downloaded-packages || echo 'Binary::apt::APT::Keep-Downloaded-Packages "1";' | sudo tee /etc/apt/apt.conf.d/90keep-downloaded-packages
	sudo rm -f /var/lib/apt/lists/*_Translation-de*
	sudo apt-get install \
		autodep8 \
		autopkgtest \
		blhc \
		build-essential \
		ccache \
		curl \
		debhelper \
		devscripts \
		diffstat \
		dput \
		eatmydata \
		exuberant-ctags \
		fakeroot \
		git \
		git-buildpackage \
		less \
		libwww-perl \
		lintian \
		locales \
		newpid \
		patchutils \
		pristine-tar \
		psmisc \
		openssh-client \
		quilt \
		rsync \
		strace \
		tig \
		tree \
		vim \
		w3m \
		wdiff \
		wget
	if ! grep -q '^de_DE.UTF-8 UTF-8' /etc/locale.gen; then \
		echo 'de_DE.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen; \
		sudo locale-gen; \
	fi
	if ! sudo grep -q '^%sudo.*NOPASSWD' /etc/sudoers; then \
		sudo sed -i -e 's/^%sudo.*/%sudo	ALL = NOPASSWD: ALL/' /etc/sudoers; \
	fi
	test -e /etc/postgresql-common/createcluster.d/myon.conf || \
		{ sudo mkdir -p /etc/postgresql-common/createcluster.d/ ; \
		  echo "create_main_cluster = false" | sudo tee /etc/postgresql-common/createcluster.d/myon.conf ; }
	sudo update-alternatives --set editor /usr/bin/vim.basic

/etc/default/keyboard: lib/default.keyboard
	sudo cp $< $@

install-desktop: install-dev /etc/default/keyboard
	sudo apt-get install \
		arandr \
		awesome \
		bind9-dnsutils \
		chromium \
		diodon \
		etckeeper \
		fdpowermon \
		finger \
		firefox-esr \
		fonts-dejavu \
		gnome-keyring \
		gpg-agent \
		imagemagick \
		libsecret-tools \
		manpages-dev \
		mutt \
		net-tools \
		network-manager-gnome \
		postfix \
		pspg \
		python3-icalendar \
		rxvt-unicode \
		sbuild \
		screen \
		schroot \
		udiskie  \
		vim \
		volumeicon-alsa \
		workrave \
		xscreensaver
	if grep -q '99:battery-charging.png$$' /etc/fdpowermon/theme.cfg; then \
		sudo sed -i -e 's/99:battery-charging.png$$/100:battery-charging.png/' /etc/fdpowermon/theme.cfg; \
	fi
	if ! grep -q '^/run/user' /etc/schroot/default/fstab; then \
		sudo sh -c 'echo "/run/user      /run/user       none    rw,rbind         0       0" >> /etc/schroot/default/fstab'; \
	fi
	sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
	sudo update-alternatives --set x-www-browser /usr/bin/firefox-esr

install-chroot:
	sudo apt-get install \
		ssmtp
	sudo sed -i -e 's/^#\(FromLineOverride\)/\1/' -e 's/^mailhub=.*/mailhub=localhost/' /etc/ssmtp/ssmtp.conf
	sudo sed -i -e 's/^%sudo.*/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

deploy:
	test "$(HOST)"
	ssh "$(HOST)" "test ! -d .git && \
		rm -f .bash* .profile && \
		if ! [ -x /usr/bin/git ] || ! [ -x /usr/bin/make ]; then \
			sudo apt-get update && \
			sudo apt-get install --no-install-recommends -y git make; \
		fi && \
		if [ -f /etc/ssl/ca-global/ca-certificates.crt ]; then \
			export GIT_SSL_CAINFO=/etc/ssl/ca-global/ca-certificates.crt; \
		fi && \
		git init && \
		git remote add origin https://github.com/df7cb/dotfiles.git && \
		git fetch origin && \
		git checkout master && \
		make"

scp:
	test "$(HOST)"
	ssh "$(HOST)" mkdir -p bin
	scp bin/os $(HOST):bin
	scp \
		.bash_bind \
		.bash_profile \
		.bashrc \
		.env \
		.path \
		.profile \
		$(HOST):

vim: .vim/spell/de.utf-8.spl .vim/spell/all.utf-8.add
.vim/spell/de.utf-8.spl:
	mkdir -p .vim/spell
	cd .vim/spell && wget http://ftp.vim.org/vim/runtime/spell/de.utf-8.spl
.vim/spell/all.utf-8.add:
	mkdir -p .vim/spell
	touch $@
	cd .vim/spell && vim -c ":mkspell! all.utf-8.add.spl all.utf-8.add" -c ":q"
	reset

## cleanup stuff ##

cleanup:
	@[ "$(shell stat -c %a .gnupg)" = 700 ] || chmod --changes 700 .gnupg
COMMITS = $(wildcard .mutt/fortunes-??)

## update stuff ##

st: status
status:
	@git status
	@if [ -d .priv ] ; then $(MAKE) -C .priv status ; fi

up: update
update: cleanup
	@gpg -k 5C48FE6157F49179597087C64C5A6BAB12D2A7AE > /dev/null || gpg --import .plan
	@if grep -q ChristophBerg .git/config; then sed -i -e 's/ChristophBerg/df7cb/g' .git/config; fi
	git fetch --tags --force
	case $$(git describe --always --contains master) in signed-head~*) $(MAKE) checkout ;; esac
	@if [ -d .priv ] ; then $(MAKE) -C .priv update ; fi
	@MAKEFLAGS= MAKELEVEL= make all

checkout:
	git verify-tag --raw signed-head 2>&1 | grep 'VALIDSIG 5C48FE6157F49179597087C64C5A6BAB12D2A7AE'
	git merge --ff-only signed-head

push:
	-git tag -d signed-head
	git tag -s -m "HEAD" signed-head
	git push
	git push --tags --force

com: commit
commit: cleanup
#	git commit -m "make commit by $(USER)@$(shell hostname)" $(COMMITS) || :
	@if [ -d .priv ] ; then $(MAKE) -C .priv commit ; fi

ci:
	$(MAKE) update
	$(MAKE) commit
	$(MAKE) -C lib
