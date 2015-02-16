FROM sumanmukherjee03/nvm:v0.23.2
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

USER webapp
WORKDIR $HOME

RUN source /.bash_profile && nvm install 0.10.29 \
  && nvm alias default v0.10.29 \
  && npm install -g gulp

WORKDIR /
USER root
