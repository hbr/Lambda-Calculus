.PHONY: lambda-programming


lambda-programming:
	pandoc -s -o lambda.pdf \
		doc/motivation.md \
		doc/basics.md  \
		doc/numbers.md \
		--metadata-file doc/meta.yaml \
		--filter=pandoc-citeproc
