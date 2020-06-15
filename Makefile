all: tikzanim-howto.pdf

%.pdf: %.tex
	latexmk -xelatex $<

clean:
	rm tikzanim-howto.aux tikzanim-howto.fdb_latexmk tikzanim-howto.fls tikzanim-howto.log tikzanim-howto.out tikzanim-howto.toc tikzanim-howto.tzc0.tln tikzanim-howto.tzc1.tln tikzanim-howto.xdv

clean-all: clean
	rm tikzanim-howto.pdf
