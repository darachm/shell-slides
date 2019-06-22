.PHONY: all prezi

inputz = $(filter-out README.md,$(wildcard *.md))
reports = $(patsubst %.md,%_report.html,$(inputz)) \
	$(patsubst %.md,%_report.pdf,$(inputz))

prezi = wiring/d3.v4.min.js wiring/dagre-d3.min.js wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html wiring/angularplasmid.complete.min.js

all: $(prezi) #$(reports) 

#

wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html: 
	git clone https://github.com/hakimel/reveal.js.git wiring/reveal.js

wiring/d3.v4.min.js:
	wget https://d3js.org/d3.v4.min.js -O $@

wiring/dagre-d3.min.js:
	wget https://dagrejs.github.io/project/dagre-d3/latest/dagre-d3.min.js -O $@

wiring/angularplasmid.complete.min.js:
	wget http://angularplasmid.vixis.com/downloadfile.php?f=angularplasmid.complete.min.js -O $@

%_report.pdf: %.md wiring/template-pdf.tex
	pandoc --standalone --output $@ \
		-F ./wiring/pandoc-filter-graphviz \
		--template=$(word 2,$^) --self-contained \
		--to=latex --latex-engine=xelatex \


