#!/bin/bash
# Summary: Build docker images

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

prepareBoot2Docker() {
  require Boot2DockerManager
  Boot2DockerManager:new b2d1
  $b2d1_validate
  export DOCKER_HOST="$( $b2d1_dockerHost )"
  export DOCKER_CERT_PATH="$( $b2d1_dockerCert )"
  export DOCKER_TLS_VERIFY="$( $b2d1_dockerTls )"
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
        'nvm:0.23.2' \
        'node:v0.10.29' \
        'rbenv:0.4.0' \
        'ruby:1.9.3-p484' \
        'rails:3.2.18' \
        'rails:onbuild' \
        'nginx:1.4.6' \
        'nginx:passenger-nginx' \
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
    echo "$images"
    DockerManager:new dm1 "$images"
    $dm1_validate
    $dm1_clean
    $dm1_build
  fi
}

main() {
  [[ "$( uname -s )" =~ Darwin ]] \
    && prepareBoot2Docker
  runDockerManager "$@"
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
