#!/bin/bash
# docker-machine manager

set -e

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

DockerMachineManager() {
  require Class
  _dockerMachineManagerConstructor=$FUNCNAME

  _dockerMachineVM="docker-vm"
  _dockerMachineProvider="virtualbox"

  DockerMachineManager:new() {
    local this="$1"
    local constructor=$_dockerMachineManagerConstructor
    Class:addInstanceMethod $constructor $this 'validate' 'DockerMachineManager.validate'
    Class:addInstanceMethod $constructor $this 'create' 'DockerMachineManager.create'
    Class:addInstanceMethod $constructor $this 'start' 'DockerMachineManager.start'
    Class:addInstanceMethod $constructor $this 'stop' 'DockerMachineManager.stop'
    Class:addInstanceMethod $constructor $this 'vmName' 'DockerMachineManager.vmName'
  }

  DockerMachineManager.validate() {
    [[ ! -z $( command -v docker-machine ) ]] \
      || Class:exception "Please install docker-machine"
  }

  DockerMachineManager.create() {
    local dockerMachineStatusExitCode="$( docker-machine status "$_dockerMachineVM" >/dev/null 2>&1; echo $?)"
    if [[ "$dockerMachineStatusExitCode" -eq 1 ]]; then
      docker-machine create --driver="$_dockerMachineProvider" "$_dockerMachineVM"
      echo "Creating docker-machine..."; sleep 2
    fi
  }

  DockerMachineManager.start() {
    local dockerMachineStatus="$( docker-machine status "$_dockerMachineVM" )"
    [[ "$dockerMachineStatus" =~ Stopped ]] \
      && docker-machine start "$_dockerMachineVM" >/dev/null 2>&1
    echo "Starting docker-machine..."; sleep 2
  }

  DockerMachineManager.stop() {
    local dockerMachineStatus="$( docker-machine status "$_dockerMachineVM" )"
    [[ "$dockerMachineStatus" =~ Running ]] \
      && docker-machine stop "$_dockerMachineVM" >/dev/null 2>&1
    echo "Stopping docker-machine..."; sleep 2
  }

  DockerMachineManager.vmName() {
    echo "$_dockerMachineVM"
  }

  DockerMachineManager:required() {
    export -f DockerMachineManager:new
  }
  export -f DockerMachineManager:required
}
