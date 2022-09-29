.PHONY: lambda1 lambda2 computability cc-tex gh-pages

lambda1:
	make -C lambda1 pass2


lambda2:
	make -C lambda2 lambda.html; \
	make -C lambda2 lambda.pdf

computability:
	make -C computability text.html

cc-tex:
	make -C cc-tex pdf

gh-pages: lambda1 lambda2 computability
	cp index.html gh-pages/; \
	cp lambda1/untyped_lambda.pdf gh-pages/lambda1/; \
	cp lambda2/lambda.html        gh-pages/lambda2/; \
	cp lambda2/lambda.pdf         gh-pages/lambda2/; \
	cp computability/*.html	      gh-pages/computability/
