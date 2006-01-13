# Makefile to create links in ~/.irssi/scripts/autorun/
# $Id$

.PHONY: scripts scripts.main
scripts:
	$(MAKE) -C $@ -f ../Makefile scripts_all
scripts.main:
	$(MAKE) -C scripts -f ../Makefile scripts_all.main

clean:
	rm -f scripts/autorun/*.pl

###

scripts_all: autorun links
scripts_all.main: autorun links.main

autorun:
	mkdir $@

# load these scripts only on the irssi proxy server
links.main: links \
	autorun/buf.pl \
	autorun/friends.pl \
	autorun/keepnick.pl \
	autorun/pisgcommits.pl \
	autorun/muttwiki.pl \
	autorun/nickident.pl \
	autorun/screen_away.pl

# load these scripts always
links: \
	autorun/chanact.pl \
	autorun/chanshare.pl \
	autorun/joininfo.pl \
	autorun/len.pl \
	autorun/nickcolor.pl \
	autorun/timer.pl \
	autorun/title.pl \
	autorun/topic-diff.pl \
	autorun/topics.pl \
	autorun/trackbar.pl

#	autorun/autorealname.pl \

autorun/%.pl: %.pl
	ln -s ../$< $@

autorun/%.pl: /usr/share/irssi/scripts/%.pl
	ln -s $< $@
