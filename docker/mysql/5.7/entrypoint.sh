#!/bin/bash
set -e

err() {
  echo >&2 "Error : $@"
  exit 1
}

validate() {
  [[ ! -z "$PASSWD" ]] || err "PASSWD was not provided"
}

prepareDbScript() {
  local file="$1"
  if [[ -d /initdb.d ]]; then
    for f in /initdb.d/*.sh; do
      if [[ -f "$f" ]]; then
        $( /bin/bash "$f" "$file" "$PASSWD" )
      fi
    done
  fi
}

cleanup() {
  while [ ! -f /var/run/mysqld/mysqld.sock ]; do
    sleep 1
  done
  local file="$1"
  rm "$file"
}

main() {
  local tmpFile='/tmp/initdb.sql'
  touch "$tmpFile"
  validate
  gosu mysql mysql_install_db --datadir="$MYSQLDATA"
  prepareDbScript "$tmpFile"
  set -- "$@" --datadir="$MYSQLDATA" --init-file="$tmpFile"
  exec gosu mysql "$@"
  # cleanup "$tmpFile"
}

if [ "${1:0:1}" = '-' ]; then
  set -- mysqld "$@"
fi

if [[ "$1" = 'mysqld' ]]; then
  main "$@"
else
  exec "$@"
fi
