# $Id$

DEPS = addressbook.pm

all: aliases.addressbook geb.plan abi96.list

aliases.addressbook: cb.dat aliases $(DEPS)
	./aliases cb.dat > aliases.addressbook

geb.plan: cb.dat geburtstag $(DEPS)
	./geburtstag cb.dat > geb.plan

abi96.list: cb.dat mailinglist $(DEPS)
	./mailinglist vdl cb.dat > abi96.list
