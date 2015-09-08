#!/bin/bash
# docker container manager

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
    if [[ ! -z "$version" && ! "$version"=~app ]]; then
      [[ "$version"=~$registeredVersions ]] || \
        Class:exception "The version $version for image $imageName does not exist in registered versions $registeredVersions"
    fi
  }

  _getInstructionsForService() {
    local serviceName="$1"

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
      node)
        settings="nodeSettings"
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
    )

    if [[ ! -z "$port" ]]; then
      instructions+=( \
        "-p" \
        "$port" \
      )
    fi

    echo "${instructions[@]}"
  }

  _runMysql() {
    local instructions="$( _getInstructionsForService "mysql" )"
    echo ${instructions[@]}
  }

  _runPostgres() {
    local instructions=( "$( _getInstructionsForService "postgres" )" )
    echo ${instructions[@]}
  }

  _runRails() {
    local instructions="$( _getInstructionsForService "rails" )"
    if [[ "$( uname -s )" =~ Linux ]]; then
      instructions+=( \
        "-v" \
        "/opt/app/current:/opt/app/current" \
      )
    fi
    echo ${instructions[@]}
  }

  _runNode() {
    local instructions="$( _getInstructionsForService "node" )"
    if [[ "$( uname -s )" =~ Linux ]]; then
      instructions+=( \
        "-v" \
        "/opt/app/current:/opt/app/current" \
      )
    fi
    echo ${instructions[@]}
  }

  _runNginx() {
    local instructions="$( _getInstructionsForService "nginx" )"
    echo ${instructions[@]}
  }

  _runDnsmasq() {
    local instructions="$( _getInstructionsForService "dnsmasq" )"

    instructions+=( \
      "-v" \
      "/etc/dnsmasq.hosts:/etc/dnsmasq.hosts" \
    )

    if [[ "$( uname -s )" =~ Linux ]]; then
      instructions+=( \
        "-p" \
        "$(getContainerPortMapping "53" "53/udp" "external")" \
      )
    else
      instructions+=( \
        "-p" \
        "$(getContainerPortMapping "53" "53/udp" "local")" \
      )
    fi

    echo ${instructions[@]}
  }

  _runConsul() {
    local instructions="$( _getInstructionsForService "consul" )"
    local hostType

    if [[ "$( uname -s )" =~ Linux ]]; then
      instructions+=( \
        "-v" \
        "/mnt:/var/lib/consul" \
        "-p" \
        "$(getContainerPortMapping "8600" "53/udp" "external")" \
      )
      hostType="external"
    else
      instructions+=( \
        "-p" \
        "$(getContainerPortMapping "8600" "53/udp" "local")" \
      )
      hostType="local"
    fi

    instructions+=( \
      "-p" \
      "$(getContainerPortMapping "8300" "8300" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8301" "8301" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8301" "8301/udp" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8302" "8302" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8302" "8302/udp" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8400" "8400" "$hostType")" \
      "-p" \
      "$(getContainerPortMapping "8500" "8500" "$hostType")" \
    )

    echo ${instructions[@]}
  }

  DockerContainerManager.start() {
    local instance="$1"
    local option
    local args=()

    declare -A ROUTING_TABLE=( \
      ['mysql']='_runMysql' \
      ['postgres']='_runPostgres' \
      ['rails']='_runRails' \
      ['node']='_runNode' \
      ['nginx']='_runNginx' \
      ['dnsmasq']='_runDnsmasq' \
      ['consul']='_runConsul' \
    )

    local imageName="$( eval "echo \$${instance}_imageName" )"
    local version="$( eval "echo \$${instance}_version" )"

    set -- "${@:2}"

    while getopts “h:e:v:p:l:-:” option; do
      case $option in
        h)
          args+=( "-h $OPTARG" )
          ;;
        e)
          args+=( "-e $OPTARG" )
          ;;
        v)
          args+=( "-v $OPTARG" )
          ;;
        p)
          args+=( "-p $OPTARG" )
          ;;
        -)
          if [[ "${OPTARG}" =~ .*=.* ]]; then
            option=${OPTARG/=*/}
            OPTARG=${OPTARG#*=}
            case $option in
              dns)
                args+=( "--dns=$OPTARG" )
                ;;
              *)
                Class:exception "The options were not valid for starting a docker container"
            esac
            ((OPTIND--))
          else
            option="$OPTARG"
            OPTARG=(${@:OPTIND:1})
            case $option in
              dns)
                args+=( "--dns $OPTARG" )
                ;;
              link)
                args+=( "--link $OPTARG" )
                ;;
              *)
                Class:exception "The options were not valid for starting a docker container"
            esac
          fi
          ((OPTIND+=1))
          continue
          ;;
        *)
          Class:exception "The options were not valid for starting a docker container"
      esac
    done

    local fnName="$( echo "${ROUTING_TABLE["$imageName"]}" )"
    local instructions=( "$( eval "$fnName" )" )

    instructions+=( "${args[@]}" "sumanmukherjee03/$imageName:$version" )

    echo "Command being being executed -----"
    echo "${instructions[@]}"

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
      node)
        settings="nodeSettings"
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
