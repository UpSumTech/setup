#!/bin/bash
# docker container configuration

############ Registered images ##############
declare -r -x -A dockerImagesRegistry=( \
  ['mysql']='5.7' \
  ['postgres']='9.1' \
  ['rails']='3.2.18,onbuild' \
  ['nginx']='1.4.6,passenger-nginx' \
  ['consul']='0.5.0' \
)
