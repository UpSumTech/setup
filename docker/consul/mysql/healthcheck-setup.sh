#!/bin/bash

set -e

main() {
  apt-get -qq update
  apt-get install -y --no-install-recommends \
    mysql-client \
    libmysqlclient-dev
}

main "$@"
