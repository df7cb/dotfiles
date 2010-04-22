CC=gcc
CFLAGS=-g -Wall -Werror -O2

all: awesome-clock gnome-keyring-query

awesome-clock: awesome-clock.c

gnome-keyring-query: gnome-keyring-query.c
	gcc `pkg-config --cflags --libs gnome-keyring-1 glib-2.0` -o gnome-keyring-query gnome-keyring-query.c

install: awesome-clock gnome-keyring-query
	install -D awesome-clock $(HOME)/bin/$(OS)/awesome-clock
	install -D gnome-keyring-query $(HOME)/bin/$(OS)/gnome-keyring-query

clean:
	rm -f awesome-clock gnome-keyring-query

restart:
	-killall awesome-clock
	grep awesome-clock ~/.xsession | sh
