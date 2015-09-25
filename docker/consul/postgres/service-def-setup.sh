#!/bin/bash

main() {
  serviceDefFile="$CONSUL_CONFIG/postgres.json"

  if [[ -f "$serviceDefFile" && ! -z "$EXTERNAL_IP" && ! -z "$SERVICE_ID" ]]; then
    sed -i.bak -e "s#EXTERNAL_IP#${EXTERNAL_IP}#g;s#SERVICE_ID#${SERVICE_ID}#g" "$serviceDefFile"
  fi
}

main "$@"
