# $Id$

#include /home/cb/lib/make/Makefile.*

## latex
TEX = latex

# bibtex
%.bbl: %.bib %.tex
	bibtex $(basename $<)

# dvi -> ps
%.ps: %.dvi
	dvips -o $@ $<

dvips: $(patsubst %.dvi, %.ps, $(wildcard *.dvi))

# dvi -> pdf
%.pdf: %.dvi
	dvipdf $< $@

dvipdf: $(patsubst %.dvi, %.pdf, $(wildcard *.dvi))

# fig -> eps
FIG2DEV = /home/cb/PVS/papers/misc/fig2eps.pl
%.eps: %.fig
	$(FIG2DEV) $< $@

fig2eps: $(patsubst %.fig, %.eps, $(wildcard *.fig))

#
texclean:
	rm -f *.aux *.bbl *.blg *.log

## PVS
pvsclean:
	rm -f .pvscontext *.bin
##
