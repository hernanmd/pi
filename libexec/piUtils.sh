#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#################################
## Helper Functions
#################################

#function finish {
  # Your cleanup code here
  # printf "Finished\n"
#}
#trap finish EXIT

err(){
    echo "E: $*" >>/dev/stderr
}

# Returns 0 if command was found in the current system, 1 otherwise
cmdExists () {
	type "$1" &> /dev/null || [ -f "$1" ];
	return $?
}

cacheNotEmpty () {
	[[ -z "$(find "${cacheDir}" -maxdepth 0 -type d -empty 2>/dev/null)" ]]
	return $?
}

# Remove cache directory contents
removeCacheDir () {
	if ! cacheNotEmpty; then
		 printf "Cache is empty\n"
		 exit 1
	else
		[[ -d ${cacheDir} ]] && cacheNotEmpty && rm ${cacheDir}/* && printf "Cache successfully cleaned\n"
	fi
}

checkCache () {
	# Check package cache directory exists
	if [ -d ${cacheDir} ]; then
		# Check if cache directory is populated
    	if [ -z "$(ls -A ${cacheDir})" ]; then
			initApp
		fi
	else
		err "Package cache is broken. Repairing.\n"
		initApp
	fi
}

initApp () {
	# Create cache directory if does not exist
	[[ -d ${cacheDir} ]] || mkdir ${cacheDir}
	# Set download application (wget or curl)
	if cmdExists wget ; then
		dApp="wget --progress=bar:force:noscroll -q --no-check-certificate "
		dPharoParams="-O-"
	elif cmdExists curl ; then
			dApp="curl -s "
			dPharoParams=""
		else
			printf "I require wget or curl, but it's not installed. Aborting.\n"
			exit 1
	fi
	init_db
}

