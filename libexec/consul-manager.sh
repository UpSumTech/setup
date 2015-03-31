#!/bin/bash
# consul manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

ConsulManager() {
  require Class
  _consulManagerConstructor=$FUNCNAME

  CONSUL_DIR=$HOME/etc/consul.d

  ConsulManager:new() {
    local this="$1"
    local constructor=$_consulManagerConstructor
    Class:addInstanceMethod $constructor $this 'validate' 'ConsulManager.validate'
    Class:addInstanceMethod $constructor $this 'register' 'ConsulManager.register'
  }

  ConsulManager.register() {
    local instance="$1"
    local serviceName="$2"

    declare -A REGISTERED_SERVICES
    REGISTERED_SERVICES=( \
      ['rails']='{"service": {"name": "rails", "tags": ["onbuild"], "port": 3000}}' \
    )

    local serviceConfig="$( echo "${REGISTERED_SERVICES["$serviceName"]}" )"

    if [[ ! -z "$serviceConfig" ]]; then
      echo $serviceConfig > $CONSUL_DIR/$serviceName.json
    else
      Class:exception "Service name provided does not exist in the register"
    fi
  }

  ConsulManager.validate() {
    local instance="$1"

    if [[ -z $( command -v consul ) ]]; then
      Class:exception "Please install consul"
    else
      while read -r line; do
        local nodeName="$( echo "$line" | sed -e 's#[{##;s#}]##' | cut -d ',' -f1 | cut -d ':' -f2 )"
        if [[ -z "$nodeName" ]]; then
          Class.exception "Consul agent is not running in the datacenter"
        fi
      done <<< $(curl --silent "localhost:8500/v1/catalog/nodes")
    fi
  }

  ConsulManager:required() {
    export -f ConsulManager:new
  }
  export -f ConsulManager:required
}
