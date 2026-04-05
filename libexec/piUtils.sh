#!/usr/bin/env bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#
set -u  # Exit on undefined variables
set -o pipefail  # Catch errors in pipes

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
	type -- "$1" &> /dev/null
	return $?
}

# Returns 0 if cache directory has contents, 1 if empty or doesn't exist
cache_not_empty () {
	if [ -d "${cacheDir}" ] && [ -n "$(ls -A "${cacheDir}" 2>/dev/null)" ]; then
		return 0
	fi
	return 1
}

# Remove cache directory contents
remove_cache_directory () {
	if [ ! -d "${cacheDir}" ]; then
		pi_err "Cache directory does not exist\n"
		return 1
	fi
	if cache_not_empty; then
		rm -rf "${cacheDir}"/* && pi_log "Cache successfully cleaned\n"
	else
		pi_err "Cache is already empty\n"
		return 1
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
	# Set download application (curl)
	if cmd_exists curl ; then
		dApp="curl -s "
		dPharoParams=""
	else
		pi_err "I require curl, but it's not installed. Aborting.\n"
		exit 1
	fi
}

# Update package cache directory
update_packages () {
	remove_cache_directory
	check_pkg_cache
	pi_log "Done updating package cache\n"
}