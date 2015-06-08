#!/bin/bash

set -e

main() {
  local cmd=( \
    "mysqladmin" \
    "-u" \
    "$MYSQLSERVER_ENV_USER" \
    "-p$MYSQLSERVER_ENV_PASSWD" \
    "-h" \
    "$MYSQLSERVER_PORT_3306_TCP_ADDR" \
    "status" \
  )
  exec ${cmd[@]}
}

main
