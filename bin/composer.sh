#!/bin/sh

function composer_install {
  COMMAND="composer install"
  echo "\xF0\x9F\x8E\xBC     Running composer install. This will build the autoloader including development dependencies. See https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate#composer"
  if eval $COMMAND; then
    echo "Success."
  else
    echo "Failed."
    exit 0
  fi
}