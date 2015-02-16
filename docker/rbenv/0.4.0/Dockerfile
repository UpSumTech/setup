FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

RUN apt-get install -y \
  autoconf \
  bison \
  build-essential \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm3 \
  libgdbm-dev

RUN groupadd -r webapp \
  && useradd -d /home/webapp -s /bin/bash -m -r -g webapp webapp

USER webapp
WORKDIR $HOME
RUN echo "" > $HOME/.bashrc

RUN git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv \
  && cd $HOME/.rbenv \
  && git fetch \
  && git checkout v0.4.0

RUN git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build \
  && git clone https://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash

RUN echo 'export RBENV_ROOT="$HOME/.rbenv"' >> $HOME/.bashrc
RUN echo 'export PATH="$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc

WORKDIR /
USER root
