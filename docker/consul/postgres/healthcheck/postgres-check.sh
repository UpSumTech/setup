#!/bin/bash

set -e

main() {
  echo "$POSTGRESSERVER_PORT_5432_TCP_ADDR:5432:*:$POSTGRESSERVER_ENV_USER:$POSTGRESSERVER_ENV_PASSWD" > "$HOME/.pgpass"
  chmod 0600 "$HOME/.pgpass"
  local cmd=( \
    "psql" \
    "-h" \
    "$POSTGRESSERVER_PORT_5432_TCP_ADDR" \
    "-U" \
    "$POSTGRESSERVER_ENV_USER" \
    "-p" \
    "5432" \
    "-l" \
  )
  exec ${cmd[@]}
}

main
