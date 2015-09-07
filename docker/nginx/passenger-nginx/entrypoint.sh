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
  local serviceName="$1"

  declare -A railsSettings=( \
    ['ip']='railsapp.dev' \
    ['port']='3000' \
  )

  declare -n settings

  local vhostFile

  if [[ -d /usr/src/vhost_templates ]]; then
    for f in /usr/src/vhost_templates/*.template; do
      if [[ -f "$f" ]]; then
        case "$serviceName" in
          rails)
            settings="railsSettings"
            vhostFile="/etc/nginx/vhosts/rails.conf"
            cp "$f" "$vhostFile"
            sed -i.bak -e "s#RAILS_SERVER_IP#${railsSettings['ip']}#g;s#RAILS_SERVER_PORT#${railsSettings['port']}#g" "$vhostFile"
            ;;
          *)
            echo "Invalid options for service name"
            exit 1
        esac
      fi
    done
  fi
}

main() {
  validate
  prepareConfFile "$SERVICE"
  exec "$@"
}

if [ "${1:0:1}" = '-' ]; then
  set -- nginx "$@"
fi

if [[ "$1" = 'nginx' ]]; then
  main "$@"
else
  exec "$@"
fi
