MAINNAME=bussiness-card
TARGET=pdf
LATEX_IMAGE=leplusorg/latex:sha-4a17317
RUN_LATEX_IMAGE=docker run \
						--rm \
						-t --workdir=/tmp \
						--user="$(shell id -u):$(shell id -g)" \
						--net=none \
						-v "$(shell pwd):/tmp" \
						-e "TEXINPUTS=/tmp/tex:$$TEXINPUTS" \
						 $(LATEX_IMAGE)
RUN_LATEX=$(RUN_LATEX_IMAGE) pdflatex  --interaction batchmode --output-directory=/tmp/pdf $(MAINNAME).tex

default: clean print

print:
	mkdir -p $(TARGET)
    # Needs to run 3 times to get the pagenumbers in table content right
    # https://tex.stackexchange.com/questions/115921/wrong-numeration-in-toc-longer-then-one-page
	$(RUN_LATEX); $(RUN_LATEX); $(RUN_LATEX)

viewpdf: 
	mkdir -p $(TARGET)
	$(RUN_LATEX)
	open $(TARGET)/$(MAINNAME).pdf

clean:
	rm -rf $(TARGET)
