#!/bin/bash
# docker container manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DockerContainerManager() {
  require Class
  require Boot2DockerManager

  _dockerContainerConstructor=$FUNCNAME

  DockerContainerManager:new() {
    local this="$1"
    local constructor=$_dockerContainerConstructor

    Class:addInstanceMethod $constructor $this 'validate' 'DockerContainerManager.validate'

    _extractImageNames() {
      local str="$1"
      IFS=:
      echo ${str[@]}
    }
    local splitArg="$( _extractImageNames "$2" )"
    local splitArgArray=( $(echo ${splitArg[*]}) )
    Class:addInstanceProperty $constructor $this 'imageName' "$( echo ${splitArgArray[0]} )"
    Class:addInstanceProperty $constructor $this 'version' "$( echo ${splitArgArray[1]} )"

    Class:addInstanceProperty $constructor $this 'dockerHostIP' "$( _getDockerHostIP "$2" )"

    Class:addInstanceMethod $constructor $this 'run' 'DockerContainerManager.run'
  }

  _getDockerHostIP() {
    if [[ "$( uname -s )" =~ Darwin ]]; then
      Boot2DockerManager:new b2d1 "$1"
      $b2d1_validate
      export DOCKER_HOST="$( $b2d1_dockerHost )"
      export DOCKER_CERT_PATH="$( $b2d1_dockerCert )"
      export DOCKER_TLS_VERIFY="$( $b2d1_dockerTls )"
      echo "$b2d1_dockerHostIP"
    else
      echo "127.0.0.1" # temp value
    fi
  }

  DockerContainerManager.validate() {
    local instance="$1"

    declare -A REGISTERED_IMAGES
    REGISTERED_IMAGES=( \
      ['mysql']='5.7' \
      ['postgres']='9.1' \
      ['nvm']='v0.23.2' \
      ['node']='v0.10.29' \
      ['rbenv']='0.4.0' \
      ['ruby']='1.9.3-p484' \
      ['rails']='3.2.18,onbuild' \
      ['nginx']='1.4.6,passenger-nginx' \
    )

    [[ ! -z "$( eval "echo \$${instance}_dockerHostIP" )" ]] || \
      Class:exception "Docker host IP could not be found"

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local registeredVersions="$( echo "${REGISTERED_IMAGES['mysql']}" )"
    [[ ! -z "$imageName" && ! -z "$registeredVersions" ]] || \
      Class:exception "This image does not exist"

    local version="$( eval "echo \$${instance}_version" )"
    [[ ! -z "$version" && "$version" =~ $registeredVersions ]] || \
      Class:exception "This version for the image does not exist"
  }

  _runMysql() {
    echo "sumanmukherjee03/mysql:$1"
  }

  _runPostgres() {
    echo "sumanmukherjee03/postgres:$1"
  }

  _runNvm() {
    echo "sumanmukherjee03/nvm:$1"
  }

  _runNode() {
    echo "sumanmukherjee03/node:$1"
  }

  _runRbenv() {
    echo "sumanmukherjee03/rbenv:$1"
  }

  _runRuby() {
    echo "sumanmukherjee03/ruby:$1"
  }

  _runRails() {
    echo "sumanmukherjee03/rails:$1"
  }

  _runNginx() {
    echo "sumanmukherjee03/nginx:$1"
  }

  DockerContainerManager.run() {
    local instance="$1"

    declare -A ROUTING_TABLE
    ROUTING_TABLE=( \
      ['mysql']='_runMysql' \
      ['postgres']='_runPostgres' \
      ['nvm']='_runNvm' \
      ['node']='_runNode' \
      ['rbenv']='_runRbenv' \
      ['ruby']='_runRuby' \
      ['rails']='_runRails' \
      ['nginx']='_runNginx' \
    )

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local version="$( eval "echo \$${instance}_version" )"
    local fnName="$( echo "${ROUTING_TABLE["$imageName"]}" )"
    $( eval "echo $fnName $version" )
  }

  DockerContainerManager:required() {
    export -f DockerContainerManager:new
  }
  export -f DockerContainerManager:required
}
