#!/bin/sh

# Syncs remote uploads with local uploads
# Usage
# bin/get-uploads.sh <instance>

source config/wp.cfg

INSTANCE=$1
COMMAND="rsync -azP ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/uploads ${WP}wp-content/"

function download() {
  echo $COMMAND
  if eval $COMMAND; then
    echo "Success."
  else
    echo "Failed."
    exit 0
  fi
}

IFS='%'
download
unset IFS

exit 0