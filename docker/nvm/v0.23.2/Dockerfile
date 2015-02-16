FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

RUN groupadd -r webapp \
  && useradd -d /home/webapp -s /bin/bash -m -r -g webapp webapp

USER webapp
WORKDIR $HOME
RUN echo "" > $HOME/.bashrc

RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm \
  && cd $HOME/.nvm \
  && git checkout v0.23.2

RUN echo 'source "$HOME/.nvm/nvm.sh"' >> $HOME/.bashrc

WORKDIR /
USER root
