# $Id$

#include /home/cb/lib/make/Makefile.*

## latex
TEX = latex

%.tex: %.bib
	bibtex $(basename $<)

%.ps: %.dvi
	dvips $<

FIG2DEV = /home/cb/PVS/papers/misc/fig2eps.pl
fig2eps: $(patsubst %.fig, %.eps, $(wildcard *.fig))
%.eps: %.fig
	$(FIG2DEV) $< $@

dvips: $(patsubst %.dvi, %.ps, $(wildcard *.dvi))

texclean:
	rm -f *.aux *.bbl *.blg *.log

## PVS
pvsclean:
	rm -f .pvscontext *.bin
##
