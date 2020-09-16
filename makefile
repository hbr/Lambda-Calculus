.PHONY: lambda1 lambda1-bibtex \
	lambda2 lambda2-tex


lambda1: lambda1-bibtex
	cd lambda1; \
	(pdflatex main_untyped_lambda.tex; \
	cp main_untyped_lambda.pdf ../untyped_lambda.pdf)

lambda1-bibtex:
	cd lambda1; bibtex main_untyped_lambda

lambda2:
	make -C lambda2 lambda.html; \
	make -C lambda2 lambda.pdf

gh-pages: lambda1 lambda2
	cp	index.html \
		lambda2/lambda.html \
		lambda2/lambda.pdf  \
		untyped_lambda.pdf  \
		gh-pages/
