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
    local this="$1"
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
    local instance="$1"
    [[ ! -z $( command -v docker ) ]] || \
      Class:exception "Please install docker"
    [[ "$( eval "echo \$${instance}_imageNames" )" =~ ^[a-zA-Z0-9_\.:,-]+$ ]] || \
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
    local instance="$1"
    if [[ ! -z $( _getAllContainers ) ]]; then
      _stop && _remove
    fi
  }

  _getDockerHubLogin() {
    local dockerLoginFile="$( fullSrcDir )/../docker/.docker_login_mapping"
    if [[ ! -f "$dockerLoginFile" ]]; then
      Class:exception "Docker login mapping missing"
    else
      local line
      local login
      while read -r line; do
        if [[ "$line" =~ $( whoami ):[a-zA-Z0-9_]+ ]]; then
          login="$( echo "$line" | cut -d : -f2 )"
        fi
      done < "$dockerLoginFile"
      if [[ -z "$login" ]]; then
        Class:exception "Login not found for $( whoami )"
      else
        echo "$login"
      fi
    fi
  }

  DockerManager.build() {
    local instance="$1"
    local imageNameWithTag
    local imageName
    local tagName
    local name
    local dockerDir
    local nonExistingDirs=()
    local login="$( _getDockerHubLogin )"
    while read -r -d ',' imageNameWithTag; do
      if [[ "$imageNameWithTag" =~ [a-zA-Z0-9_\.-]+:[a-zA-Z0-9_\.-]+ ]]; then
        imageName="$( echo ${BASH_REMATCH[@]} | cut -d : -f1 )"
        tagName="$( echo ${BASH_REMATCH[@]} | cut -d : -f2 )"
        dockerDir="$( fullSrcDir )/../docker/$imageName/$tagName"
      else
        imageName="$imageNameWithTag"
        tagName=""
        dockerDir="$( fullSrcDir )/../docker/$imageName"
      fi

      name="$login/$imageNameWithTag"

      if [[ -d "$dockerDir" ]]; then
        docker build -t="$name" "$dockerDir"
        docker push "$name"
      else
        nonExistingDirs+=( "$dockerDir" )
      fi
    done <<< "$( eval "echo \$${instance}_imageNames" )"

    [[ ${#nonExistingDirs[@]} -gt 0 ]] && \
      Class:exception "$( echo ${nonExistingDirs[*]} ) do not exist"
  }

  DockerManager:required() {
    export -f DockerManager:new
  }
  export -f DockerManager:required
}
