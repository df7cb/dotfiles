# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: .mutt/aliases.new .mutt/muttrc.local \
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
.mutt/aliases.new:
	touch .mutt/aliases.new
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

com: commit
commit: cleanup
	cvs commit -m "make commit by $(USER)@$(HOST)" .netscape/bookmarks.html .galeon/bookmarks.xbel .ssh/known_hosts .ncftp/bookmarks .plan.dir/dayplan lib/addressbook/cb.dat lib/todo/todo

cycle: update commit

## cleanup stuff ##

cleanup: bookmark-clean galeon-clean known_hosts-sort plan-run addressbook-run

bookmark-clean:
	# Cleaning .netscape/bookmarks.html
	@perl -i -pe 's/(LAST_VISIT|LAST_MODIFIED)="\d+"/$$1="0"/g' .netscape/bookmarks.html

galeon-clean:
	# Cleaning .galeon/bookmarks.xbel
	@if pidof galeon-bin > /dev/null ; then echo "Galeon is running " ; false ; else true ; fi
	@-[ -f .galeon/bookmarks.xbel ] && perl -i -ne 's/folded="no"/folded="yes"/; print unless /^\s+<time_visited>\d+<\/time_visited>$$/' .galeon/bookmarks.xbel

known_hosts-uniq:
	@cut -d' ' -f 1-2 < .ssh/known_hosts | uniq -d
known_hosts-sort: # known_hosts-uniq
	# Cleaning .ssh/known_hosts
	@grep -qv '<<<<' .ssh/known_hosts
	@mv .ssh/known_hosts .ssh/known_hosts-
	@LC_ALL=C sort -u .ssh/known_hosts- > .ssh/known_hosts
	@rm .ssh/known_hosts-

plan-run:
	@[ ! -f .plan.dir/lock.plan ]

addressbook-run:
	@if ps x | grep -q "[a]ddressbook" ; then echo "Addressbook is running " ; false ; else true ; fi

## installation stuff ##

install:
	@case "$(PWD)" in *conf) ;; *) echo "Error: already installed?" ; exit 1 ;; esac
	-rm ../.ssh/known_hosts
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

##
