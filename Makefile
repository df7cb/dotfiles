# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: .pinerc .ytalkrc __tests

.pinerc: .pinerc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .pinerc.m4 > .pinerc

.ytalkrc: .ytalkrc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .ytalkrc.m4 > .ytalkrc

diff:
	diff -u .pinerc.m4 .pinerc || true

up: update
update:
	cvs update -I "*"

__tests:
	@echo "Starte Tests..."
	@test -L mail/d || echo "mail/d ist kein Link auf mail/deleted!"

install:
	case "$(PWD)" in */cb-conf) ;; *) echo "Error: already installed?" ; exit 1 ;; esac
	mv * .[a-z]* .[A-Z]* ..
	@cd .. ; rmdir cb-conf

.configrc:
	@echo "'make configrc' erstellt eine .configrc"

configrc:
	echo "divert(-1)" >> .configrc
	echo "# local configuration data: `hostname`" >> .configrc
	echo "" >> .configrc
	echo "define(_MAILDOMAIN_, `hostname`)" >> .configrc
	echo "define(_ORGANIZATION_, \`')" >> .configrc
	echo "define(_YTALK_, 3.1)" >> .configrc
	echo "" >> .configrc
	echo "divert(0)dnl" >> .configrc
	vim .configrc
