#!/bin/sh

# Syncs local config.yml file with remote
# Usage
# bin/rsync-config.sh <instance>

source config/bin.cfg
source bin/slack-notifications.sh

INSTANCE=$1
COMMAND="rsync -azP config/config.yml ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/mu-plugins/config/"
DOMAIN="https://${INSTANCE}.wpengine.com"

function upload() {
  echo $COMMAND
  post_slack "Uploading config.yml"
  if eval $COMMAND; then
    post_slack_success "Rsync complete"
    echo "Success."
  else
    post_slack_fail "Rsync failed."
    echo "Failed."
    exit 0
  fi
}

IFS='%'
upload
unset IFS

exit 0