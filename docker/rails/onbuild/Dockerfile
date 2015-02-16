FROM sumanmukherjee03/ruby:1.9.3-p484
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update \
  && apt-get install -y --no-install-recommends \
    sqlite3 \
    libsqlite3-dev \
    mysql-client \
    libmysqlclient-dev \
    postgresql-client \
    libpq-dev

RUN apt-get -qq update \
  && apt-get install -y --no-install-recommends nodejs

RUN apt-get -qq update \
  && apt-get install -y \
    libpng12-dev \
    libglib2.0-dev \
    zlib1g-dev \
    libbz2-dev \
    libtiff4-dev \
    libjpeg8-dev \
    ghostscript \
    imagemagick

RUN ldconfig /usr/local/lib

USER webapp
RUN source /.bash_profile && gem install passenger
RUN mkdir $HOME/apps

USER root

EXPOSE 3000
