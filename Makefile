ALL = wrapper.pdf
TEXFILES = wrapper main
#STYFILES = styfiles
#CLSFILES = clsfiles
#FIGURES = 
LATEXMKOPTS = -pdf -dvi-
LATEX = pdflatex
BIBFILES = refs

########### Shouldn't require configuration below here ##########

# run "make CONT=1" for continuous compilation
ifdef CONT
	LATEXMKOPTS += -pvc
	FORCED = .PHONY
endif

all: $(ALL)

$(ALL): $(TEXFILES:=.tex) $(STYFILES:=.sty) $(CLSFILES:=.cls) $(FIGURES) $(BIBFILES:=.bib)


# How to compile a .tex file to a .pdf file
%.pdf: %.tex $(FORCED)
	@if (command -v latexmk > /dev/null) ; then latexmk $(LATEXMKOPTS) $< ; \
	else $(LATEX) $<; bibtex $@; $(LATEX) $<; $(LATEX) $<; fi 

#
# Rules for converting various figure formats to pdf
#

%.pdf_tex: %.svg
	inkscape -A $(@:.pdf_tex=.pdf) --export-latex $<

%.pdf: %.svg
	inkscape -A $@ $<

%.pdf: %.dia
	dia --nosplash -e $(@:.pdf=.eps) $(@:.pdf=.dia) 
	epstopdf $(@:.pdf=.eps)

%.pdf: %.fig
	fig2dev -L pdftex $< $@

%.pdf_t: %.fig %.pdf
	fig2dev -L pdftex_t -p $(@:.pdf_t=.pdf) $< $@

%.pstex_t: %.fig
	fig2dev -L pstex_t -p $(@:.pstex_t=.pstex) $< $@
	fig2dev -L pstex $< $(@:.pstex_t=.pstex)

.PHONY:

clean:
	latexmk -C
