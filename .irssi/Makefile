# Makefile to create links in ~/.irssi/scripts/autorun/
# $Id$

all: scripts

.PHONY: scripts
scripts:
	$(MAKE) -C $@ -f ../Makefile scripts_all

###

scripts_all: autorun links

autorun:
	mkdir $@

links:	autorun/friends.pl \
	autorun/autorealname.pl \
	autorun/chanact.pl \
	autorun/chanshare.pl \
	autorun/keepnick.pl \
	autorun/len.pl \
	autorun/nickcolor.pl \
	autorun/title.pl

autorun/%.pl: %.pl
	ln -s ../$< $@

autorun/%.pl: /usr/share/irssi/scripts/%.pl
	ln -s $< $@