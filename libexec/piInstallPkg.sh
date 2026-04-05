#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#
set -u  # Exit on undefined variables
set -o pipefail  # Catch errors in pipes

##################################
## Packages Installation Functions
##################################

install_from_github () {
	printf "Scanning GitHub repositories...\n"
	if ! install_pkg_from_github "$1"; then
		printf "exit with error.\n"
		return 1
	else
		printf "done.\n"
		return 0
	fi
}

# Read argument packages and install from their repositories
install_packages () {
	if [ $# -eq 0 ]; then
		pi_log "Please specify at least one package to install\n"
		printf "exit with error\n"
		return 1
	fi
	printf "Installing packages...\n"
	local result=0
	for pkg in "$@"; do
		install_from_github "$pkg" || result=1
	done
	return $result
}
