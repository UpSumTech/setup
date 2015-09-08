#!/bin/bash
# docker container configuration

############ Registered images ##############
declare -r -x -A dockerImagesRegistry=( \
  ['mysql']='5.7' \
  ['postgres']='9.1' \
  ['rails']='3.2.18,onbuild' \
  ['node']='v0.10.29,v0.12.7,onbuild' \
  ['nginx']='1.4.6,passenger-nginx' \
  ['dnsmasq']='2.68' \
  ['consul']='0.5.0,onbuild,mysql,postgres,rails,node,nginx,dnsmasq' \
)
