# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: cleanup .mutt/muttrc.local \
	.less .pinerc .ytalkrc .xinitrc .configrc bin/ctar

## targets ##

.less: .lesskey
	lesskey

.PHONY: /tmp/$(USER) tmp
/tmp/$(USER):
	umask 077 ; mkdir $@ ; ls -ld $@
tmp:
	umask 077 ; mkdir $@ ; ls -ld $@

# mutt
.mutt/muttrc.local:
	touch .mutt/muttrc.local

# pine
.pinerc: .pinerc.m4 .configrc
	m4 $(UNDEFINE) .configrc .pinerc.m4 > .pinerc
diff:
	diff -u .pinerc.m4 .pinerc || true

.ytalkrc: .ytalkrc.m4 .configrc
	m4 $(UNDEFINE) .configrc .ytalkrc.m4 > .ytalkrc

.xinitrc:
	ln -s .xsession .xinitrc

mail/d:
	@mkdir mail || true
	touch mail/deleted
	ln -s deleted mail/d

bin/ctar:
	ln -s ttar bin/ctar

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

STAMPS = .netscape/.bookmarks.html .galeon/.bookmarks.xbel .ssh/.known_hosts .mutt/.aliases
CLEANS = .netscape/bookmarks.html .galeon/bookmarks.xbel .ssh/known_hosts .mutt/aliases
COMMITS = $(CLEANS) .ncftp/bookmarks .plan.dir/dayplan lib/addressbook/cb.dat lib/todo/todo
RUNS = plan-run addressbook-run

com: commit
commit: cleanup
	cvs commit -m "make commit by $(USER)@$(HOST)" $(COMMITS)

cycle: update commit

## cleanup stuff ##

cleanup: $(RUN) $(STAMPS)

.netscape/.bookmarks.html: .netscape/bookmarks.html
	# Cleaning $<
	@[ ! -L .netscape/lock ]
	@perl -i -pe 's/(LAST_VISIT|LAST_MODIFIED)="\d+"/$$1="0"/g' .netscape/bookmarks.html
	@touch $@

.galeon/.bookmarks.xbel: .galeon/bookmarks.xbel
	# Cleaning $<
	@if pidof galeon-bin > /dev/null ; then echo "Galeon is running " ; false ; else true ; fi
	@-[ -f .galeon/bookmarks.xbel ] && perl -i -ne 's/folded="no"/folded="yes"/; print unless /^\s+<time_visited>\d+<\/time_visited>$$/' .galeon/bookmarks.xbel
	@touch $@

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

.mutt/.aliases: .mutt/aliases
	# Sorting $<
	@grep -qv '<<<<' $<
	@mv $< $<.bak
	@LC_ALL=C sort -u $<.bak > $<
	@rm -f $<.bak
	@touch $@
# find duplicate aliases
	@cut -f2 -d' ' .mutt/aliases .mutt/aliases.addressbook | sort | uniq -d

plan-run:
	@[ ! -f .plan.dir/lock.plan ]

addressbook-run:
	@if ps x | grep -q "[a]ddressbook" ; then echo "Addressbook is running " ; false ; else true ; fi

## installation stuff ##

install:
	[ ! -f .configrc ]
	rm -f ../.ssh/known_hosts
	-rmdir ../.ssh
	mv * .[a-z]* .[A-Z]* ..
	@cd .. && rmdir conf && $(MAKE)
	@echo "Fertig. cd .."

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
