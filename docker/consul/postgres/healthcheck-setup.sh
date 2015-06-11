#!/bin/bash

set -e

main() {
  apt-get -qq update
  apt-get install -y --no-install-recommends \
    postgresql-client \
    libpq-dev
}

main "$@"
