#!/bin/bash
# boot2docker manager

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

validate() {
  if [[ -z $( command -v boot2docker ) ]]; then
    err "Please install boot2docker"
  else
    boot2docker restart
  fi
}

extractDockerIp() {
  [[ "$( boot2docker ip )" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]] &>/dev/null \
    && echo ${BASH_REMATCH[@]}
}

extractDockerPort() {
  boot2docker info \
    | sed -e 's#{##g;s#}##g' \
    | while read -r -d ',' chunk; do
        if [[ "$chunk" =~ DockerPort ]]; then
          echo "$chunk"
        fi
      done \
    | cut -d ':' -f2
}

extractDockerHost() {
  echo "$( extractDockerIp ):$( extractDockerPort )"
}

exportDockerHost() {
  export DOCKER_HOST=tcp://"$( extractDockerHost )"
}

main() {
  if [[ "$( uname -s )" =~ Darwin ]]; then
    echo "OS: Mac"
    validate && exportDockerHost
  else
    echo "OS: Linux"
  fi
}
