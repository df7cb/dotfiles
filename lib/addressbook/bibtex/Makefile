BIB = *.bib
DEP = $(BIB) address.bst directory.sty

all: addr.ps geb.ps email.ps

%.ps: %.tex
	latex $(basename $@)
	bibtex $(basename $@)
	perl -i -pe 's/_/\\_/g; s/\/~/\/\\~{}/g;' $(basename $@).bbl
	latex $(basename $@)
	latex $(basename $@)
	dvips $(basename $@)
	@rm -f *.aux *.log *.bbl *.blg *.dvi

addr.tex: addr $(DEP)
	./addr -o addr.tex

geb.tex: addr $(DEP)
	./addr -o geb.tex -b

email.tex: addr $(DEP)
	./addr -o email.tex -e

clean:
	rm -f *.tex *.ps *.aux *.log *.bbl *.blg *.dvi
