# $Id$

all: .configrc .less .plan.dir/dayplan .ssh/cb@fermi .ssh/config .ytalkrc .xinitrc bin/ctar

## targets ##

#.firefox/cb/cbcbcbcb.slt/bookmarks.html:
#	[ -f .priv/bookmarks.html ] && ln -s ../../../.priv/bookmarks.html $@

.less: .lesskey
	lesskey

.plan.dir/dayplan:
	[ -f .priv/dayplan ] && ln -s ../.priv/dayplan $@

.ssh/cb@fermi:
	[ -f .priv/cb@fermi ] && cd .ssh && ln -s ../.priv/cb@fermi* .

.ssh/config: .ssh/config.m4
	@rm -f $@
	m4 $< > $@
	@chmod -w $@

.xinitrc:
	ln -s .xsession .xinitrc

.ytalkrc: .ytalkrc.m4 .configrc
	m4 .configrc .ytalkrc.m4 > .ytalkrc

bin/ctar:
	ln -s ttar bin/ctar

.PHONY: /tmp/$(USER) tmp
tmp /tmp/$(USER):
	mkdir -m 0700 $@ ; ls -ld $@

## cleanup stuff ##

cleanup:
COMMITS =

ifeq ($(shell [ -d .firefox ] && echo yes), yes)
cleanup: .firefox/cb/cbcbcbcb.slt/.bookmarks.html
COMMITS += .firefox/cb/cbcbcbcb.slt/bookmarks.html
endif
.firefox/cb/cbcbcbcb.slt/.bookmarks.html: .firefox/cb/cbcbcbcb.slt/bookmarks.html
	# Cleaning $<
	@[ ! -L .firefox/cb/cbcbcbcb.slt/lock ]
	@perl -i -pe 's/ (LAST_VISIT)="\d+"//g' $<
	@touch $@

ifeq ($(shell [ -d .galeon ] && echo yes), yes)
cleanup: .galeon/.bookmarks.xbel
COMMITS += .galeon/bookmarks.xbel
endif
.galeon/.bookmarks.xbel: .galeon/bookmarks.xbel
	# Cleaning $<
	@if pidof galeon-bin > /dev/null ; then echo "Galeon is running " ; false ; else true ; fi
	@-[ -f .galeon/bookmarks.xbel ] && perl -i -ne 's/folded="no"/folded="yes"/; print unless /^\s+<time_visited>\d+<\/time_visited>$$/' .galeon/bookmarks.xbel
	@touch $@

ifeq ($(shell [ -d .mutt ] && echo yes), yes)
cleanup: .mutt/.aliases
COMMITS += .mutt/aliases
endif
.mutt/.aliases: .mutt/aliases
	# Sorting $<
	@grep -qv '<<<<' $<
	@mv $< $<.bak
	@LC_ALL=C sort -u $<.bak > $<
	@rm -f $<.bak
	@touch $@
# find duplicate aliases
	@cut -f2 -d' ' .mutt/aliases .mutt/aliases.addressbook | sort | uniq -d

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

ifeq ($(shell [ -d .plan.dir ] && echo yes), yes)
cleanup: .plan.dir/check-plan-running
COMMITS += .priv/dayplan
endif
.plan.dir/check-plan-running:
	@[ ! -f .plan.dir/lock.plan ]

ifeq ($(shell [ -f .ssh/known_hosts ] && echo yes), yes)
cleanup: .ssh/.known_hosts
COMMITS += .ssh/known_hosts
endif
known_hosts-uniq:
	@cut -d' ' -f 1-2 < .ssh/known_hosts | uniq -d
	@perl -e 'while(<>){ foreach(/^(\w+)\b/) { print "repeated: $$_\n" if $$1 eq $$l; $$l = $$1; }}' .ssh/known_hosts
.ssh/.known_hosts: .ssh/known_hosts
	# Sorting $<
	@grep -qv '<<<<' $<
	@mv $< $<.bak
	@LC_ALL=C sort -u $<.bak > $<
	@rm -f $<.bak
	@touch $@

ifeq ($(shell [ -d lib/addressbook ] && echo yes), yes)
cleanup: lib/addressbook/check-addressbook-running
COMMITS += lib/addressbook/cb.dat
endif
lib/addressbook/check-addressbook-running:
	@[ ! -f lib/addressbook/cb.dat.lock ]

ifeq ($(shell [ -d lib/todo ] && echo yes), yes)
COMMITS += lib/todo/todo
endif

## update stuff ##

# this needs GNU make
export CVSIGNORE=*
export CVS_RSH=ssh

up: update
update: cleanup
	cvs -q update

safe: cleanup # conflict
	for file in `cvs -q -n update | grep '^[MPU] ' | cut -c 3-` ; do \
		cvs update $$file ; done

conflict:
	-cvs -q -n update | grep '^C '

com: commit
commit: cleanup
	cvs commit -m "make commit by $(USER)@$(HOSTNAME)" $(COMMITS)

## installation stuff ##

install:
	[ ! -f .configrc ]
	rm -f ../.ssh/known_hosts
	-rmdir ../.ssh
	-[ -d ../.ssh ] && mv ../.ssh ../ssh~
	-[ -d ../.ssh2 ] && mv ../.ssh2 ../ssh2~
	mv * .[a-z]* .[A-Z]* ..
	cd .. ; rmdir cb conf ; $(MAKE)

.configrc:
	echo "divert(-1)" >> .configrc
	echo "# local configuration data: `hostname`" >> .configrc
	echo "" >> .configrc
	echo "define(_MAILDOMAIN_, `hostname`)" >> .configrc
	echo "define(_ORGANIZATION_, \`')" >> .configrc
	echo "define(_YTALK_, 3.1)" >> .configrc
	echo "" >> .configrc
	echo "divert(0)dnl" >> .configrc
	vim .configrc || vi .configrc

.ssh/known_hosts:
	# Fetching new $@
	echo "#!/bin/sh" > $(HOME)/ssh-update
	echo 'ssh -o "UserKnownHostsFile $$HOME/ssh_known_hosts" "$$@"' >> $(HOME)/ssh-update
	chmod 700 $(HOME)/ssh-update
	CVS_RSH="$(HOME)/ssh-update" cvs up $@
	rm -f $(HOME)/ssh-update $(HOME)/ssh_known_hosts

##
