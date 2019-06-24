#!/bin/sh

SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$(dirname "$SCRIPT_PATH")

source $SCRIPT_PATH/config.sh
source $SCRIPT_PATH/find-wp.sh
source $SCRIPT_PATH/composer.sh
source $SCRIPT_PATH/docker.sh

function git_clone() {
  COMMAND="git clone $GITHUB_URL $WP"
  echo "\xF0\x9F\x8E\xBC     Cloning $GITHUB_URL to $WP. "
  if eval $COMMAND; then
    echo "Success."
  else
    echo "Failed."
    exit 0
  fi
}

IFS='%'
find_wp
composer_install
eval "cd ../"
docker_compose_build
docker_compose_up
unset IFS

exit 0