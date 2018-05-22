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