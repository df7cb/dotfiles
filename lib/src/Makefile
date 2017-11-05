CC=gcc
CFLAGS=-g -Wall -Werror -O2

all: awesome-clock

awesome-clock: awesome-clock.c

install: awesome-clock
	install -D awesome-clock $(HOME)/bin/$(OS)/awesome-clock

clean:
	rm -f awesome-clock

restart:
	-killall awesome-clock
	grep awesome-clock ~/.xsession | sh -
