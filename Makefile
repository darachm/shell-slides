.PHONY: all

all: report_report.html report_report.pdf report_slides.html

wiring/reveal.js: 
	git clone https://github.com/hakimel/reveal.js.git wiring/reveal.js

%_report.html: %.md wiring/template-html.html
	gpp -H -Dreport $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=html

%_slides.html: %.md wiring/template-slides.html wiring/reveal.js
	gpp -H -Dslides $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		-V revealjs-url=wiring/reveal.js --to=revealjs --slide-level 2

%_report.pdf: %.md wiring/template-pdf.tex
	gpp -H -Dreport $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=latex --latex-engine=xelatex \
