# $Id$

all: cleanup .less .ssh/config .ytalkrc .xinitrc bin/ctar .priv

## targets ##

.less: .lesskey
	lesskey

.ssh/config: .ssh/config.m4
	@rm -f $@
	m4 $< > $@
	@chmod -w $@

.xinitrc:
	ln -s .xsession .xinitrc

bin/ctar:
	ln -s ttar bin/ctar

.PHONY: .priv
.priv:
	$(MAKE) -C .priv

.PHONY: /tmp/$(USER) tmp
tmp /tmp/$(USER):
	mkdir -m 0700 $@ ; ls -ld $@

## cleanup stuff ##

cleanup:
COMMITS = $(wildcard .mutt/fortunes-??)

ifeq ($(shell [ -d .firefox ] && echo yes), yes)
cleanup: .firefox/cb/cbcbcbcb.slt/.bookmarks.html
COMMITS += .firefox/cb/cbcbcbcb.slt/bookmarks.html
endif
.firefox/cb/cbcbcbcb.slt/.bookmarks.html: .firefox/cb/cbcbcbcb.slt/bookmarks.html firefox-run
	# Cleaning $<
	@perl -i -pe 's/ (LAST_VISIT)="\d+"//g' $<
	@touch $@
firefox-run:
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]

ifeq ($(shell [ -d .galeon ] && echo yes), yes)
cleanup: .galeon/.bookmarks.xbel
COMMITS += .galeon/bookmarks.xbel
endif
.galeon/.bookmarks.xbel: .galeon/bookmarks.xbel
	# Cleaning $<
	@if pidof galeon-bin > /dev/null ; then echo "Galeon is running " ; false ; else true ; fi
	@-[ -f .galeon/bookmarks.xbel ] && perl -i -ne 's/folded="no"/folded="yes"/; print unless /^\s+<time_visited>\d+<\/time_visited>$$/' .galeon/bookmarks.xbel
	@touch $@

ifeq ($(shell [ -d .kazehakase ] && echo yes), yes)
cleanup: .kazehakase/.bookmarks.xml
#COMMITS += .kazehakase/bookmarks.xml
endif
.kazehakase/.bookmarks.xml: .kazehakase/bookmarks.xml
	# Cleaning $<
	@if pidof kazehakase > /dev/null ; then echo "kazehakase is running " ; false ; else true ; fi
	@touch $@

ifeq ($(shell [ -d .ncftp ] && echo yes), yes)
COMMITS += .ncftp/bookmarks
endif

ifeq ($(shell [ -d .netscape ] && echo yes), yes)
cleanup: .netscape/.bookmarks.html
COMMITS += .netscape/bookmarks.html
endif
.netscape/.bookmarks.html: .netscape/bookmarks.html
	# Cleaning $<
	@[ ! -L .netscape/lock ]
	@perl -i -pe 's/(LAST_VISIT|LAST_MODIFIED)="\d+"/$$1="0"/g' .netscape/bookmarks.html
	@touch $@

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

com: commit
commit: cleanup
	svn commit -m "make commit by $(USER)@$(HOSTNAME)" $(COMMITS)
	@if [ -d .priv ] ; then $(MAKE) -C .priv commit ; fi

