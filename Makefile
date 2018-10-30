.PHONY: all prezi

inputz = $(filter-out README.md,$(wildcard *.md))
reports = $(patsubst %.md,%_report.html,$(inputz)) \
	$(patsubst %.md,%_report.pdf,$(inputz))

all: $(reports) prezi

refresh: 

wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html: 
	git clone http://github.com/hakimel/reveal.js.git wiring/reveal.js

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

template_slides.html: wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html wiring/darach_slides.css
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^(.*)<link rel=\"stylesheet\" href=\"css\/reveal.css\">.*/\1/;s/NULLZ/\n/g;' \
		> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"css\/reveal.css\">(.*)<link rel=\"stylesheet\" href=\"css\/theme\/black.css\">.*/\1/;s/NULLZ/\n/g;' \
		>> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"css\/theme\/black.css\">(.*)<link rel=\"stylesheet\" href=\"lib\/css\/zenburn.css\">.*/\1/;s/NULLZ/\n/g;' \
		>> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"lib\/css\/zenburn.css\">(.*?<script>.*?<\/script>).*/\1/;s/<!--.*?-->//g;s/^/<!--/;s/$$/-->\n/;s/NULLZ/\n/g;' \
		>> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*(<\/head>.*?)<script src="lib\/js\/head.min.js"><\/script>.*/\1/;s/NULLZ/\n/g;' \
		>> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<script src="lib\/js\/head.min.js"><\/script>(.*)<script src="js\/reveal.js"><\/script>.*/\1/;s/NULLZ/\n/g;' \
		>> $@
	#
	echo "<!-- css/reveal.css --><style>" >> $@
	cat wiring/reveal.js/css/reveal.css >> $@
	echo "</style>" >> $@
	#
	echo "<!-- css/theme/black.css --><style>" >> $@
	cat wiring/darach_slides.css >> $@
	echo "</style>" >> $@
	#
	echo "<!-- lib/css/zenburn.css --><style>" >> $@
	cat wiring/reveal.js/lib/css/zenburn.css >> $@
	echo "</style>" >> $@
	#
	echo "<!-- lib/js/head.min.js --><script>" >> $@
	cat wiring/reveal.js/lib/js/head.min.js >> $@
	echo "</script>" >> $@
	#
	echo "<!-- js/reveal.js --><script>" >> $@
	cat wiring/reveal.js/js/reveal.js >> $@
	echo "</script>" >> $@
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<script src="js\/reveal.js"><\/script>(.*)/\1/;s/plugin\//wiring\/reveal.js\/plugin/g;s/NULLZ/\n/g;' \
		>> $@
