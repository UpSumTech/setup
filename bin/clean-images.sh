fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

source "$( fullSrcDir )/../libexec/utils.sh"

prepareDockerMachine() {
  require DockerMachineManager
  DockerMachineManager:new dmm1
  $dmm1_validate
  $dmm1_create
  $dmm1_stop
  $dmm1_start
  eval "$(docker-machine env $dmm1_vmName)"
}

main() {
  prepareDockerMachine
  docker rmi $(docker images | grep "^<none>" | awk '{print $3}') &> /dev/null
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
