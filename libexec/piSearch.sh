#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

# source piGitHub.sh

###################################
## Pharo Searching Packages Section
###################################

# Search for package passed as argument in the GitHub repository
searchGitHubPackages () {
	fetchGitHubPkgNames
	printf -- '%s\n' "${ghPkgNames[@]}" | grep -i "$1" | sed 's/^/GitHub\: /'
}

# Search for package passed as argument in all supported repositories
searchPackages () {
	pkg_name="$1"
	[[ -n $pkg_name ]] || { printf "Missing package name. Exiting\n"; exit 1; }
	# searchsh_packages $pkg_name
	searchGitHubPackages $pkg_name
}
