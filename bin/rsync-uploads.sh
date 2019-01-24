#!/bin/sh

# Syncs remote uploads with local uploads
# Usage
# bin/rsync-uploads.sh <instance> -u
# or
# bin/rsync-uploads.sh <instance> -u
# @required -u or -d upload or download - Wether to sync local with remote or vise versa.

SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$(dirname "$SCRIPT_PATH")

source $BASE_PATH/config/wp.cfg
# source $BASE_PATH/config/deploy.cfg
source $SCRIPT_PATH/slack-notifications.sh

INSTANCE=$1
SYNC=$2
COMMAND_UPLOAD="rsync -azP ${WP}wp-content/uploads ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/"
COMMAND_DOWNLOAD="rsync -azP ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/uploads ${WP}wp-content/"

function download() {
  echo $COMMAND_DOWNLOAD
  if eval $COMMAND_DOWNLOAD; then
    echo "Success."
    post_slack_success "Successfully downloaded from ${INSTANCE}"
  else
    echo "Failed."
    post_slack_fail "Failed to download from ${INSTANCE}"
    exit 0
  fi
}

function upload() {
  echo $COMMAND_UPLOAD
  if eval $COMMAND_UPLOAD; then
    echo "Success."
    post_slack_success "Successfully uploaded to ${INSTANCE}"
  else
    echo "Failed."
    post_slack_fail "Failed to upload to ${INSTANCE}"
    exit 0
  fi
}

IFS='%'
if [ "${SYNC}" == "-u" ]; then
  post_slack "Syncing remote uploads with local"
  upload
elif [ "${SYNC}" == "-d" ]; then
  post_slack "Syncing local uploads with remote"
  download
fi
unset IFS

exit 0