.PHONY: all prezi

inputz = $(filter-out README.md,$(wildcard *.md))
reports = $(patsubst %.md,%_report.html,$(inputz)) \
	$(patsubst %.md,%_report.pdf,$(inputz))
prezi = wiring/reveal.js/plugin/d3js.js wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html

all: $(prezi) #$(reports) 

#

wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html: 
	git clone https://github.com/hakimel/reveal.js.git wiring/reveal.js

wiring/reveal.js/plugin/d3js.js: wiring/reveal.js/js/reveal.js
	wget https://raw.githubusercontent.com/jlegewie/reveal.js-d3js-plugin/master/d3js.js -O $@

%_report.html: %.md wiring/template-html.html
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=html

%_report.pdf: %.md wiring/template-pdf.tex
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=latex --latex-engine=xelatex \


