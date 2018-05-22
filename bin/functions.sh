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
function coreUpdate(){
	# define base directory 
	baseDir="$(dirname "${SCRIPT_PATH}")"
	echo "Base directory is:" $baseDir

	# copy the .git and .gitignore into the base directory
	echo 'copying .git and .gitignore'
	cp -R wp/.git $baseDir
	cp wp/.gitignore $baseDir
	echo '>>>done'

	# rename the composer.json in the root of the project
	# copy composer-plugins.json to teh base directory
	echo 'rename and copy composer.json for plugins'
	mv wp/composer.json wp/composer-plugins.json
	mv wp/composer.lock wp/composer-plugins.lock
	cp wp/composer-plugins.json $baseDir
	cp wp/composer-plugins.lock $baseDir
	echo '>>>done'

	# copy the readme to the base directory
	cp wp/README.md $baseDir

	# copy index, wp-config.php, and wp-content 
	# to the base directory
	echo 'copying wp-content'
	cp -R wp/wp-content $baseDir
	echo '>>>done'

	# composer install to update the wordpress core
	echo 'running composer install'
	composer install

	# copy git and gitignore back into project directory
	echo 'RESTORE git and gitignore'
	mv .git wp/
	mv .gitignore wp/

	# Copy index, config and wp-content into app directory
	echo 'copying wp-config'
	cp -rv wp-config.php wp/

	# Copy plugins composer
	echo 'remove new and move plugins composer.json'
	rm wp/composer.json
	mv composer-plugins.json wp/
	mv wp/composer-plugins.json wp/composer.json
	mv composer-plugins.lock wp/
	mv wp/composer-plugins.lock wp/composer.lock

	# move the readme back
	mv README.md wp/

	# remove the current wp-content built by composer
	rm -r wp/wp-content

	# move wp-content back
	echo 'adding wp-content'
	cp -R wp-content wp/
	rm -r wp-content
	echo '>>>done'

	# remove the root vendor and composer.lock
	rm -r vendor
	rm composer.lock

	# mission complete
	echo 'updating wordpress core complete'
}