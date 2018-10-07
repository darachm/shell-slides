.PHONY: all

inputz = $(filter-out README.md,$(wildcard *.md))
wanted = \
	$(patsubst %.md,%_report.html,$(inputz)) \
	$(patsubst %.md,%_slides.html,$(inputz)) \
	$(patsubst %.md,%_report.pdf,$(inputz))

all: $(wanted)

wiring/reveal.js/js/reveal.js: 
	git clone https://github.com/hakimel/reveal.js.git wiring/reveal.js

wiring/reveal.js/css/theme/darach_slides.css: wiring/reveal.js/js/reveal.js \
	wiring/darach_slides.css
	cp wiring/darach_slides.css wiring/reveal.js/css/theme/darach_slides.css 

%_report.html: %.md wiring/template-html.html
	gpp -H -Dreport $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=html

%_slides.html: %.md wiring/template-slides.html wiring/reveal.js/js/reveal.js \
	wiring/reveal.js/css/theme/darach_slides.css
	gpp -H -Dslides $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		-V revealjs-url=wiring/reveal.js --to=revealjs --slide-level 1

%_report.pdf: %.md wiring/template-pdf.tex
	gpp -H -Dreport $< | \
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=latex --latex-engine=xelatex \
