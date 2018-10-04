#!/bin/sh

# Updates the version of the following files using the supplied version;
#
# composer.json
# wp-content/themes/$THEME/style.css
# wp-content/themes/$THEME/package.json
# wp-content/themes/$THEME/package-lock.json
#
# It then commits the changes and tags the commit.
#
# Usage;
# bin/version.sh <version-number>
# ex;
# bin/version.sh 3.1.0

source config.sh
source bin/find_wp.sh
source bin/git.sh

VERSION=$1
COMMAND_PACKAGE_LOCK="npm install --package-lock-only"
COMMAND_ADD="git add -A"
COMMAND_COMMIT="git commit -m \"v$VERSION\""
COMMAND_TAG="git tag v$VERSION"

function version_composer {
  echo "\xF0\x9F\x94\xAC     Versioning site... ";
  sed -i "" -E "s|\"version\": \"([0-9.-]*)\"|\"version\": \"$VERSION\"|g" composer.json
}

function version_theme {
  echo "\xF0\x9F\x94\xAC     Finding and versioning theme... ";
  cd "wp-content/themes/$THEME/"
  sed -i "" -E "s|Version: ([0-9.-]*)|Version: $VERSION|g" style.css
  sed -i "" -E "s|\"version\": \"([0-9.-]*)\"|\"version\": \"$VERSION\"|g" package.json
}

function regen_package_lock {
  echo "\xF0\x9F\x94\xAC     Regenerating package-lock.json... ";
  if eval $COMMAND_PACKAGE_LOCK ; then
    printf ""
  else
    echo "package-lock.json regen failed."
    exit 0
  fi
}

function success {
  echo "Successfully versioned and tagged v$VERSION release. You can push your commit to origin and pull into master."
}

IFS='%'
find_wp
version_composer
version_theme
regen_package_lock
git_add $COMMAND_ADD
git_commit $COMMAND_COMMIT
git_tag $COMMAND_TAG
success
unset IFS

exit 0