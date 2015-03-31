#!/bin/bash
# Summary: Run docker container

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"
source "$( fullSrcDir )/../config/docker-images-config.sh"
source "$( fullSrcDir )/../config/docker-container-config.sh"

main() {
  require DockerContainerManager
  DockerContainerManager:new dcm1 "${@:1:1}"
  set -- "${@:2}"
  $dcm1_validate
  $dcm1_stop
  $dcm1_start "$@"
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
