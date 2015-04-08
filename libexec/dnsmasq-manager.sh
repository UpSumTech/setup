#!/bin/bash
# dnsmasq manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DnsmasqManager() {
  require Class
  _dnsmasqManagerConstructor=$FUNCNAME

  DNSMASQ_CONF_DIR="/etc/dnsmasq.d"

  DnsmasqManager:new() {
    local this="$1"
    local constructor=$_dnsmasqManagerConstructor
    Class:addInstanceProperty $constructor $this 'hostsFile' "$DNSMASQ_CONF_DIR/dockerhosts"
    Class:addInstanceMethod $constructor $this 'register' 'DnsmasqManager.register'
  }

  _getContainerName() {
    local container="$1"
    docker inspect -f "{{.Name}}" $container | sed -e 's#/##'
  }

  _getContainerAddress() {
    local container="$1"
    docker inspect -f "{{.NetworkSettings.IPAddress}}" "$container"
  }

  DnsmasqManager.register() {
    local instance="$1"
    local file="$( eval "echo \$${instance}_hostsFile" )"
    local containerName
    local containerAddress

    [[ -d "$DNSMASQ_CONF_DIR" ]] || mkdir -p "$DNSMASQ_CONF_DIR"
    echo -n '' > "$file"

    for container in $( docker ps -q ); do
      containerName="$( _getContainerName $container )"
      containerAddress="$( _getContainerAddress $container )"
      echo "address=/${containerName}.dev/${containerAddress}" >> "$file"
    done
  }

  DnsmasqManager:required() {
    export -f DnsmasqManager:new
  }
  export -f DnsmasqManager:required
}
