#!/bin/bash
set -e

err() {
  echo >&2 "Error : $@"
  exit 1
}

validate() {
  [[ ! -z "$SERVICE" ]] || err "SERVICE was not provided"
}

prepareConfFile() {
  declare -A railsSettings=( \
    ['containerName']='railsServer' \
    ['port']='3000' \
  )

  declare -n settings

  if [[ -d /usr/src/vhost_templates ]]; then
    for f in /usr/src/vhost_templates/*.template; do
      if [[ -f "$f" ]]; then
        case "$SERVICE" in
          rails)
            settings="railsSettings"
            ;;
          *)

      fi
    done
  fi
}

main() {
  prepareConfFile
  exec gosu mysql "$@"
}

if [ "${1:0:1}" = '-' ]; then
  set -- nginx "$@"
fi

if [[ "$1" = 'nginx' ]]; then
  main "$@"
else
  exec "$@"
fi
