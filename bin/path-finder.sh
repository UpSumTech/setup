#!/bin/bash
# Summary: Find the path for executable

fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
source "$( fullSrcDir )/../libexec/utils.sh"

executable="$1"
found=no
arr=( $( splitWord ':' "$PATH" ) )

for dir in "${arr[@]}"; do
  file="$dir/$executable"
  if [[ -e "$file" ]]; then
    found=yes
    break
  fi
done

if [[ $found = yes ]]; then
  echo "$file"
else
  err "$executable could not be found"
fi
