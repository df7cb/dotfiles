# $Id$

all: aliases.addressbook geb.plan

aliases.addressbook: cb.dat aliases addressbook.pm
	./aliases cb.dat > aliases.addressbook

geb.plan: cb.dat geburtstag addressbook.pm
	./geburtstag cb.dat > geb.plan
