#!/bin/bash
# docker container configuration

############ Default Container settings ##############
declare -r -x -A mysqlSettings=( \
  ['containerName']='mysqlServer' \
  ['port']='3306' \
)

declare -r -x -A postgresSettings=( \
  ['containerName']='postgresServer' \
  ['port']='5432' \
)

declare -r -x -A railsSettings=( \
  ['containerName']='railsServer' \
  ['port']='3000' \
)

declare -r -x -A nginxSettings=( \
  ['containerName']='nginxServer' \
  ['port']='80' \
)

declare -r -x -A consulSettings=( \
  ['containerName']='consulAgent' \
  ['port']='8600' \
)
