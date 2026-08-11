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

NAME=Steven
TITLE=Debian specialist
PHONE=
MATRIX=@steven:example.com
EMAIL=steven@example.com
URL=linux020.nl

default: clean print

.ONESHELL:
vcard.vcf: Makefile
	cat <<EOF > vcard.vcf
	BEGIN:VCARD
	VERSION:4.0
	FN:${NAME}
	TEL:${PHONE}
	EMAIL:${EMAIL}
	IMPP:matrix:${MATRIX}
	URL:${URL}
	END:VCARD
	EOF

vcard-qr.png: vcard.vcf
	# Generate a QR code from the vcard.vcf file
	qrencode -o vcard-qr.png < vcard.vcf

.ONESHELL:
data.tex: Makefile
	cat <<EOF > data.tex
	\newcommand{\NAME}{${NAME}}
	\newcommand{\PHONE}{${PHONE}}
	\newcommand{\MATRIX}{${MATRIX}}
	\newcommand{\EMAIL}{${EMAIL}}
	\newcommand{\TITLE}{${TITLE}}
	\newcommand{\URL}{${URL}}
	EOF

install-deps:
	sudo apt-get update 
	sudo apt-get install --yes qrencode

print: data.tex vcard-qr.png
	mkdir -p $(TARGET)
    # Needs to run 3 times to get the pagenumbers in table content right
    # https://tex.stackexchange.com/questions/115921/wrong-numeration-in-toc-longer-then-one-page
	$(RUN_LATEX); $(RUN_LATEX); $(RUN_LATEX)

viewpdf: print
	open $(TARGET)/$(MAINNAME).pdf

clean:
	rm -rf $(TARGET)
	-rm vcard.vcf vcard-qr.png data.tex
