FROM stackbrew/ubuntu:14.04

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update \
  && apt-get -qq update

RUN apt-get -y install apt-utils

RUN apt-get install -y curl \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
  && chmod +x /usr/local/bin/gosu

RUN apt-get -qq update
