# $Id$

DEPS = Makefile .configrc
UNDEFINE = -Uformat -Uindex -Uunix

all: .pinerc .ytalkrc

.pinerc: .pinerc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .pinerc.m4 > .pinerc

.ytalkrc: .ytalkrc.m4 $(DEPS)
	m4 $(UNDEFINE) .configrc .ytalkrc.m4 > .ytalkrc

diff:
	diff -u .pinerc.m4 .pinerc || true
