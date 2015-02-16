fullSrcDir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

source "$( fullSrcDir )/../libexec/utils.sh"

prepareBoot2Docker() {
  require Boot2DockerManager
  Boot2DockerManager:new b2d1
  $b2d1_validate
  export DOCKER_HOST="$( $b2d1_dockerHost )"
  export DOCKER_CERT_PATH="$( $b2d1_dockerCert )"
  export DOCKER_TLS_VERIFY="$( $b2d1_dockerTls )"
}

main() {
  docker rmi $(docker images | grep "^<none>" | awk '{print $3}') &> /dev/null
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
