all: tikzanim-howto-fr.pdf tikzanim-howto-en.pdf tikzanim-beamer.pdf
  
%.pdf: %.tex
	latexmk -xelatex $<

clean:
	rm -f *.aux *.fdb_latexmk *.fls *.log *.out *.toc *.tln *.xdv

clean-pdf:
	rm *.pdf

clean-all: clean clean-pdf
