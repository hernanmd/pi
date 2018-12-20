#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

###################################
## Pharo Searching Packages Section
###################################

# Search for package passed as argument in the SmalltalkHub repository
searchsh_packages () {
	silentMode=1
	fetchStHubPkgNames
	printf -- '%s\n' "$pkgs[@]" | grep -i "$1" | sed 's/^/SmalltalkHub\: /'
}

# Search for package passed as argument in the GitHub repository
searchgh_packages () {
	silentMode=1
	fetchGitHubPkgNames "false"
	printf -- '%s\n' "$pkgs[@]" | grep -i "$1" | sed 's/^/GitHub\: /'
}

# Search for package passed as argument in all supported repositories
search_packages () {
	silentMode=1
	searchsh_packages "$1"
	searchgh_packages "$1"
}