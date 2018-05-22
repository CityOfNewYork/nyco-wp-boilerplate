#!/bin/sh
# Deployment script that you can run from anywhere in this project

# Example commands:
# bin/deploy.sh
# ../bin/deploy.sh

# get the absolute path of the script
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# source the environmental variables
source "${SCRIPT_PATH}/../.env"
source "${SCRIPT_PATH}/headers.sh"
source "${SCRIPT_PATH}/functions.sh"

# create an array of all the projects the user has listed in .env
ARR=(${!PROJ_*})

###################
# Execute the functions
welcomeHead

destProj
echo "You selected:" $userProj

echo "What do you want to do?"
echo "[0] Deploy"
echo "[1] Sync"
echo "[2] Update"
printf "Selection: "
read selection
if [[ $selection == 0 ]]; then
	deployHead
elif [[ $selection == 1 ]]; then
	syncHead
elif [[ $selection == 2 ]]; then
	updateHead

	coreUpdate
else
	echo "Nothing was selected... exiting."
	exit 1
fi