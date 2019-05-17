#!/bin/sh

# Gets the version of the site from the composer.json file in the root

source bin/config.sh

function get_version {
  cat ${WP}/composer.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g'
}
