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

RUN git clone https://github.com/sstephenson/rbenv.git /.rbenv \
  && git clone https://github.com/sstephenson/ruby-build.git /.rbenv/plugins/ruby-build \
  && git clone https://github.com/sstephenson/rbenv-gem-rehash.git /.rbenv/plugins/rbenv-gem-rehash

RUN cd $HOME/.rbenv \
  && git fetch \
  && git checkout v0.4.0

ENV PATH /.rbenv/bin:$PATH

RUN echo 'eval "$(rbenv init -)"' >> /.bashrc
