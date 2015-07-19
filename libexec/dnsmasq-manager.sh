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

  DnsmasqManager:new() {
    local this="$1"
    local constructor=$_dnsmasqManagerConstructor
    Class:addInstanceProperty $constructor $this 'hostsFile' '/etc/dnsmasq.hosts'
    Class:addInstanceMethod $constructor $this 'prepare' 'DnsmasqManager.prepare'
    Class:addInstanceMethod $constructor $this 'register' 'DnsmasqManager.register'
    Class:addInstanceMethod $constructor $this 'registerAll' 'DnsmasqManager.registerAll'
  }

  DnsmasqManager.prepare() {
    local instance="$1"
    local hostsFile="$( eval "echo \$${instance}_hostsFile" )"
    NetworkManager:new dnsMasqNetManager1
    local bridgeIP="$( eval $dnsMasqNetManager1_getDockerBridgeIP )"

    echo -n '' > "$hostsFile"

    # echo "listen-address=$bridgeIP" >> "$extraConfFile"
    # echo "listen-address=127.0.0.1" >> "$extraConfFile"
  }

  DnsmasqManager.register() {
    local instance="$1"
    local hostsFile="$( eval "echo \$${instance}_hostsFile" )"
    local serviceName="$2"
    local containerName
    local containerAddress

    case "$serviceName" in
      mysqldb)
        containerName="mysqldb"
        containerAddress="172.20.20.14"
        ;;
      postgresdb)
        containerName="postgresdb"
        containerAddress="172.20.20.15"
        ;;
      railsapp)
        containerName="railsapp"
        containerAddress="172.20.20.17"
        ;;
      nodeapp)
        containerName="nodeapp"
        containerAddress="172.20.20.18"
        ;;
      *)
        echo "Invalid options for service name"
        exit 1
    esac

    echo "${containerAddress} ${containerName}.dev" >> "$hostsFile"
  }

  DnsmasqManager.registerAll() {
    local instance="$1"
    local serviceName
    local serviceNames=( "mysqldb" "postgresdb" "railsapp" "nodeapp" )
    for serviceName in ${serviceNames[@]}; do
      DnsmasqManager.register "$instance" "$serviceName"
    done
  }

  DnsmasqManager:required() {
    export -f DnsmasqManager:new
  }
  export -f DnsmasqManager:required
}
