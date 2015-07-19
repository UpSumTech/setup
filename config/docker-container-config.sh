#!/bin/bash
# docker container configuration

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

############ Default Container settings ##############

declare -r -x -A mysqlSettings=( \
  ['containerName']='mysqlServer' \
  ['port']="$(getContainerPortMapping "3306" "3306" "external")" \
)

declare -r -x -A postgresSettings=( \
  ['containerName']='postgresServer' \
  ['port']="$(getContainerPortMapping "5432" "5432" "external")" \
)

declare -r -x -A railsSettings=( \
  ['containerName']='railsServer' \
  ['port']="$(getContainerPortMapping "3000" "3000" "external")" \
)

declare -r -x -A nodeSettings=( \
  ['containerName']='nodeServer' \
  ['port']="$(getContainerPortMapping "8989" "8989" "external")" \
)

declare -r -x -A nginxSettings=( \
  ['containerName']='nginxServer' \
  ['port']="$(getContainerPortMapping "80" "80" "external")" \
)

declare -r -x -A dnsmasqSettings=( \
  ['containerName']='dnsmasqServer' \
  ['port']="$(getContainerPortMapping "53" "53/udp" "bridge")" \
)

declare -r -x -A consulSettings=( \
  ['containerName']='consulAgent' \
  ['port']="$(getContainerPortMapping "8600" "8600" "local")" \
)
