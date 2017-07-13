#!/bin/sh

# Usage
# Modify configuration file ../deploy.cfg
# Then run `bin/deploy.sh <branch> <env> <optional message>`

source deploy.cfg
BRANCH=$1
ENV=$2
MESSAGE="$3"
COMMAND="git push $ENV $BRANCH:master --force"
DOMAIN="http://${WPENGINE_NAME}.${ENV}.wpengine.com"

function branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function find_wp {
  echo "";
  echo "\xF0\x9F\x94\xAC  Finding application source...";
  if cd $WORDPRESS_DIR ; then
    echo "Found!"
  else
    echo "Couldn't find your application directory, be sure to add it to config.cfg"
    echo "";
    exit 0
  fi
}

function add_remote {
  echo "";
  echo "\xF0\x9F\x94\xAD  Adding remote..."
  if git remote add $ENV git@git.wpengine.com:$ENV/$WPENGINE_NAME.git ; then
    echo "Added"
  else
    echo "It is not that fatal."
  fi
}

function git_push {
  echo "";
  echo "\xF0\x9F\x9A\x80  Git push...";
  if $COMMAND ; then
    post_slack
  else
    echo "Could not push to remote"
    echo "";
    exit 0
  fi
}

function post_slack() {

  MESSAGE="@${SLACK_USER} deploying ${DOMAIN} via \`${COMMAND}\` ${MESSAGE}"
  PAYLOAD="payload={\"text\":\"${MESSAGE}\", \"channel\":\"${SLACK_CHANNEL}\", \"username\":\"${SLACK_USERNAME}\", \"icon_emoji\":\"${SLACK_ICON}\"}"

  echo "";
  echo "${SLACK_ICON_BYTE}  Alerting the team on ${SLACK_CHANNEL}...";
  echo "";
  echo "${SLACK_USERNAME}"
  echo $MESSAGE
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}

}

function success() {

  MESSAGE="Deployment of ${DOMAIN} by @${SLACK_USER} complete via \`${COMMAND}\`"
  PAYLOAD="payload={\"text\":\"${MESSAGE}\", \"channel\":\"${SLACK_CHANNEL}\", \"username\":\"${SLACK_USERNAME}\", \"icon_emoji\":\"${SLACK_ICON}\"}"

  echo "";
  echo "\xF0\x9F\x99\x8C  Deployment of ${DOMAIN} complete."
  echo "";

}

IFS='%'
find_wp
add_remote
git_push
success
unset IFS

exit 0