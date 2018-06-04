#!/bin/sh

# Syncs remote uploads with local uploads
# Usage
# bin/get-uploads.sh <instance> -u
# or
# bin/get-uploads.sh <instance> -u
# @required -u or -d upload or download - Wether to sync local with remote or vise versa.

source config/wp.cfg
source config/deploy.cfg

INSTANCE=$1
SYNC=$2
COMMAND_UPLOAD="rsync -azP ${WP}wp-content/uploads ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/"
COMMAND_DOWNLOAD="rsync -azP ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/uploads ${WP}wp-content/"

function post_slack {
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"text\": \"${1}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_PINK}\",
        \"author_name\": \"${SLACK_USER}\",
        \"title\": \"${DOMAIN}\",
        \"title_link\": \"${DOMAIN}\",
        \"fields\": [
          {
            \"title\": \"Instance\",
            \"value\": \"${INSTANCE}\"
          }
        ]
      }
    ]
  }"

  printf "${SLACK_ICON_BYTE}     Alerting the team on ${SLACK_CHANNEL}... ";
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function success {
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_BLUE}\",
        \"text\": \"${1}\"
      }
    ]
  }"

  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function fail {
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_RED}\",
        \"text\": \"${1}\"
      }
    ]
  }"

  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function download() {
  echo $COMMAND_DOWNLOAD
  if eval $COMMAND_DOWNLOAD; then
    echo "Success."
    success "Successfully downloaded from ${INSTANCE}"
  else
    echo "Failed."
    fail "Failed to download from ${INSTANCE}"
    exit 0
  fi
}

function upload() {
  echo $COMMAND_UPLOAD
  if eval $COMMAND_UPLOAD; then
    echo "Success."
    success "Successfully uploaded to ${INSTANCE}"
  else
    echo "Failed."
    fail "Failed to upload to ${INSTANCE}"
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