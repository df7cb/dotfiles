# $Id$
CC = gcc
CFLAGS = -Wall -O2 -I/usr/X11R6/include
LDFLAGS = -s -L/usr/X11R6/lib -lX11
TARGETS = xkbd
BINOSDIR = $(HOME)/bin/$(OS)

all: $(TARGETS)

xkbd: xkbd.o

install: $(TARGETS)
	mkdir -p $(BINOSDIR)
	mv $(TARGETS) $(BINOSDIR)
	rm *.o

clean:
	-rm $(TARGETS) *.o *~
