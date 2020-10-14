.PHONY: sn

top = ../..


sn: strong_normalization.html

strong_normalization.html: strong_normalization.md $(top)/style.css
	pandoc -s --toc --webtex \
	    --toc-depth=2       \
	    -o strong_normalization.html \
	    --metadata \
	    title="Strong Normalization in the Calculus of Constructions" \
	    --metadata author="Helmut Brandl" \
	    strong_normalization.md      \
	    $(top)/style.css



