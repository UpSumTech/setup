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
      ['rails']='3.2.18,onbuild' \
      ['nginx']='1.4.6,passenger-nginx' \
    )

    [[ ! -z "$( eval "echo \$${instance}_dockerHostIP" )" ]] || \
      Class:exception "Docker host IP could not be found"

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local registeredVersions="$( echo "${REGISTERED_IMAGES["$imageName"]}" )"
    [[ ! -z "$imageName" && ! -z "$registeredVersions" ]] || \
      Class:exception "This image $imageName does not exist"

    local version="$( eval "echo \$${instance}_version" )"
    [[ ! -z "$version" && "$version"=~$registeredVersions ]] || \
      Class:exception "The version $version for image $imageName does not exist in registered versions $registeredVersions"
  }

  _runService() {
    local serviceName="$1"
    local envVars="${@:2}"

    declare -A mysqlSettings=( \
      ['containerName']='mysqlServer' \
      ['port']='3306' \
    )

    declare -A postgresSettings=( \
      ['containerName']='postgresServer' \
      ['port']='5432' \
    )

    declare -A railsSettings=( \
      ['containerName']='railsServer' \
      ['port']='3000' \
    )

    declare -A nginxSettings=( \
      ['containerName']='nginxServer' \
      ['port']='80' \
    )

    declare -n settings

    case "$serviceName" in
      mysql)
        settings="mysqlSettings"
        ;;
      postgres)
        settings="postgresSettings"
        ;;
      rails)
        settings="railsSettings"
        ;;
      nginx)
        settings="nginxSettings"
        ;;
      *)
        echo -n "Valid options: "
        echo "mysql, postgres, rails, nginx"
        exit 1
    esac

    local containerName="$( echo ${settings["containerName"]} )"
    local port="$( echo ${settings["port"]} )"

    local instructions=( \
      "docker" \
      "run" \
      "--name" \
      "$containerName" \
      "-d" \
      "-p" \
      "$port:$port" \
    )

    local envVar
    for envVar in ${envVars[@]}; do
      instructions+=( '-e' "$envVar" )
    done

    echo "${instructions[@]}"
  }

  _runMysql() {
    set -- "mysql" "$@"
    local instructions="$( _runService "$@" )"
    echo ${instructions[@]}
  }

  _runPostgres() {
    set -- "postgres" "$@"
    local instructions=( "$( _runService "$@" )" )
    echo ${instructions[@]}
  }

  _runRails() {
    set -- "rails" "$@"
    local instructions="$( _runService "$@" )"
    instructions+=( \
      "-v" \
      "/Users/suman/Work/lp-webapp:/usr/src/app" \
    )
    echo ${instructions[@]}
  }

  _runNginx() {
    set -- "nginx" "$@"
    local instructions="$( _runService "$@" )"
    echo ${instructions[@]}
  }

  DockerContainerManager.run() {
    local instance="$1"
    set -- "${@:2}"

    local indexOfEnvVars=$( echo "$( searchArray "-e" "$@" )" | bc )
    local envVars=""
    local otherOptions=""

    if [[ $indexOfEnvVars -gt 0 ]]; then
      envVars="${@:(($indexOfEnvVars+1))}"
      if [[ $indexOfEnvVars -gt 1 ]]; then
        otherOptions="${@:1:(($indexOfEnvVars-1))}"
      fi
    fi

    declare -A ROUTING_TABLE

    ROUTING_TABLE=( \
      ['mysql']='_runMysql' \
      ['postgres']='_runPostgres' \
      ['rails']='_runRails' \
      ['nginx']='_runNginx' \
    )

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local version="$( eval "echo \$${instance}_version" )"
    local fnName="$( echo "${ROUTING_TABLE["$imageName"]}" )"
    local instructions=( "$( eval "$fnName" "$envVars" )" )

    instructions+=( "$otherOptions" "sumanmukherjee03/$imageName:$version" )

    exec ${instructions[@]}
  }

  DockerContainerManager:required() {
    export -f DockerContainerManager:new
  }
  export -f DockerContainerManager:required
}
