#!/bin/bash
# Summary: Bootstrapping and provisioning hosts

ANSIBLE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )/ansible"

main() {
  local option

  while getopts 'l:b' option; do
    local bootstrap;

    case $option in
      b)
        bootstrap=1
        ;;
      l)
        local hostList=${OPTARG}
        local hostName

        if [[ ! -z $bootstrap ]]; then
          for hostName in "${hostList[@]}"; do
            ansible-playbook -c paramiko -i "$ANSIBLE_DIR/hosts" -l "$hostName" "$ANSIBLE_DIR/bootstrap.yml" --ask-pass --sudo
          done
        fi

        echo "${hostList[@]}" \
          | xargs -n 1 -I hostName \
            ansible-playbook -i "$ANSIBLE_DIR/hosts" -l hostName "$ANSIBLE_DIR/main.yml" --become-user=developer

        ;;
      *)
        if [[ ! -z $bootstrap ]]; then
          ansible-playbook -c paramiko -i "$ANSIBLE_DIR/hosts" "$ANSIBLE_DIR/bootstrap.yml" --ask-pass --sudo
        fi
        ansible-playbook -i "$ANSIBLE_DIR/hosts" "$ANSIBLE_DIR/main.yml" --become-user=developer
    esac
  done
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
