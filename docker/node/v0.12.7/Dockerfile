FROM sumanmukherjee03/nvm:v0.23.2
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update \
  && apt-get install -y \
    python \
    g++

USER webapp
WORKDIR $HOME

RUN source /.bash_profile && nvm install 0.12.7 \
  && nvm alias default v0.12.7

RUN source /.bash_profile \
  && npm install -g npm@3.1.2

RUN source /.bash_profile \
  && npm install -g coffee-script \
  && npm install -g gulp \
  && npm install -g grunt \
  && npm install -g jshint

WORKDIR /
USER root
