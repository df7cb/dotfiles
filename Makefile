# $Id$

DEPS = Makefile .configrc

all: .pinerc

.pinerc: .pinerc.m4 $(DEPS)
	m4 .configrc .pinerc.m4 > .pinerc

diff:
	diff -u .pinerc.m4 .pinerc
