#!/bin/bash
set -e

main() {
  set -- "$@" \
    "-config-dir=$CONSUL_CONFIG" \
    "-data-dir=$CONSUL_DATA"

  if [[ ! -z "$SERVER" && $SERVER = 'true' ]]; then
    set -- "$@" "-server"
  fi

  if [[ -z "$JOIN_IP" && ! -z "$BOOTSTRAP" ]]; then
    set -- "$@" "-bootstrap-expect=$BOOTSTRAP"
  elif [[ -z "$BOOTSTRAP" && ! -z "$JOIN_IP" ]]; then
    set -- "$@" \
      "-retry-join=$JOIN_IP" \
      "-retry-interval=60s" \
      "-retry-max=10"
  else
    echo >&2 "Error : Neither BOOTSTRAP nor JOIN_IP was provided"
    exit 1
  fi

  if [[ ! -z "$NODE_NAME" ]]; then
    set -- "$@" "-node=$NODE_NAME"
  else
    set -- "$@" "-node=agent1"
  fi

  if [[ ! -z "$EXTERNAL_IP" ]]; then
    set -- "$@" "-advertise=$EXTERNAL_IP"
  fi

  exec "$@"
}

if [ "${1:0:1}" = '-' ]; then
  set -- consul agent "$@"
fi

if [[ "$1" = 'consul' && "$2" = 'agent' ]]; then
  main "$@"
else
  exec "$@"
fi
