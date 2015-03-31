#!/bin/bash
# Network Manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

NetworkManager() {
  require Class

  _networkManagerConstructor=$FUNCNAME

  NetworkManager:new() {
    local this="$1"
    local constructor=$_networkManagerConstructor

    Class:addInstanceMethod $constructor $this 'getIP' 'NetworkManager.getIP'
    Class:addInstanceMethod $constructor $this 'getDockerBridgeIP' 'NetworkManager.getDockerBridgeIP'
  }

  NetworkManager.getIP() {
    # local instance="$1"
    local IP;
    if [[ "$( uname -s )" =~ Linux ]]; then
      IP="$( ifconfig | \
        grep -B1 "inet addr" | \
        awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' | \
        awk -F: '{ print $1 ":" $3 }' | \
        grep 'eth1' | \
        cut -d ':' -f2
      )"
    else
      IP="127.0.0.1"
    fi
    echo "$IP"
  }

  NetworkManager.getDockerBridgeIP() {
    # local instance="$1"
    local bridgeIP
    if [[ "$( uname -s )" =~ Linux ]]; then
      bridgeIP="$(ip route | awk '/docker0/{print $9}')"
    else
      bridgeIP=""
    fi
    echo "$bridgeIP"
  }

  NetworkManager:required() {
    export -f NetworkManager:new
  }
  export -f NetworkManager:required
}
