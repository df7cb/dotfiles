# $Id$

DEPS = addressbook.pm
ALIASES = $(HOME)/.mutt/aliases.addressbook

all: $(ALIASES) geb.plan abi96.list

$(ALIASES): cb.dat aliases $(DEPS)
	./aliases cb.dat > $@

geb.plan: cb.dat geburtstag $(DEPS)
	./geburtstag cb.dat > $@

abi96.list: cb.dat mailinglist $(DEPS)
	./mailinglist vdl cb.dat > $@
