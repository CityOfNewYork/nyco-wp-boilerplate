#!/bin/sh

# Usage
# Modify configuration file ../deploy.cfg
# Then run `bin/deploy.sh <branch> <env> <optional message>`

source deploy.cfg
BRANCH=$1
ENV=$2
MESSAGE="$3"
COMMAND="git push $ENV $BRANCH:master --force"
DOMAIN="https://${WPENGINE_NAME}.${ENV}.wpengine.com"

function branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function commit {
  git log -1 --pretty=%B
}

function find_wp {
  printf "\xF0\x9F\x94\xAC     Finding application source... ";
  if cd $WORDPRESS_DIR ; then
    echo "Found!"
  else
    echo "Couldn't find your application directory, be sure to add it to config.cfg"
    exit 0
  fi
}

function add_remote {
  printf "\xF0\x9F\x94\xAD     Adding remote... "
  if git remote add $ENV git@git.wpengine.com:$ENV/$WPENGINE_NAME.git 2> /dev/null; then
    echo "Added!"
    test_ssh
  else
    echo "Already present."
  fi
}

function test_ssh {
  printf "\xF0\x9F\x94\x91     Preview permissions... "
  echo "If you don't see $ENV/$WPENGINE_NAME below, you need to add your public key to the WP Engine portal my.wpengine.com/installs/accessnyc/git_push"
  echo "This will be skipped in the future."
  ssh git@git.wpengine.com info
}

function git_push {
  echo "\xF0\x9F\x9A\x80     Git push... ";
  post_slack
  if eval $COMMAND; then
    echo ""
    success
  else
    echo "Could not push to remote."
    exit 0
  fi
}

function post_slack() {

  # MESSAGE="@${SLACK_USER} deploying ${DOMAIN} via \`${COMMAND}\`"
  COMMIT="$(commit)"

  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"text\": \"Deployment in progress\",
      \"attachments\": [
        {
          \"color\": \"${SLACK_COLOR}\",
          \"pretext\": \"${MESSAGE}\",
          \"author_name\": \"${SLACK_USER}\",
          \"title\": \"${DOMAIN}\",
          \"title_link\": \"${DOMAIN}\",
          \"text\": \"${COMMIT}\",
          \"fields\": [
            {
              \"title\": \"Instance\",
              \"value\": \"${WPENGINE_NAME}\"
            },
            {
              \"title\": \"Environment\",
              \"value\": \"${ENV}\"
            },
            {
              \"title\": \"Branch\",
              \"value\": \"${BRANCH}\"
            },
            {
              \"title\": \"Force\",
              \"value\": \"true\"
            }
          ]
        }
      ]
  }"

  printf "${SLACK_ICON_BYTE}     Alerting the team on ${SLACK_CHANNEL}... ";
  echo $MESSAGE
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}

}

function success() {

  MESSAGE="Deployment of complete"
  PAYLOAD="payload={\"text\":\"${MESSAGE}\", \"channel\":\"${SLACK_CHANNEL}\", \"username\":\"${SLACK_USERNAME}\", \"icon_emoji\":\"${SLACK_ICON}\"}"

  printf "\xF0\x9F\x99\x8C     Success! "
  echo $MESSAGE
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""

}

# function run_tests() {
#   # test.sh
# }

IFS='%'
find_wp
add_remote
git_push
unset IFS

exit 0