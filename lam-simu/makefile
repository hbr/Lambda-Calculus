main         = simu
local-dir    = lam-simu
build-dir    = ../_build/$(local-dir)/
gh-pages-dir = ../gh-pages/


source-files = \
	$(main).tex            \
	simu_macros.tex


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
	(cd $(build-dir); pdflatex $(main).tex)


# Extract citations for the bib database. Run always, if a new citation has been
# added.
.PHONY: bib
bib: mk-build-dir
	(cd $(build-dir); bibtex $(main))



# Copy web content to the $(gh-pages-dir), add and commit it to the github repo.
# To publish it on the github web page, just issue "git push -f" in the
# $(gh-pages-dir)
.PHONY: gh-pages
gh-pages:
	(cd $(gh-pages-dir); git rm -r -f $(local-dir)); \
	mkdir $(gh-pages-dir)$(local-dir);          \
	cp index.html $(gh-pages-dir)$(local-dir)/; \
	cp $(build-dir)$(main).pdf $(gh-pages-dir)$(local-dir)/; \
	(cd $(gh-pages-dir); git add $(local-dir); git commit --amend --no-edit)



.PHONY: mk-build-dir
mk-build-dir:
	test -d "$(build-dir)" || mkdir -p $(build-dir)
