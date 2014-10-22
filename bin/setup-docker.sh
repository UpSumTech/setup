#!/bin/bash
# Summary: Build docker images

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

if [[ "$( uname -s )" =~ Darwin ]]; then
  require Boot2DockerManager
  Boot2DockerManager:new b2d1
  $b2d1_validate
  export DOCKER_HOST="$( $b2d1_dockerHost )"
fi

require DockerManager
DockerManager:new dm1 'rails,postgres'
$dm1_validate
$dm1_clean
$dm1_build
