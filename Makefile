# $Id$

DCLEAN = bin/dbuild bin/dconfigure bin/dinstall bin/dbinary bin/dpatch_ bin/dunpatch
all: cleanup .less .xinitrc bin/ctar .priv $(DCLEAN) .ssh/config

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

.PHONY: .priv
.priv:
	-@$(MAKE) -C .priv

tmp /tmp/$(USER):
	mkdir -m 0700 $@

## cleanup stuff ##

cleanup:
COMMITS = $(wildcard .mutt/fortunes-??)

ifeq ($(shell [ -d .firefox ] && echo yes), yes)
cleanup: .firefox/cb/cbcbcbcb.slt/.bookmarks.html
all: .firefox/cb/cbcbcbcb.slt/prefs.js
COMMITS += .firefox/cb/cbcbcbcb.slt/bookmarks.html
endif
.firefox/cb/cbcbcbcb.slt/.bookmarks.html: .firefox/cb/cbcbcbcb.slt/bookmarks.html
	# Cleaning $<
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	@perl -i -pe 's/ (LAST_VISIT)="\d+"//g' $<
	@touch $@
.firefox/cb/cbcbcbcb.slt/prefs.js: .firefox/cb/cbcbcbcb.slt/prefs.js.tracked
	# Updating $@
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	cat $< >> $@
firefox-pull:
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	.firefox/cb/cbcbcbcb.slt/pull .firefox/cb/cbcbcbcb.slt/prefs.js > .firefox/cb/cbcbcbcb.slt/prefs.js.tracked

ifeq ($(shell [ -d lib/todo ] && echo yes), yes)
COMMITS += lib/todo/todo
endif

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

