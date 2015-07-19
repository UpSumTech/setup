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

RUN mkdir -p /opt/app/

EXPOSE 3000

# This is a hack
RUN usermod -u 1000 webapp
RUN usermod -G staff webapp

USER webapp

RUN source /.bash_profile && gem install passenger

COPY configuration/database.yml /tmp/database.yml

USER root

RUN mkdir -p /var/run/webapp \
  && chown -R webapp:webapp /var/run/webapp \
  && mkdir -p /var/log/webapp \
  && chown -R webapp:webapp /var/log/webapp

ONBUILD COPY . /opt/app/current

ONBUILD RUN chown -R webapp:webapp /opt/app

ONBUILD USER webapp

ONBUILD WORKDIR /opt/app/current

ONBUILD RUN ls -al /opt/app/current

ONBUILD RUN source /.bash_profile && bundle install

ONBUILD VOLUME ["/opt/app/current"]
