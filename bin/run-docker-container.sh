#!/bin/bash
# Summary: Run docker container

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

main() {
  require DockerContainerManager
  DockerContainerManager:new dcm1 "$@"
  $dcm1_validate
  $dcm1_run
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
