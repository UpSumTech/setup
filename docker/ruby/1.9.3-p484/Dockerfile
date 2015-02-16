FROM sumanmukherjee03/rbenv:0.4.0
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

USER webapp
WORKDIR $HOME

RUN echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc
RUN source /.bash_profile && rbenv install 1.9.3-p484
RUN source /.bash_profile && rbenv global 1.9.3-p484
RUN source /.bash_profile && gem install bundler

WORKDIR /
USER root
