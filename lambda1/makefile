.PHONY: pass1 pass2 clean

source-files = \
    common.tex         \
    computation.tex    \
    lambdaterms.tex    \
    main_untyped_lambda.tex \
    motivation.tex     \
    reductionstrategy.tex \
    setrelation.tex    \
    undecidability.tex \
    uniqueterms.tex    \
    hilbert.jpg        \
    turing.jpg         \
    goedel.jpg         \
    church.jpg


generate-pdf = \
    cp $(source-files) _build/; \
    (cd _build; pdflatex main_untyped_lambda.tex); \
    mv _build/main_untyped_lambda.pdf untyped_lambda.pdf


generate-bib = \
    (cd _build; bibtex main_untyped_lambda)


generate-all = $(generate-pdf); $(generate-bib)






# Rules

pass2: _build/pass2

pass1: _build/pass1

clean:
	rm _build/*


_build/pass2: _build/pass1
	$(generate-all); touch _build/pass2

_build/pass1: $(source-files)
	$(generate-all); touch _build/pass1


bib:   # make bibliography the first time
	$(generate-all)

