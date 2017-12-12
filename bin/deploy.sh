#!/bin/sh

# Usage
# Modify configuration file ../deploy.cfg
# Then run `bin/deploy.sh -i <instance> -b <branch> -e <env> -m <optional message> -f true`
# @required -i instance - the wpengine instance and git remote alias.
# @required -b branch   - the branch to deploy from.
# @optional -e env      - staging or production(default), the instance environment.
# @optional -m message  - an optional message to post to slack.
# @optional -f force    - use git push --force.
# bin/deploy.sh growingupdev sprint-4-develop production

source deploy.cfg
source wp.cfg

while getopts ":i:b:e:m:f:" option; do
  case "${option}" in
    i)
      i=${OPTARG}
      ;;
    b)
      b=${OPTARG}
      ;;
    e)
      e=${OPTARG}
      ;;
    m)
      m=${OPTARG}
      ;;
    f)
      f=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

if [ "$i" = "" ]; then
  echo "-i (instance) is required"
  exit 0
fi

if [ "$b" = "" ]; then
  echo "-b (branch) is required"
  exit 0
fi

INSTANCE=$i
BRANCH=$b
MESSAGE=$m

# Configure environment
if [ "$e" = "" ]; then
  ENV="production"
else
  ENV="$e"
  if [ "$ENV" != "staging" ]; then
    echo "-e (environment) must be staging or production. Defaults to production."
    exit 0
  fi
fi

# If force is needed
if [ "$f" = true ] ; then
  FORCE="--force"
  FORCE_BOOL="true"
else
  FORCE=""
  FORCE_BOOL="false"
fi

# Configure the command
COMMAND="git push $INSTANCE $BRANCH:master $FORCE"

# Configure the URL
if [ ENV = "staging" ] ; then
  DOMAIN="https://${INSTANCE}.${ENV}.wpengine.com"
else
  DOMAIN="https://${INSTANCE}.wpengine.com"
fi


###/
# Functions
##/
function branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function commit_message {
  git log -1 --pretty=%B
}

function commit_hash_short {
  git rev-parse --verify --short HEAD
}

function commit_hash_full {
  git rev-parse --verify HEAD
}

function find_wp {
  printf "\xF0\x9F\x94\xAC     Finding application source... ";
  if cd $WP ; then
    echo "Found!"
  else
    echo "Couldn't find your application directory, be sure to add it to config.cfg"
    exit 0
  fi
}

function add_remote {
  printf "\xF0\x9F\x94\xAD     Adding remote... "
  if git remote add $INSTANCE git@git.wpengine.com:$ENV/$INSTANCE.git 2> /dev/null; then
    echo "Added!"
    test_ssh
  else
    echo "Already present."
  fi
}

function test_ssh {
  printf "\xF0\x9F\x94\x91     Preview permissions... "
  echo "If you don't see $ENV/$INSTANCE below, you need to add your public key
        to the WP Engine portal my.wpengine.com/installs/$INSTANCE/git_push"
  echo "This will be skipped in the future."
  ssh git@git.wpengine.com info
}

function git_push {
  echo "\xF0\x9F\x9A\x80     ${COMMAND}... ";
  if eval $COMMAND; then
    echo "Success."
    success
  else
    echo "Failed."
    fail
    exit 0
  fi
}

function post_slack() {
  COMMIT="$(commit_message)"
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(commit_hash_full)|$(commit_hash_short)>\`"
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"text\": \"Deployment in progress\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_PINK}\",
        \"pretext\": \"${MESSAGE}\",
        \"author_name\": \"${SLACK_USER}\",
        \"title\": \"${DOMAIN}\",
        \"title_link\": \"${DOMAIN}\",
        \"text\": \"${COMMIT_URL} ${COMMIT}\",
        \"fields\": [
          {
            \"title\": \"Instance\",
            \"value\": \"${INSTANCE}\"
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
            \"value\": \"${FORCE_BOOL}\"
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
  MESSAGE="Deployment complete"
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(commit_hash_full)|$(commit_hash_short)>\`"
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_BLUE}\",
        \"text\": \"${COMMIT_URL} ${MESSAGE}\"
      }
    ]
  }"

  # printf "\xF0\x9F\x99\x8C Success!"
  # echo ""
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}

function fail() {
  MESSAGE="Deployment failed, could not push to remote."
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(commit_hash_full)|$(commit_hash_short)>\`"
  PAYLOAD="payload={
    \"channel\": \"${SLACK_CHANNEL}\",
    \"username\": \"${SLACK_USERNAME}\",
    \"icon_emoji\": \"${SLACK_ICON}\",
    \"attachments\": [
      {
        \"mrkdwn_in\": [\"text\", \"pretext\"],
        \"color\": \"${COLOR_RED}\",
        \"text\": \"${COMMIT_URL} ${MESSAGE}\"
      }
    ]
  }"

  # printf "\xF0\x9F\x93\x89     Failed!"
  # echo $MESSAGE
  curl -X POST --data-urlencode ${PAYLOAD} ${SLACK_INCOMMING_WEBHOOK}
  echo ""
}


###/
# Init
##/
IFS='%'
find_wp
add_remote
post_slack
git_push
unset IFS

exit 0