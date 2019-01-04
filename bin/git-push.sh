#!/bin/sh

# Usage
# Run `bin/deploy.sh -i <instance> -b <branch> -e <env> -m <optional message> -f true`
# @required -i instance - the wpengine instance and git remote alias.
# @optional -b branch   - if the branch is different from env/$INSTANCE, this must be specified
# @optional -e env      - staging or production(default), the instance environment.
# @optional -m message  - an optional message to post to slack.
# @optional -f force    - use git push --force.
# bin/deploy.sh growingupdev sprint-4-develop production
####
# To run individually from the main deploy.sh, use the following
# bin/git-push.sh -i growingupdev -b sprint-4-develop - e production

SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$(dirname "$SCRIPT_PATH")

source "${SCRIPT_PATH}/config.sh"
source "${SCRIPT_PATH}/find_wp.sh"
source "${SCRIPT_PATH}/slack-notifications.sh"

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

# Configure the URL
if [ ENV = "staging" ] ; then
  DOMAIN="https://${INSTANCE}.${ENV}.wpengine.com"
else
  DOMAIN="https://${INSTANCE}.wpengine.com"
fi

###/
# Functions
##/
function env_branch {
  printf "\xF0\x9F\x94\xAD     Checking branch... "
  if [[ "$b" != "" ]]; then
    BRANCH=$b
  elif [[ "$(git_str_branch)" == "env/$INSTANCE" ]]; then
    echo "None specified. Deploying from env/$INSTANCE.";
    BRANCH="env/$INSTANCE"
  else
    echo "Incorrect branch. Check out env/$INSTANCE or specify the branch to deploy from.";
    exit 0;
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
  COMMAND="git push $INSTANCE $BRANCH:master $FORCE"
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

function post_slack_with_attachments() {
  COMMIT="$(git_str_commit_message)"
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(git_str_commit_hash_full)|$(git_str_commit_hash_short)>\`"

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
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(git_str_commit_hash_full)|$(git_str_commit_hash_short)>\`"

  post_slack_success "${COMMIT_URL} ${MESSAGE}"
}

function post_rollbar {
  revision=`git log -n 1 --pretty=format:"%H"`

  printf "${ROLLBAR_ICON_BYTE}     Sending deployment to Rollbar... ";
  curl -X POST https://api.rollbar.com/api/1/deploy/ \
    -F access_token=${ROLLBAR_ACCESS_TOKEN} \
    -F environment=${INSTANCE} \
    -F revision=${revision} \
    -F local_username=`${ROLLBAR_LOCAL_USERNAME}`
  echo ""
}

function fail() {
  MESSAGE="Deployment failed, could not push to remote."
  COMMIT_URL="\`<${GITHUB_URL}/commit/$(git_str_commit_hash_full)|$(git_str_commit_hash_short)>\`"

  post_slack_fail "${COMMIT_URL} ${MESSAGE}"
}


###/
# Init
##/
IFS='%'
find_wp
env_branch
add_remote
post_slack_with_attachments
git_push
post_rollbar
unset IFS

exit 0