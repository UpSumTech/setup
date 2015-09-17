#!/bin/bash
# Summary: Run docker container

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"
source "$( fullSrcDir )/../config/docker-images-config.sh"
source "$( fullSrcDir )/../config/docker-container-config.sh"

usage() {
  echo "
  usage: $0 imageName:imageTag [OPTIONS]

  This script runs docker containers.

  OPTIONS:
  -h      Docker container's host name. Specified as -h blah
  -e      Docker container's env var. Specified as -e FOO=bar
  -v      Docker container's volume being shared with the Docker host. Specified as /opt/foo:/opt/bar
  -p      Docker container's port being exposed  Specified as -p 5432:7878
  --link  Docker container's linked together. Specified as --link foo:bar
  --dns   Docker container's dns servers. Specified as --dns=[172.20.20.10]
  "
}

main() {
  require DockerContainerManager
  DockerContainerManager:new dcm1 "${@:1:1}"
  set -- "${@:2}"
  $dcm1_validate
  $dcm1_stop
  trap '[ "$?" -eq 0 ] || usage' EXIT
  $dcm1_start "$@"
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
