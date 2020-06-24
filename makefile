.PHONY: lambda1 lambda1-bibtex \
	lambda2 lambda2-tex


lambda1: lambda1-bibtex
	cd lambda1; pdflatex main_untyped_lambda.tex

lambda1-bibtex:
	cd lambda1; bibtex main_untyped_lambda


lambda2:
	pandoc -s -o lambda.pdf \
		lambda2/motivation.md \
		lambda2/basics.md  \
		lambda2/arithmetic.md \
		lambda2/datatype.md \
		lambda2/references.md \
		--metadata-file lambda2/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc

lambda2-html:
	pandoc -s --toc --webtex \
		--toc-depth=2    \
		-o lambda.html   \
		lambda2/style.css    \
		lambda2/motivation.md \
		lambda2/basics.md  \
		lambda2/arithmetic.md \
		lambda2/datatype.md \
		lambda2/references.md \
		--metadata-file lambda2/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc

lambda2-tex:
	pandoc -s -o lambda.tex \
		lambda2/motivation.md \
		lambda2/basics.md  \
		lambda2/arithmetic.md \
		lambda2/datatype.md \
		lambda2/references.md \
		--metadata-file lambda2/meta.yaml \
		--filter=pandoc-crossref \
		--filter=pandoc-citeproc
