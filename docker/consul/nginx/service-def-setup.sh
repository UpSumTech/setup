#!/bin/bash

main() {
  serviceDefFile="$CONSUL_CONFIG/nginx.json"

  if [[ -f "$serviceDefFile" && ! -z "$EXTERNAL_IP" && ! -z "$EXTERNAL_PORT" && ! -z "$SERVICE_ID" ]]; then
    sed -i.bak -e "s#EXTERNAL_IP#${EXTERNAL_IP}#g;s#EXTERNAL_PORT#${EXTERNAL_PORT}#g;s#SERVICE_ID#${SERVICE_ID}#g" "$serviceDefFile"
  fi
}

main "$@"
