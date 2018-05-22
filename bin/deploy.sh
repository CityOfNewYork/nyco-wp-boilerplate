#!/bin/sh
# Deployment script that you can run from anywhere in this project

# Example commands:
# bin/deploy.sh
# ../bin/deploy.sh

# get the absolute path of the script
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# source the environmental variables
source "${SCRIPT_PATH}/../.env"
source "${SCRIPT_PATH}/functions.sh"

# create an array of all the projects the user has listed in .env
ARR=(${!PROJ_*})

###################
# Execute the functions
destProj
echo $userProj