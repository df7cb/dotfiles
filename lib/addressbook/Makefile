# $Id$

DAT = cb.dat
DEPS = cb.dat addressbook.pm
ALIASES = $(HOME)/.mutt/aliases.addressbook

this: check $(ALIASES) geb.plan abi96.list bibtex/cb.bib
all: this bibtex

.PHONY: check
check:
	-./check $(DAT)

$(ALIASES): aliases $(DEPS)
	./aliases $(DAT) > $@

geb.plan: geburtstag $(DEPS)
	./geburtstag $(DAT) > $@

abi96.list: mailinglist $(DEPS)
	./mailinglist vdl $(DAT) > $@

bibtex/cb.bib: address2bib $(DEPS)
	./address2bib $(DAT) > $@

.PHONY: bibtex
bibtex: check bibtex/cb.bib
	make -C bibtex
