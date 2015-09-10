# $Id$

# rm -f .bash* .profile && svn co http://svn.df7cb.de/dotfiles/cb . && make && . .bashrc

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
	test -e /etc/dpkg/dpkg.cfg.d/01unsafeio || echo force-unsafe-io | sudo tee /etc/dpkg/dpkg.cfg.d/01unsafeio
	test -e /etc/apt/apt.conf.d/20norecommends || echo 'APT::Install-Recommends "false";' | sudo tee /etc/apt/apt.conf.d/20norecommends
	sudo apt-get install \
		build-essential \
		ccache \
		debhelper \
		devscripts \
		diffstat \
		eatmydata \
		fakeroot \
		git \
		less \
		lintian \
		locales \
		patchutils \
		subversion \
		vim \
		wdiff
	if ! grep -q '^de_DE.UTF-8 UTF-8' /etc/locale.gen; then \
		echo 'de_DE.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen; \
		locale-gen; \
	fi

install-chroot:
	sudo apt-get install \
		ssmtp \

deploy:
	test "$(HOST)"
	ssh "$(HOST)" "rm -f .bash* .profile && svn co http://svn.df7cb.de/dotfiles/cb . && make"

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
	@svn -q status
	@if [ -d .priv ] ; then $(MAKE) -C .priv status ; fi

up: update
update: cleanup
	svn update
	@if [ -d .priv ] ; then $(MAKE) -C .priv update ; fi
	@$(MAKE) all

com: commit
commit: cleanup
	svn commit -m "make commit by $(USER)@$(shell hostname)" $(COMMITS)
	@if [ -d .priv ] ; then $(MAKE) -C .priv commit ; fi

ci:
	$(MAKE) update
	$(MAKE) commit
