source-files = \
    style.css \
    motivation.md \
    basics.md \
    arithmetic.md \
    datatype.md
	
lambda.html: $(source-files) meta.yaml
	pandoc -s --toc --webtex \
		--toc-depth=2    \
		-o lambda.html   \
		$(source-files)  \
		--metadata-file meta.yaml \
		--filter=pandoc-crossref  \
		--citeproc


lambda.pdf: $(source-files) meta.yaml
	pandoc -s --toc --webtex \
		--toc-depth=2    \
		-o lambda.pdf    \
		$(source-files)  \
		--metadata-file meta.yaml \
		--filter=pandoc-crossref  \
		--citeproc


