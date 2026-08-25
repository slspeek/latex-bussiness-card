MAINNAME=bussiness-card
TARGET=pdf
LATEX_IMAGE=texlive/texlive:TL2024-historic
RUN_LATEX_IMAGE=docker run \
						--rm \
						-t --workdir=/workdir \
						--user="$(shell id -u):$(shell id -g)" \
						--net=none \
						-v "$(shell pwd):/workdir" \
						-e TEXMFCACHE=/workdir/.texcache \
  						-e TEXMFVAR=/workdir/.texcache \
						 $(LATEX_IMAGE)
RUN_LATEX=$(RUN_LATEX_IMAGE) lualatex --interaction batchmode \
	--output-directory=/workdir/$(TARGET) \
	 $(MAINNAME).tex

HORIZONTAL_BACKSIDE_SHIFT=-2.5mm
VERTICAL_BACKSIDE_SHIFT=-2.5mm

NAME=Linus Torvalds
TITLE=Hoofd Kernel Ontwikkeling
PHONE=+31 6123456789
MATRIX=@linus:linux020.net
EMAIL=info@linux020.nl
URL=linux020.nl

default: clean print

.ONESHELL:
vcard.vcf: Makefile
	cat <<EOF > vcard.vcf
	BEGIN:VCARD
	VERSION:4.0
	FN:${NAME}
	ORG:Linux020
	TITLE:${TITLE}
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
	cat <<EOF | sed -e 's/ë/\\"{e}/g' > data.tex
	\newcommand{\NAME}{${NAME}}
	\newcommand{\PHONE}{${PHONE}}
	\newcommand{\MATRIX}{${MATRIX}}
	\newcommand{\EMAIL}{${EMAIL}}
	\newcommand{\TITLE}{${TITLE}}
	\newcommand{\URL}{${URL}}

	\newcommand{\horizontalbacksideshift}{${HORIZONTAL_BACKSIDE_SHIFT}}
	\newcommand{\verticalbacksideshift}{${VERTICAL_BACKSIDE_SHIFT}}
	EOF

install-deps:
	sudo apt-get update 
	sudo apt-get install --yes qrencode

.PHONY:print vcard.vcf vcard-qr.png data.tex
print: data.tex vcard-qr.png
	mkdir -p $(TARGET)
	$(RUN_LATEX)
	mv $(TARGET)/$(MAINNAME).pdf "$(TARGET)/$(NAME).pdf"
	mv $(TARGET)/$(MAINNAME).aux "$(TARGET)/$(NAME).aux"
	mv $(TARGET)/$(MAINNAME).log "$(TARGET)/$(NAME).log"

viewpdf: print
	open "$(TARGET)/$(NAME).pdf"

clean:
	rm -rf $(TARGET)
	-rm vcard.vcf vcard-qr.png data.tex
