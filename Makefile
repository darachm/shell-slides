.PHONY: all prezi

inputz = $(filter-out README.md,$(wildcard *.md))
reports = $(patsubst %.md,%_report.html,$(inputz)) \
	$(patsubst %.md,%_report.pdf,$(inputz))

all: $(reports) prezi

refresh: 

wiring/reveal.js/js/reveal.js wiring/reveal.js/index.html: 
	git clone https://github.com/hakimel/reveal.js.git wiring/reveal.js

wiring/viz.js: 
	wget https://github.com/mdaines/viz.js/releases/download/v2.0.0/viz.js -O $@ 

wiring/lite.render.js: 
	wget https://github.com/mdaines/viz.js/releases/download/v2.0.0/lite.render.js -O $@ 

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

ts.html ts.js ts.css: wiring/reveal.js/js/reveal.js \
		wiring/reveal.js/index.html wiring/darach_slides.css \
		wiring/viz.js wiring/lite.render.js
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^(.*)<link rel=\"stylesheet\" href=\"css\/reveal.css\">.*/\1/;s/NULLZ/\n/g;' \
		> ts.html
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"css\/reveal.css\">(.*)<link rel=\"stylesheet\" href=\"css\/theme\/black.css\">.*/\1/;s/NULLZ/\n/g;' \
		>> ts.html
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"css\/theme\/black.css\">(.*)<link rel=\"stylesheet\" href=\"lib\/css\/zenburn.css\">.*/\1/;s/NULLZ/\n/g;' \
		>> ts.html
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<link rel=\"stylesheet\" href=\"lib\/css\/zenburn.css\">(.*?<script>.*?<\/script>).*/\1/;s/<!--.*?-->//g;s/^/<!--/;s/$$/-->\n/;s/NULLZ/\n/g;' \
		>> ts.html
	#
	echo "<link rel=\"stylesheet\" href=\"ts.css\">" >> ts.html
	echo "" > ts.css
	cat wiring/reveal.js/css/reveal.css >> ts.css
	cat wiring/darach_slides.css >> ts.css
	cat wiring/reveal.js/lib/css/zenburn.css >> ts.css
	#
	echo "<script src=\"ts.js\"></script>" >> ts.html
	echo "" > ts.js
	cat wiring/reveal.js/lib/js/head.min.js >> ts.js
	cat wiring/reveal.js/js/reveal.js >> ts.js
	cat wiring/viz.js >> ts.js
	cat wiring/lite.render.js >> ts.js
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*(<\/head>.*?)<script src="lib\/js\/head.min.js"><\/script>.*/\1/;s/Slide 1/<h1>Title etc<\/h1>/;s/Slide 2/\n<div id="viz"><\/div>\n/;s/NULLZ/\n/g;' \
		>> ts.html
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<script src="lib\/js\/head.min.js"><\/script>(.*)<script src="js\/reveal.js"><\/script>.*/\1/;s/NULLZ/\n/g;' \
		>> ts.html
	#
	cat $(word 2,$^) | perl -0pe 's/\n/NULLZ/g;s/^.*<script src="js\/reveal.js"><\/script>(.*)<\/body>.*/\1/;s/plugin\//wiring\/reveal.js\/plugin\//g;s/NULLZ/\n/g;' \
		>> ts.html
	#
	echo '<script>document.getElementById("viz").innerHTML = new Viz("digraph { a -> b; }").renderSVGElement();</script>' >> ts.html
	#
	echo "</body></html>" >> ts.html
