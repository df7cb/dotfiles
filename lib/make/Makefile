# $Id$

#include /home/cb/lib/make/Makefile.*

## latex
TEX = latex

%.tex: %.bib
	bibtex $(basename $<)

%.ps: %.dvi
	dvips $<

dvips: $(patsubst %.dvi, %.ps, $(wildcard *.dvi))

texclean:
	rm -f *.aux *.bbl *.blg *.log

## PVS
pvsclean:
	rm -f .pvscontext *.bin
##
