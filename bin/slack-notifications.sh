#!/bin/sh

# Usage;
# post_slack 'Starting a process people should know about'
# post_slack_success 'It was a success!'
# post_slack_fail 'Opps, failure!'

function post_slack() {
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

function post_slack_success() {
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

function post_slack_fail() {
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