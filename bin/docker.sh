#!/bin/sh

function docker_compose_build {
  COMMAND="docker-compose build"
  echo "\xF0\x9F\x90\xB3     Building docker containers using docker-compose.yml. "
  if eval $COMMAND; then
    echo "Success."
  else
    echo "Failed."
    exit 0
  fi
}

function docker_compose_up {
  COMMAND="docker-compose up"
  echo "\xF0\x9F\x9A\xA2     Starting docker-compose.yml containers. Use CTRL+C to stop. "
  eval $COMMAND;
}