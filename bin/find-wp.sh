#!/bin/sh

source config/bin.cfg

function find_wp {
  printf "\xF0\x9F\x94\xAC     Finding application source... ";
  if cd $WP ; then
    echo "Found!"
  else
    echo "Couldn't find your application directory, be sure to add it to config/wp.cfg"
    exit 0
  fi
}