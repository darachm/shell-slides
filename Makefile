.PHONY: all

all: report_report.html report_report.pdf report_slides.html

reveal.js: 
	git clone https://github.com/hakimel/reveal.js.git

%_report.html: %.md template-html.html
	pandoc --standalone --output $@ \
		--template=$(word 2,$^) --self-contained \
		--to=html \
		$< 

%_report.pdf: %.md template-pdf.tex
	pandoc --standalone --output $@ \
		--template=$(word 2,$^) --self-contained \
		--to=latex --latex-engine=xelatex \
		$< 

%_slides.html: %.md template-slides.html reveal.js
	pandoc --standalone --output $@ \ 
		--template=$(word 2,$^) --self-contained \
		--to=revealjs \
		$< 

#gpp -H <options> <filename> | pandoc -f markdown -t <format> -o <outfile>
