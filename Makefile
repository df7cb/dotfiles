# $Id$

DEPS = Makefile .configrc

all: .pinerc .ytalkrc

.pinerc: .pinerc.m4 $(DEPS)
	m4 .configrc .pinerc.m4 > .pinerc

.ytalkrc: .ytalkrc.m4 $(DEPS)
	m4 .configrc .ytalkrc.m4 > .ytalkrc

diff:
	diff -u .pinerc.m4 .pinerc || true
