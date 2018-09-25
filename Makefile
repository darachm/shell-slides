.PHONY: all

# This isn't an all rule, but it does yank down reveal.js for ya
all: reveal.js 

reveal.js: 
	git clone https://github.com/hakimel/reveal.js.git

%.pdf: %.md text-report-template.tex
	pandoc --standalone --output $@ \
		--template="text-report-template.tex" \
		--latex-engine=xelatex \
		$< 

darach_miller_cv.html: darach_miller_cv.md cvTemplate.html
	pandoc --standalone --output darach_miller_cv.html \
		--template="cvTemplate.html" \
		darach_miller_cv.md 

