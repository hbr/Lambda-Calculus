source-files = \
    style.css \
    computability.md


text.html: $(source-files) meta.yaml
	pandoc -s --toc --webtex \
		--toc-depth=2    \
		-o text.html     \
		$(source-files)  \
		--metadata-file meta.yaml \
		--filter=pandoc-crossref
