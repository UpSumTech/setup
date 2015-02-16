FROM stackbrew/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update \
  && apt-get -qq update

RUN apt-get install -y \
  apt-utils \
  curl \
  wget \
  perl \
  libaio1

RUN apt-get -qq update \
  && apt-get -y install \
    gcc \
    make \
    git-core

RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
  && chmod +x /usr/local/bin/gosu

RUN rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update

RUN chsh -s /bin/bash
RUN echo 'if [[ -f $HOME/.bashrc ]]; then source $HOME/.bashrc; fi' >> /.bash_profile
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh

WORKDIR /
USER root
