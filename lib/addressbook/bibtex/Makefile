all: addr.ps

addr.ps: addr.dvi
	dvips addr

addr.dvi: addr.tex *.bib
	latex addr
	bibtex addr
	latex addr
	latex addr

clean:
	-rm *.aux *.log *.bbl *.blg *.dvi

distclean: clean
	-rm *.ps *~
