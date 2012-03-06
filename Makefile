# $Id$

DCLEAN = bin/dbuild bin/dconfigure bin/dinstall bin/dbinary bin/dpatch_ bin/dunpatch
QUILT = bin/qadd bin/qapplied bin/qdiff bin/qedit bin/qpop bin/qpush bin/qrefresh bin/qtop
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
	@test -d .priv && $(MAKE) -C .priv

tmp /tmp/$(USER):
	mkdir -m 0700 $@

## cleanup stuff ##

cleanup:
COMMITS = $(wildcard .mutt/fortunes-??)

ifeq ($(shell [ -d .firefox ] && echo yes), yes)
all: .firefox/cb/cbcbcbcb.slt/prefs.js
COMMITS += .firefox/cb/cbcbcbcb.slt/prefs.js.tracked
endif
.firefox/cb/cbcbcbcb.slt/prefs.js: .firefox/cb/cbcbcbcb.slt/prefs.js.tracked
	# Updating $@
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	sed -i -e '/"adblock.patterns"/d' -e '/"guc\./d' $@
	cat $< >> $@
firefox-pull:
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	.firefox/cb/cbcbcbcb.slt/pull .firefox/cb/cbcbcbcb.slt/prefs.js > .firefox/cb/cbcbcbcb.slt/prefs.js.tracked
	svn diff .firefox/cb/cbcbcbcb.slt/prefs.js.tracked

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
