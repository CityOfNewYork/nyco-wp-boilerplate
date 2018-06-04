#!/bin/sh

#####
# prompt the user for which project they would like to use
function destProj() {
	echo "What is the project destination?"
	for i in ${!ARR[@]}
	do
		echo [$i] ${!ARR[i]}
	done
	printf "Selection: "
	read choice

	# set the destination project
	userProj=${!ARR[choice]}
}

###
# update the wordpress core
function coreUpdate(){
	# define base directory 
	baseDir="$(dirname "${SCRIPT_PATH}")"
	echo "Base directory is:" $baseDir

	# create temp directory
	mkdir $baseDir/temp

	# copy the .git and .gitignore into the base directory
	echo 'copying .git and .gitignore'
	cp -R $baseDir/wp/.git $baseDir
	cp $baseDir/wp/.gitignore $baseDir
	echo '>>>done'

	# rename the composer.json in the root of the project
	# copy composer-plugins.json to teh base directory
	echo 'rename and copy composer.json for plugins'
	mv $baseDir/wp/composer.json $baseDir/wp/composer-plugins.json
	mv $baseDir/wp/composer.lock $baseDir/wp/composer-plugins.lock
	cp $baseDir/wp/composer-plugins.json $baseDir
	cp $baseDir/wp/composer-plugins.lock $baseDir
	echo '>>>done'

	# copy the readme to the base directory
	cp $baseDir/wp/README.md $baseDir

	# copy index, wp-config.php, and wp-content 
	# to the base directory
	echo 'copying wp-content'
	cp -R $baseDir/wp/wp-content $baseDir
	echo '>>>done'

	# composer install to update the wordpress core
	echo 'running composer install'
	composer install

	# copy git and gitignore back into project directory
	echo 'RESTORE git and gitignore'
	mv .git $baseDir/wp/
	mv .gitignore $baseDir/wp/

	# Copy index, config and wp-content into app directory
	echo 'copying wp-config'
	cp -rv wp-config.php $baseDir/wp/

	# Copy plugins composer
	echo 'remove new and move plugins composer.json'
	rm $baseDir/wp/composer.json
	mv composer-plugins.json $baseDir/wp/
	mv $baseDir/wp/composer-plugins.json $baseDir/wp/composer.json
	mv composer-plugins.lock $baseDir/wp/
	mv $baseDir/wp/composer-plugins.lock $baseDir/wp/composer.lock

	# move the readme back
	mv README.md $baseDir/wp/

	# remove the current wp-content built by composer
	rm -r $baseDir/wp/wp-content

	# move wp-content back
	echo 'adding wp-content'
	cp -R wp-content $baseDir/wp/
	rm -r wp-content
	echo '>>>done'

	# remove the root vendor and composer.lock
	rm -r vendor
	rm composer.lock

	# mission complete
	echo 'updating wordpress core complete'

	# remove the temp dir
	if [ -z "$(ls -A $baseDir/temp)" ]; then
		echo "temp directory is empty... Removing."
		rmdir temp/
	else
	   echo "temp directory is not empty... Keeping."
	fi
}