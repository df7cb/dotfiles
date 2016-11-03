# rm -f .bash* .profile && git clone https://github.com/ChristophBerg/dotfiles.git . && make && . .bashrc

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

install-dev:
	if [ ! -x /usr/bin/sudo ] && [ $$(id -u) = 0 ]; then apt-get install sudo; fi
	test -e /etc/dpkg/dpkg.cfg.d/01unsafeio || echo force-unsafe-io | sudo tee /etc/dpkg/dpkg.cfg.d/01unsafeio
	test -e /etc/apt/apt.conf.d/20norecommends || echo 'APT::Install-Recommends "false";' | sudo tee /etc/apt/apt.conf.d/20norecommends
	test -e /etc/apt/apt.conf.d/50i18n || echo 'Acquire::Languages { "en"; };' | sudo tee /etc/apt/apt.conf.d/50i18n
	sudo rm -f /var/lib/apt/lists/*_Translation-de*
	sudo apt-get install \
		autopkgtest \
		build-essential \
		ccache \
		debhelper \
		devscripts \
		diffstat \
		dput \
		eatmydata \
		fakeroot \
		git \
		git-buildpackage \
		less \
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
		subversion \
		tree \
		vim \
		wdiff
	if ! grep -q '^de_DE.UTF-8 UTF-8' /etc/locale.gen; then \
		echo 'de_DE.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen; \
		sudo locale-gen; \
	fi
	if grep -q '^ *HashKnownHosts yes' /etc/ssh/ssh_config; then \
		sudo sed -i -e 's/^\( *HashKnownHosts\) .*/\1 no/' /etc/ssh/ssh_config; \
	fi

install-chroot:
	sudo apt-get install \
		ssmtp
	sudo sed -i -e 's/^#\(FromLineOverride\)/\1/' -e 's/^mailhub=.*/mailhub=localhost/' /etc/ssmtp/ssmtp.conf
	sudo sed -i -e 's/^%sudo.*/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

deploy:
	test "$(HOST)"
	ssh "$(HOST)" "rm -f .bash* .profile && if [ -f /etc/ssl/ca-global/ca-certificates.crt ]; then export GIT_SSL_CAINFO=/etc/ssl/ca-global/ca-certificates.crt; fi && git init && git remote add origin https://github.com/ChristophBerg/dotfiles.git && git fetch origin && git checkout master && make"

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

## cleanup stuff ##

cleanup:
COMMITS = $(wildcard .mutt/fortunes-??)

## update stuff ##

st: status
status:
	@git status
	@if [ -d .priv ] ; then $(MAKE) -C .priv status ; fi

up: update
update: cleanup
	git pull
	@if [ -d .priv ] ; then $(MAKE) -C .priv update ; fi
	@MAKEFLAGS= MAKELEVEL= make all

com: commit
commit: cleanup
	git commit -m "make commit by $(USER)@$(shell hostname)" $(COMMITS) || :
	@if [ -d .priv ] ; then $(MAKE) -C .priv commit ; fi

ci:
	$(MAKE) update
	$(MAKE) commit
	$(MAKE) -C lib
