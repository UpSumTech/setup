#!/bin/bash
# Summary: Start consul and register services

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

main() {
  if [[ "$( uname -s )" =~ Darwin ]];then
    require ConsulManager
    ConsulManager:new cm

    $cm_register "rails"
    $cm_start
  fi
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
