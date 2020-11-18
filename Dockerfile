
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https gnupg
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/' > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    r-base=3.6* \ 
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# Get R commit r79409
RUN svn co -r79409 https://svn.r-project.org/R/trunk/ R
# Building R from source
RUN apt-get update && apt-get install -y r-base-dev texlive-full libcairo2-dev
RUN cd R; ./configure --with-x=no --without-recommended-packages 
RUN cd R; make

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'
RUN apt-get install -y imagemagick
RUN apt-get install -y transfig

# Packages used in the report
# For 'magick'
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:cran/imagemagick
RUN apt-get update
RUN apt-get install -y libmagick++-dev
# For 'pdftools'
RUN add-apt-repository -y ppa:cran/poppler
RUN apt-get update
RUN apt-get install -y libpoppler-cpp-dev
RUN Rscript -e 'library(devtools); install_version("gdiff", "0.2-1", repos="https://cran.rstudio.com/")'
RUN R/bin/Rscript -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'
RUN R/bin/Rscript -e 'library(devtools); install_version("gdiff", "0.2-1", repos="https://cran.rstudio.com/")'

# The main report package(s)



