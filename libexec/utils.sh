#!/bin/bash
# Utility functions that can be sourced in other bash scripts

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

err() {
  echo "Error : $@" >/dev/stderr
  exit 1
}

splitWord() {
  local line="$2"
  local old_IFS="$IFS"
  IFS="$1"
  echo -n ${line}
  IFS="$old_IFS"
}

require() {
  case "$1" in
    Class)
      source "$( fullSrcDir )/class.sh"
      Class
      Class:required
      ;;
    PathManager)
      source "$( fullSrcDir )/path-manager.sh"
      PathManager
      PathManager:required
      ;;
    Boot2DockerManager)
      source "$( fullSrcDir )/boot2docker-manager.sh"
      Boot2DockerManager
      Boot2DockerManager:required
      ;;
    DockerManager)
      source "$( fullSrcDir )/docker-manager.sh"
      DockerManager
      DockerManager:required
      ;;
    *)
      echo -n "Usages: "
      echo "require "{Class\,,PathManager\,,Boot2DockerManager\,,DockerManager\,NetworkManager}
      exit 1
  esac
}
