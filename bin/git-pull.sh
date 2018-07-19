#!/bin/sh

# Pulls remote instance into local branch.
# This can be used to update the local or source repository with WP updates on
# the remote WP Engine Instances.
# Usage
# bin/pull.sh <instance>

source config/wp.cfg

INSTANCE=$1
COMMAND="git pull ${INSTANCE} master"

function find_wp {
  printf "\xF0\x9F\x94\xAC     Finding application source... ";
  if cd $WP ; then
    echo "Found!"
  else
    echo "Couldn't find your application directory, be sure to add it to config.cfg."
    exit 0
  fi
}

function git_pull {
  echo "\xF0\x9F\x9A\x80     ${COMMAND}... ";
  if eval $COMMAND; then
    echo "Success."
  else
    echo "Failed."
    exit 0
  fi
}

IFS='%'
find_wp
git_pull
unset IFS

exit 0