.PHONY: lambda2 lambda2-tex


lambda2:
	pandoc -s -o lambda.pdf \
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
