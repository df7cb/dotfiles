# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: .mutt/aliases.new .mutt/muttrc.local \
	.less .pinerc .ytalkrc .xinitrc .configrc

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

## update stuff ##

# this needs GNU make
export CVSIGNORE=*
export CVS_RSH=ssh

up: update
update: cleanup
	cvs -q update

safe: cleanup conflict
	for file in `cvs -q -n update | grep '^[MPU] ' | cut -c 3-` ; do \
		cvs update $$file ; done

conflict:
	-cvs -q -n update | grep '^C '

com: commit
commit: cleanup
	cvs commit -m "(laufendes Update)" .netscape/bookmarks.html .galeon/bookmarks.xbel .ssh/known_hosts .ncftp/bookmarks .plan.dir/dayplan

## cleanup stuff ##

cleanup: bookmark-clean galeon-clean known_hosts-sort

bookmark-clean:
	perl -i -pe 's/(LAST_VISIT|LAST_MODIFIED)="\d+"/$$1="0"/g' .netscape/bookmarks.html

galeon-clean:
	-[ -f .galeon/bookmarks.xbel ] && perl -i -ne 's/folded="no"/folded="yes"/; print unless /^\s+<time_visited>\d+<\/time_visited>$$/' .galeon/bookmarks.xbel

known_hosts-uniq:
	@cut -d' ' -f 1-2 < .ssh/known_hosts | uniq -d
known_hosts-sort: known_hosts-uniq
	@grep -qv '<<<<' .ssh/known_hosts
	mv .ssh/known_hosts .ssh/known_hosts-
	sort -u .ssh/known_hosts- > .ssh/known_hosts
	@rm .ssh/known_hosts-

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
