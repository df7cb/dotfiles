BIB = *.bib
BST = address.bst
STY = directory.sty

all: addr.ps

addr.ps: addr.dvi
	dvips addr

addr.dvi: addr.tex $(BIB) $(BST) $(STY)
	@-rm addr.aux addr.bbl
	latex addr
	bibtex addr
	latex addr
	latex addr

clean:
	-rm *.aux *.log *.bbl *.blg *.dvi

distclean: clean
	-rm *.ps *~
