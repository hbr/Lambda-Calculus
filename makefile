.PHONY: lambda1 lambda2 gh-pages

lambda1:
	make -C lambda1 pass2


lambda2:
	make -C lambda2 lambda.html; \
	make -C lambda2 lambda.pdf

gh-pages: lambda1 lambda2
	cp	index.html \
		lambda2/lambda.html \
		lambda2/lambda.pdf  \
		lambda1/untyped_lambda.pdf  \
		gh-pages/
