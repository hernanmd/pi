#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

##################################
## Packages Installation Functions
##################################

install_from_github () {
	printf "Scanning GitHub repositories...\n"
	if ! (install_pkg_from_github "$1"); then
		printf "exit with error.\n"
		return 1
	else
		printf "done.\n"
		return 0
	fi
}

# Read argument packages and install from their repositories
install_packages () {
	printf "Installing packages...\n"
	until [ -z "$1" ]; do
		install_from_github "$1" 
		shift
	done
}
