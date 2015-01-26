#!/bin/bash
# boot2docker manager

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

Boot2DockerManager() {
  require Class
  _boot2DockerConstructor=$FUNCNAME

  Boot2DockerManager:new() {
    local this="$1"
    local constructor=$_boot2DockerConstructor
    Class:addInstanceMethod $constructor $this 'validate' 'Boot2DockerManager.validate'
    Class:addInstanceMethod $constructor $this 'dockerHost' 'Boot2DockerManager.dockerHost'
  }

  Boot2DockerManager.validate() {
    local instance="$1"
    if [[ -z $( command -v boot2docker ) ]]; then
      Class:exception "Please install boot2docker"
    else
      boot2docker restart
    fi
  }

  _extractDockerIp() {
    [[ "$( boot2docker ip )" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]] &>/dev/null \
      && echo ${BASH_REMATCH[@]}
  }

  _extractDockerPort() {
    boot2docker info | sed -e 's#{##g;s#}##g' | while read -r -d ',' chunk; do
      if [[ "$chunk" =~ DockerPort ]]; then
        echo "$chunk"
      fi
    done | cut -d ':' -f2
  }

  _extractDockerHost() {
    echo "$( _extractDockerIp ):$( _extractDockerPort )"
  }

  Boot2DockerManager.dockerHost() {
    local instance=$1
    echo "tcp://$( _extractDockerHost )"
  }

  Boot2DockerManager:required() {
    export -f Boot2DockerManager:new
  }
  export -f Boot2DockerManager:required
}
