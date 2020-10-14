.PHONY: sn


# Variables
top = ../..

strong_normalization_title =  \
    "Strong Normalization in the Calulus of Constructions"



# Rules
sn: strong_normalization.html


%.html: %.md $(top)/style.css
	pandoc -s --toc --webtex --toc-depth=2 \
	-o $@ \
	--metadata title=$($*_title) \
	--metadata author="Helmut Brandl" \
	$<  \
	$(top)/style.css



