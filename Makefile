# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: .pinerc .ytalkrc .xinitrc mail/d .configrc bin/$(OS)/xkbd

.pinerc: .pinerc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .pinerc.m4 > .pinerc

.ytalkrc: .ytalkrc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .ytalkrc.m4 > .ytalkrc

.xinitrc:
	ln -s .xsession .xinitrc

mail/d:
	@mkdir mail || true
	touch mail/deleted
	ln -s deleted mail/d

bin/$(OS)/xkbd:
	make -C bin/src install

diff:
	diff -u .pinerc.m4 .pinerc || true

up: update
update:
	cvs update -I "*"

com: commit
commit:
	cvs commit -m "(laufendes Update)" .netscape/bookmarks.html \
		.ssh/known_hosts .ncftp/bookmarks

install:
	@case "$(PWD)" in *conf) ;; *) echo "Error: already installed?" ; exit 1 ;; esac
	mv * .[a-z]* .[A-Z]* ..
	@cd .. && rmdir conf && make
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
