#!/bin/bash
# Docker manager

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DockerManager() {
  require Class
  _dockerManagerConstructor=$FUNCNAME

  DockerManager:new() {
    local this=$1
    local constructor=$_dockerManagerConstructor
    Class:addInstanceMethod $constructor $this 'validate' 'DockerManager.validate'
    Class:addInstanceMethod $constructor $this 'clean' 'DockerManager.clean'
    Class:addInstanceMethod $constructor $this 'build' 'DockerManager.build'
    Class:addInstanceProperty $constructor $this imageNames "$( _sanitizeImageNames "$2" )"
  }

  _sanitizeImageNames() {
    if [[ "$1" =~ ^[a-zA-Z0-9_,]+\,$ ]]; then
      echo ${BASH_REMATCH[@]}
    else
      echo "$1",
    fi
  }

  DockerManager.validate() {
    local instance=$1
    [[ ! -z $( command -v docker ) ]] || \
      Class:exception "Please install docker"
    [[ "$( eval "echo \$${instance}_imageNames" )" =~ ^[a-zA-Z0-9_,]+$ ]] || \
      Class:exception "Please install docker"
  }

  _getAllContainers() {
    docker ps -a -q
  }

  _stop() {
    docker stop $( _getAllContainers )
  }

  _remove() {
    docker rm $( _getAllContainers  )
  }

  DockerManager.clean() {
    local instance=$1
    if [[ ! -z $( _getAllContainers ) ]]; then
      _stop && _remove
    fi
  }

  DockerManager.build() {
    local instance=$1
    local imageName
    local dockerFile
    local nonExistingFiles=()
    while read -r -d ',' imageName; do
      dockerFile="$( fullSrcDir )/../docker/$imageName"
      echo "$dockerFile"
      if [[ -f "$dockerFile" ]]; then
        docker build -t "$imageName" "$dockerFile"
      else
        nonExistingFiles+=( "$dockerFile" )
      fi
    done <<< "$( eval "echo \$${instance}_imageNames" )"
    Class:exception "$( echo ${nonExistingFiles[*]} ) do not exist"
  }

  DockerManager:required() {
    export -f DockerManager:new
  }
  export -f DockerManager:required
}
