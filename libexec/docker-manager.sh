#!/bin/bash
# Docker manager

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "/Users/suman/Code/setup/libexec/utils.sh"

validate() {
  if [[ -z $( command -v docker ) ]]; then
    err "Please install docker"
  fi
}

getAllContainers() {
  docker ps -a -q
}

stop() {
  docker stop $( getAllContainers )
}

remove() {
  docker rm $( getAllContainers  )
}

clean() {
  if [[ ! -z $( getAllContainers ) ]]; then
    stop && remove
  fi
}

build() {
  local imageName="$1"
  local dockerFile="$( fullSrcDir )/../docker/$1"
  echo "$imageName"
  echo "$dockerFile"
  if [[ -f "$dockerFile" ]]; then
    docker build -t "$imageName" "$dockerFile"
  else
    err "$dockerFile does not exist"
  fi
}

main() {
  validate \
    && clean \
    && build rails
}
