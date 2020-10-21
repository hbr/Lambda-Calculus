.PHONY: all basics typing sn


# Variables
top = ../..

basics_title = "Typed Lambda Calculus"

typing_relation_title = "The Typing Relation"

strong_normalization_title =  \
    "Strong Normalization in the Calulus of Constructions"



# Rules

all: basics typing sn

basics: basics.html

typing: typing_relation.html

sn: strong_normalization.html


%.html: %.md $(top)/style.css
	pandoc -s --toc --webtex --toc-depth=2 \
	-o $@ \
	--metadata title=$($*_title) \
	--metadata author="Helmut Brandl" \
	$<  \
	$(top)/style.css



