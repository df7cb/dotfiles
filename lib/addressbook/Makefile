# $Id$

DAT = cb.dat
DEPS = cb.dat addressbook.pm
ALIASES = $(HOME)/.mutt/aliases.addressbook

all: do-check $(ALIASES) geb.plan abi96.list

do-check:
	-./check $(DAT)

$(ALIASES): aliases $(DEPS)
	./aliases $(DAT) > $@

geb.plan: geburtstag $(DEPS)
	./geburtstag $(DAT) > $@

abi96.list: mailinglist $(DEPS)
	./mailinglist vdl $(DAT) > $@
