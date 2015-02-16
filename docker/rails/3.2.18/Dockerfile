FROM sumanmukherjee03/ruby:1.9.3-p484
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

USER webapp

RUN source /.bash_profile && gem install rails --version 3.2.18

USER root
