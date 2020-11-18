
TARFILE = ../r-clipping-deposit-$(shell date +'%Y-%m-%d').tar.gz

# Run processing from more recent R because 'gdiff' code
# needs to be run from R session that looks for .workRSOCK then
# falls back to .slaveRSOCK
# (if run in R <= 4.0.2, will only look for .slaveRSOCK, which does not
#  exist in more recent R)

# Desktop
# Rscript = Rscript+

# Docker
Rscript = /R/bin/Rscript

all:
	make docker

%.xml: %.cml %.bib
	# Protect HTML special chars in R code chunks
	$(Rscript) -e 't <- readLines("$*.cml"); writeLines(gsub("str>", "strong>", gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[", gsub("</rcode>", "]]></rcode>", t))), "$*.xml")'
	$(Rscript) toc.R $*.xml
	$(Rscript) bib.R $*.xml

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml

docker:
	# Ensure docker images are up to date
	sudo docker build -f Dockerfile -t pmur002/r-clipping-report .
	sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(shell pwd):$(shell pwd) -w $(shell pwd) --rm pmur002/r-clipping-report make r-clipping.html

web:
	make docker
	cp -r ../r-clipping-report/* ~/Web/Reports/GraphicsEngine/r-clipping/

zip:
	make docker
	tar zcvf $(TARFILE) ./*
