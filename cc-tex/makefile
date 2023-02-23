build-dir    = ../_build/cc-tex/
gh-pages-dir = ../gh-pages/


source-files = \
	cc.tex \
	cc_abstract.tex     \
	cc_macros.tex       \
	cc_introduction.tex \
	cc_mathematics.tex  \
	cc_calculus.tex \
	cc_confluence.tex \
	cc_typing.tex \
	cc_snproof.tex \
	cc_references.tex


# Generate a pdf from scratch:
#     make pdf			1st pass collect all references
#     make bib			extract from bib database
#     make pdf			2nd pass update references


# Run pdflatex and generate the pdf file (only once)
# Run it twice to get crossreferences correct if new labels have been
# introduced.
.PHONY: pdf
pdf: mk-build-dir
	rm $(build-dir)*.tex;  \
	cp $(source-files) $(build-dir); \
	(cd $(build-dir); pdflatex cc.tex)


# Extract citations for the bib database. Run always, if a new citation has been
# added.
.PHONY: bib
bib: mk-build-dir
	(cd $(build-dir); bibtex cc)



# Copy web content to the $(gh-pages-dir), add and commit it to the github repo.
# To publish it on the github web page, just issue "git push -f" in the
# $(gh-pages-dir)
.PHONY: gh-pages
gh-pages:
	(cd $(gh-pages-dir); git rm -r -f cc-tex); \
	mkdir $(gh-pages-dir)cc-tex;          \
	cp index.html $(gh-pages-dir)cc-tex/; \
	cp $(build-dir)cc.pdf $(gh-pages-dir)cc-tex/;
	(cd $(gh-pages-dir); git add cc-tex; git commit --amend --no-edit)



.PHONY: mk-build-dir
mk-build-dir:
	test -d "$(build-dir)" || mkdir -p $(build-dir)
