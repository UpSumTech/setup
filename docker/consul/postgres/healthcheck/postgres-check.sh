#!/bin/bash

set -e

main() {
  echo "$POSTGRESSERVER_PORT_5432_TCP_ADDR:5432:*:$POSTGRESSERVER_ENV_USER:$POSTGRESSERVER_ENV_PASSWD" > "/.pgpass"
  export PGPASSFILE="/.pgpass"
  local cmd=( \
    "psql" \
    "-c" \
    "'SHOW DATABASES;'" \
  )
  exec ${cmd[@]}
}

main
