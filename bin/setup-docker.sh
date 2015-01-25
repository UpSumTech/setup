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
}

runDockerManager() {
  function normalizeArgs() {
    local IFS="$1"
    shift
    echo "$*"
  }

  local images=$( normalizeArgs , "$@" )
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
