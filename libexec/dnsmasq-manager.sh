#!/bin/bash
# dnsmasq manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DnsmasqManager() {
  require Class
  require NetworkManager

  _dnsmasqManagerConstructor=$FUNCNAME

  DNSMASQ_CONF_DIR="/etc/dnsmasq.d"

  DnsmasqManager:new() {
    local this="$1"
    local constructor=$_dnsmasqManagerConstructor
    Class:addInstanceProperty $constructor $this 'hostsFile' "$DNSMASQ_CONF_DIR/dockerhosts.conf"
    Class:addInstanceProperty $constructor $this 'extraConfFile' "$DNSMASQ_CONF_DIR/extraConfFile.conf"
    Class:addInstanceMethod $constructor $this 'prepare' 'DnsmasqManager.prepare'
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

  DnsmasqManager.prepare() {
    local instance="$1"
    local hostsFile="$( eval "echo \$${instance}_hostsFile" )"
    local extraConfFile="$( eval "echo \$${instance}_extraConfFile" )"
    NetworkManager:new dnsMasqNetManager1
    local bridgeIP="$( eval $dnsMasqNetManager1_getDockerBridgeIP )"

    [[ -d "$DNSMASQ_CONF_DIR" ]] || mkdir -p "$DNSMASQ_CONF_DIR"
    echo -n '' > "$hostsFile"
    echo -n '' > "$extraConfFile"

    # echo "bind-interfaces" >> "$extraConfFile"
    # echo "listen-address=$bridgeIP" >> "$extraConfFile"
    # echo "listen-address=127.0.0.1" >> "$extraConfFile"
  }

  DnsmasqManager.register() {
    local instance="$1"
    local hostsFile="$( eval "echo \$${instance}_hostsFile" )"
    local containerName
    local containerAddress

    for container in $( docker ps -q ); do
      containerName="$( _getContainerName $container )"
      containerAddress="$( _getContainerAddress $container )"
      echo "address=/${containerName}.dev/${containerAddress}" >> "$hostsFile"
    done
  }

  DnsmasqManager:required() {
    export -f DnsmasqManager:new
  }
  export -f DnsmasqManager:required
}
