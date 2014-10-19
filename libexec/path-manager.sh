#!/bin/bash
# PathManager

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/utils.sh"

PathManager() {
  require Class
  _pathManagerConstructor=$FUNCNAME

  PathManager:new() {
    local this=$1
    local constructor=$_pathManagerConstructor
    Class:addInstanceProperty $constructor $this 'dirs'
    Class:addInstanceMethod $constructor $this 'addBin' 'PathManager.addBin'
    Class:addInstanceMethod $constructor $this 'addBins' 'PathManager.addBins'
  }

  PathManager.addBin() {
    local instance=$1
    local prop="${instance}_dirs"
    local propVal="$( eval "echo \$${prop}" )"
    local val="$2"
    if [[ -d "${val}" ]]; then
      if [[ -z "${propVal}" ]]; then
        export ${prop}="$val"
      else
        export ${prop}="${val}:${propVal}"
      fi
    fi
  }

  PathManager.addBins() {
    local instance=$1
    local paths=( '/sbin' '/bin' '/usr/sbin' '/usr/bin' '/usr/local/sbin' '/usr/local/bin' "${HOME}/.rbenv/shims" "${HOME}/.jenv/shims" "${HOME}/bin" "${HOME}/.bin" )
    local path
    for path in "${paths[@]}"; do
      PathManager.addBin $instance $path
    done
  }

  PathManager:required() {
    export -f PathManager:new
  }
  export -f PathManager:required
}
