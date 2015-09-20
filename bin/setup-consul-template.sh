#!/bin/bash
# Summary: Setup consul-template on docker host

if [[ ! -f /usr/local/bin/consul-template ]]; then
  apt-get install -y golang
  apt-get install -y gccgo-go
  apt-get install -y bison

  which gvm &>/dev/null || \
    curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash

  source ~/.gvm/scripts/gvm

  [[ ! -d /usr/local/go ]] && mkdir -p /usr/local/go
  export GOPATH=/usr/local/go
  export PATH="$PATH:${GOPATH//://bin:}/bin"

  gvm list | grep go1.3 || gvm install go1.3

  gvm use go1.3

  cd /usr/local
  if [[ ! -d /usr/local/consul-template ]]; then
    git clone https://github.com/hashicorp/consul-template.git
    cd consul-template
    make
    ln -s /usr/local/consul-template/bin/consul-template /usr/local/bin/
  fi
fi
