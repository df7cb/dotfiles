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
	perl -i -pe 's/_/\\_/g; s/\/~/\/\\~{}/g;' addr.bbl
	latex addr
	latex addr

clean:
	-rm *.aux *.log *.bbl *.blg *.dvi

distclean: clean
	-rm *.ps *~

aliases: addr.tex $(BIB) email-alias.bst
	@-rm addr.bbl 2> /dev/null
	latex addr
	bibtex addr
	mv addr.bbl aliases

addr.html: addr.tex $(BIB) address-html.bst
	@-rm addr.bbl 2> /dev/null
	latex addr
	bibtex addr
	mv addr.bbl addr.html

install: aliases
	cp aliases $(HOME)/.mutt/
