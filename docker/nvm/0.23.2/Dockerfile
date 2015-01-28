FROM sumanmukherjee03/ubuntu:14.04
MAINTAINER Suman Mukherjee <sumanmukherjee03@gmail.com>

RUN apt-get -qq update

RUN git clone https://github.com/creationix/nvm.git /.nvm \
  && cd /.nvm \
  && git checkout `git describe --abbrev=0 --tags`

RUN echo 'source "$HOME/.nvm/nvm.sh"' >> /.bashrc
