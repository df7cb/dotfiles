# $Id$

DCLEAN = bin/dbuild bin/dconfigure bin/dinstall bin/dbinary bin/dpatch_ bin/dunpatch
all: cleanup .less .xinitrc bin/ctar .priv $(DCLEAN)

## targets ##

.less: .lesskey
	lesskey

.xinitrc:
	ln -s .xsession .xinitrc

bin/ctar:
	ln -s ttar bin/ctar

$(DCLEAN):
	ln -s dclean $@

.PHONY: .priv
.priv:
	@$(MAKE) -C .priv

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

ifeq ($(shell [ -f .ssh/known_hosts ] && echo yes), yes)
cleanup: .ssh/.known_hosts
COMMITS += .ssh/known_hosts
endif
known_hosts-uniq:
	@cut -d' ' -f 1-2 < .ssh/known_hosts | uniq -d
	@cut -d' ' -f 2-3 < .ssh/known_hosts | sort | uniq -d | while read line ; do grep "$line" .ssh/known_hosts ; done
	@perl -e 'while(<>){ foreach(/(\w+)/) { print "repeated: $$s{$$_}:$$_\n" if $$s{$$_}; $$s{$$_} = $$.; }}' .ssh/known_hosts
.ssh/.known_hosts: .ssh/known_hosts
	# Sorting $<
	@grep -qv '<<<<' $<
	@mv $< $<.bak
	@LC_ALL=C sort -u $<.bak > $<
	@rm -f $<.bak
	@touch $@

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

