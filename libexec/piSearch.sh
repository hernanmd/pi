#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#
set -u  # Exit on undefined variables
set -o pipefail  # Catch errors in pipes

# source piGitHub.sh

#################################
## Pharo Searching Packages Section
#################################

# Search for package passed as argument in the GitHub repository
searchGitHubPackages () {
	local pkg_name="$1"
	fetch_github_pkg_names
	printf -- '%s\n' "${ghPkgNames[@]}" | grep -i "$pkg_name" | sed 's/^/GitHub: /'
}

# Search for package passed as argument in all supported repositories
search_packages () {
	local pkg_name="$1"
	[[ -z "$pkg_name" ]] && { printf "Missing package name. Exiting\n"; exit 1; }
	searchGitHubPackages "$pkg_name"
}
