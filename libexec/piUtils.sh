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

# Load in the functions and animations
source "${BASH_SOURCE%/*}"/bash_loading_animations.sh

pi_log() {
	printf "PI: $*"
}

pi_err(){
    echo "E: $*" >>/dev/stderr
}

# Returns 0 if command was found in the current system, 1 otherwise
cmd_exists () {
	type "$1" &> /dev/null || [ -f "$1" ];
	return $?
}

cache_not_empty () {
	[[ -z "$(find "${cacheDir}" -maxdepth 0 -type d -empty 2>/dev/null)" ]]
	return $?
}

# Remove cache directory contents
remove_cache_directory () {
	if ! cache_not_empty; then
		 pi_err "Cache is empty\n"
		 exit 1
	else
		[[ -d ${cacheDir} ]] && cache_not_empty && rm ${cacheDir}/* && pi_log "Cache successfully cleaned\n"
	fi
}

# Check package cache directory exists
check_pkg_cache () {
	init_downloaders	
	if [ -d ${cacheDir} ]; then
		# Check if cache directory is populated
    	if [ -z "$(ls -A ${cacheDir})" ]; then
			init_db
		fi
	else
		pi_err "Package cache is empty or broken. Repairing.\n"
		init_db
	fi
}

# Initialize downloaders
init_downloaders () {
	[[ -d ${cacheDir} ]] || mkdir ${cacheDir}
	# Set download application (wget or curl)
	if cmd_exists wget ; then
		dApp="wget --progress=bar:force:noscroll -nv --no-check-certificate "
		dPharoParams="-O-"
	elif cmd_exists curl ; then
			dApp="curl -s "
			dPharoParams=""
		else
			pi_err "I require wget or curl, but it's not installed. Aborting.\n"
			exit 1
	fi
}

# Update package cache directory
update_packages () {
	remove_cache_directory
	check_pkg_cache
	pi_log "Done updating package cache\n"
}