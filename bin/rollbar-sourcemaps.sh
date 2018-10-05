#!/bin/sh

# Uploads all unique sourcemaps to Rollbar. It will scan the assets/js
# directory for all files with .min.js extensions. It will use this name to
# upload sourcemaps with the .min.js.map extension.
#
# Requires that the CDN is set in the domain.cfg and the wp.cfg WP and THEME
# are set. Uses get-version.sh which requires a composer.json file in the root
# of the site.
#
# Usage
# bin/rollbar-sourcemaps.sh

source bin/config.sh
source bin/get-version.sh

function rollbar_sourcemap {
  files=${WP}${SCRIPTS_DIRECTORY}*.min.js

  for f in $files; do
    minified_url="${CDN}/wp-content/themes/${THEME}/${SCRIPTS_DIRECTORY}$(basename $f)"
    source_map="${WP}/wp-content/themes/${THEME}/${SCRIPTS_DIRECTORY}$(basename $f).map"

    printf "${ROLLBAR_ICON_BYTE}     Uploading v$(get_version) $(basename $f) sourcemaps to Rollbar... ";

    curl https://api.rollbar.com/api/1/sourcemap \
      -F access_token=${ROLLBAR_ACCESS_TOKEN} \
      -F version=$(get_version) \
      -F minified_url=${minified_url} \
      -F source_map=@${source_map}
    echo ""
  done

  echo "Done!"
}

IFS='%'
rollbar_sourcemap
unset IFS

exit 0
