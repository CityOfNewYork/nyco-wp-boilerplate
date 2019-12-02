#!/bin/sh

# Pushes/publishes the current branch and pushes all missing tags from the local repository.ls
#
# Usage;
# bin/publish.sh

source config/bin.cfg
source bin/find-wp.sh
source bin/git.sh

COMMAND_PUSH="git push && git push --tags"

function success {
  echo "Successfully published the latest tags."
}

IFS='%'
find_wp
git_push $COMMAND_PUSH
success
unset IFS

exit 0