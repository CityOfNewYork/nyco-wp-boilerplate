#!/bin/sh
# Only run this is you want to update the boilerplate
# boilerplate.sh

SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$(dirname "$SCRIPT_PATH")

source "${BASE_PATH}/config/wp.cfg"
PROJ_PATH=$WP

bpTempDir=$baseDir/temp/bp
wpTempDir=$baseDir/temp/wp

# function will move the .git/ and .gitignore of the WP
# into the temporary folder so that you'll be able to 
# make updates to the boilerplate
function updateBoilerplate() {
	echo "\nGreat! You've chosen update the boilerplate. We're gonna get that setup for you right now."
	echo "If you made a mistake, hit Ctrl-C"
	echo "\nMoving the boilerplate back to ${baseDir} from ${bpTempDir}"

	# checking existence of repo in root
	if [ -d $BASE_PATH/.git ] || [ -e $BASE_PATH/.gitignore ] ; then
		echo "It appears that the boilerplate repo is already in the root. Nothing to do. \n"
		promptUser
	fi

	# moves boilerplate repo to root
	if [ ! -d $BASE_PATH/.git ] && [ -d $bpTempDir/.git ]; then
		echo "moving the boilerplate repo to the root"
		mv $bpTempDir/.git/ $BASE_PATH
		if [ -e $bpTempDir/.gitignore ]; then
	    echo "Moving the gitignore."
	    mv $bpTempDir/.gitignore $BASE_PATH
		else
	    echo "No gitignore."
		fi
	fi

	# move the project repo to temp
	if [ -d $PROJ_PATH/.git ] || [ -e $BASE_PATH/.gitignore ] ; then
		echo "\nMoving the WordPress project repo to ${wpTempDir}"
		mv $PROJ_PATH/.git/ $wpTempDir
		echo "\nMoving the WordPress project gitignore to ${wpTempDir}"
    mv $PROJ_PATH/.gitignore $wpTempDir
  fi
}

# When you want to go back to making edits to the WP,
# move the boilerplate git repo and gitignore back 
# into the temp directory
function updateWP() {
	echo "\nAwesome! You want to get back to your WordPress project. We're working on it!"
	echo "If you made a mistake, hit Ctrl-C"
}

# --------------------------------------------------------
function promptUser(){
	echo "What do you want to do?"
	echo "[1] Update the nyco-wp-docker-boilerplate"
	echo "[2] Update your Wordpress Project"
	printf "Selection: "
	read selection
	if [[ $selection == 1 ]]; then
		updateBoilerplate
	elif [[ $selection == 2 ]]; then
		updateWP
	else
		echo "You didn't make a valid selection... Exiting."
		exit 1
	fi
}

promptUser