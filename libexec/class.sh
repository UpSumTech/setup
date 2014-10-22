#!/bin/bash
# Summary: Class

Class() {
  declare -A colors=( ['red']='\e[0;31m' ['none']='\e[0m' )

  Class:exception() {
    echo -e "${colors["red"]} Error : $@${colors["none"]}" >/dev/stderr
    exit 1
  }

  Class:addInstanceProperty() {
    local constructor=$1
    local instance=$2
    local property="$3"
    local value="$4"
    if [[ -z "$value" ]];then
      export ${instance}_${property}
    else
      export ${instance}_${property}="$value"
    fi
  }

  Class:addInstanceMethod() {
    local constructor=$1
    local instance=$2
    local name=$3
    local fnName="$4"
    if [[ $fnName =~ $constructor ]]; then
      export ${instance}_${name}="${fnName} ${instance}"
    else
      Class:exception 'You are trying to add instance methods to an invalid constructor!'
    fi
  }

  Class:required() {
    export -f Class:addInstanceProperty
    export -f Class:addInstanceMethod
    export -f Class:exception
  }
  export -f Class:required
}
