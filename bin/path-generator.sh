#!/usr/local/bin/bash
# Summary: Generate path for shell

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

require PathManager
PathManager:new pm1
$pm1_addBins
echo $pm1_dirs
