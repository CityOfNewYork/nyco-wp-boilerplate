#!/bin/sh

# Syncs local config.yml file with remote
# Usage
# bin/rsync-config.sh <instance>

source config/slack.cfg 
source config/colors.cfg

INSTANCE=$1
COMMAND="rsync -azP config/config.yml ${INSTANCE}@${INSTANCE}.ssh.wpengine.net:sites/${INSTANCE}/wp-content/mu-plugins/config/"
DOMAIN="https://${INSTANCE}.wpengine.com"

function post_slack() {
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"text\": \"Uploading config.yml\",
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

function success() {
  MESSAGE="Rsync complete"
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_BLUE}\",
        \"text\": \"${MESSAGE}\"
      }
    ]
  }"

  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function fail() {
  MESSAGE="Rsync failed."
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_RED}\",
        \"text\": \"${MESSAGE}\"
      }
    ]
  }"

  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function upload() {
  echo $COMMAND
  post_slack
  if eval $COMMAND; then
    success
    echo "Success."
  else
    fail
    echo "Failed."
    exit 0
  fi
}

IFS='%'
upload
unset IFS

exit 0