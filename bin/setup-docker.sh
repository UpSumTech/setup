#!/bin/bash
# Summary: Build docker images

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

prepareDockerMachine() {
  require DockerMachineManager
  DockerMachineManager:new dmm1
  $dmm1_validate
  $dmm1_create
  $dmm1_stop
  $dmm1_start
  eval "$(docker-machine env $dmm1_vmName)"
}

runDockerManager() {
  normalizeArgs() {
    local IFS="$1"
    shift
    echo "$*"
  }

  getImageNames() {
    if [[ "$1" =~ 'all' ]]; then
      local allImages=('ubuntu:14.04' \
        'mysql:5.7' \
        'postgres:9.1' \
        'nvm:v0.23.2' \
        'node:v0.10.29' \
        'rbenv:0.4.0' \
        'ruby:1.9.3-p484' \
        'rails:3.2.18' \
        'rails:onbuild' \
        'nginx:1.4.6' \
        'nginx:passenger-nginx' \
        'consul:0.5.0' \
      )
      IFS=,
      echo "${allImages[*]}"
    else
      echo "$1"
    fi
  }

  local imageNames=$( getImageNames "$@" )
  local images=$( normalizeArgs , "$imageNames" )
  if [[ ! -z "$images" ]]; then
    require DockerManager
    DockerManager:new dm1 "$images"
    $dm1_validate
    $dm1_clean
    echo "Cleaned the images..."
    $dm1_build
  fi
}

main() {
  prepareDockerMachine
  runDockerManager "$@"
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
