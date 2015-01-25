#!/bin/bash
set -e

err() {
  echo >&2 "Error : $@"
  exit 1
}

validate() {
  [[ ! -z "$PASSWD" ]] || die "PASSWD was not provided"
}

main() {
  local configFile="$PGCONFIG/postgresql.conf"
  validate
  gosu postgres initdb -D "$PGDATA" -E 'UTF-8'
  local cmd="gosu postgres postgres --single -jE --config-file=$configFile"
  $cmd <<< "CREATE USER root WITH SUPERUSER;" > /dev/null
  $cmd <<< "ALTER USER root WITH PASSWORD '$PASSWD';" > /dev/null
  $cmd <<< "CREATE DATABASE root;" > /dev/null
  gosu postgres postgres --config-file="$configFile" -D "$PGDATA"
}

main
