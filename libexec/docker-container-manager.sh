#!/bin/bash
# docker container manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DockerContainerManager() {
  require Class
  require NetworkManager
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

    Class:addInstanceMethod $constructor $this 'start' 'DockerContainerManager.start'
    Class:addInstanceMethod $constructor $this 'stop' 'DockerContainerManager.stop'
  }

  DockerContainerManager.validate() {
    local instance="$1"
    local imageName="$( eval "echo \$${instance}_imageName" )"
    local registeredVersions="$( echo "${dockerImagesRegistry["$imageName"]}" )"
    [[ ! -z "$imageName" && ! -z "$registeredVersions" ]] || \
      Class:exception "This image $imageName does not exist"

    local version="$( eval "echo \$${instance}_version" )"
    [[ ! -z "$version" && "$version"=~$registeredVersions ]] || \
      Class:exception "The version $version for image $imageName does not exist in registered versions $registeredVersions"
  }

  _getInstructionsForService() {
    local serviceName="$1"
    local envVars="${@:2}"

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
      dnsmasq)
        settings="dnsmasqSettings"
        ;;
      consul)
        settings="consulSettings"
        ;;
      *)
        echo "Invalid options for container name"
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
    local instructions="$( _getInstructionsForService "$@" )"
    echo ${instructions[@]}
  }

  _runPostgres() {
    set -- "postgres" "$@"
    local instructions=( "$( _getInstructionsForService "$@" )" )
    echo ${instructions[@]}
  }

  _runRails() {
    set -- "rails" "$@"
    local instructions="$( _getInstructionsForService "$@" )"
    instructions+=( \
      "-v" \
      "$HOME/Work/lp-webapp:/usr/src/app" \
    )
    echo ${instructions[@]}
  }

  _runNginx() {
    set -- "nginx" "$@"
    local instructions="$( _getInstructionsForService "$@" )"
    echo ${instructions[@]}
  }

  _runDnsmasq() {
    set -- "dnsmasq" "$@"
    local instructions="$( _getInstructionsForService "$@" )"
    instructions+=( \
      "-v" \
      "/etc/dnsmasq.d:/etc/dnsmasq.d" \
    )
    echo ${instructions[@]}
  }

  _runConsul() {
    set -- "consul" "$@"
    local instructions="$( _getInstructionsForService "$@" )"
    if [[ "$( uname -s )" =~ Linux ]]; then
      NetworkManager:new nm1
      local externalIP="$( eval $nm1_getIP )"
      local bridgeIP="$( eval $nm1_getDockerBridgeIP )"

      instructions+=( \
        "-v" \
        "/mnt:/var/lib/consul" \
      )

      instructions+=( \
        "-p" \
        "$externalIP:8300:8300" \
        "-p" \
        "$externalIP:8301:8301" \
        "-p" \
        "$externalIP:8301:8301/udp" \
        "-p" \
        "$externalIP:8302:8302" \
        "-p" \
        "$externalIP:8302:8302/udp" \
        "-p" \
        "$externalIP:8400:8400" \
        "-p" \
        "$externalIP:8500:8500" \
        "-p" \
        "$bridgeIP:53:53/udp" \
      )
    else
      instructions+=( \
        "-p" \
        "8300:8300" \
        "-p" \
        "8400:8400" \
        "-p" \
        "8500:8500" \
        "-p" \
        "53:53/udp" \
      )
    fi
    echo ${instructions[@]}
  }

  DockerContainerManager.start() {
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

    declare -A ROUTING_TABLE=( \
      ['mysql']='_runMysql' \
      ['postgres']='_runPostgres' \
      ['rails']='_runRails' \
      ['nginx']='_runNginx' \
      ['dnsmasq']='_runDnsmasq' \
      ['consul']='_runConsul' \
    )

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local version="$( eval "echo \$${instance}_version" )"
    local fnName="$( echo "${ROUTING_TABLE["$imageName"]}" )"
    local instructions=( "$( eval "$fnName" "$envVars" )" )

    instructions+=( "$otherOptions" "sumanmukherjee03/$imageName:$version" )

    exec ${instructions[@]}
  }

  DockerContainerManager.stop() {
    local instance="$1"
    local imageName="$( eval "echo \$${instance}_imageName" )"
    declare -n settings

    case "$imageName" in
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
      dnsmasq)
        settings="dnsmasqSettings"
        ;;
      consul)
        settings="consulSettings"
        ;;
      *)
        echo "Invalid options for container name"
        exit 1
    esac

    local containerName="$( echo ${settings["containerName"]} )"
    if [[ ! -z "$( docker ps -a | grep "$containerName" )" ]]; then
      docker stop "$containerName"
      docker rm "$containerName"
    fi
  }

  DockerContainerManager:required() {
    export -f DockerContainerManager:new
  }
  export -f DockerContainerManager:required
}
