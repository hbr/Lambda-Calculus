.PHONY: lambda1 lambda1-bibtex \
	lambda2 lambda2-tex


lambda1: lambda1-bibtex
	cd lambda1; pdflatex main_untyped_lambda.tex

lambda1-bibtex:
	cd lambda1; bibtex main_untyped_lambda


lambda2:
	pandoc -s -o lambda.pdf \
		doc/motivation.md \
		doc/basics.md  \
		doc/numbers.md \
		--metadata-file doc/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc

lambda2-html:
	pandoc -s --toc --webtex \
		--toc-depth=2    \
		-o lambda.html   \
		doc/style.css    \
		doc/motivation.md \
		doc/basics.md  \
		doc/numbers.md \
		--metadata-file doc/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc

lambda2-tex:
	pandoc -s -o lambda.tex \
		doc/motivation.md \
		doc/basics.md  \
		doc/numbers.md \
		--metadata-file doc/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc
