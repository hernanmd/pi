#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

##################################
## Packages Installation Functions
##################################

installFromGitHub () {
	printf "Scanning GitHub repositories...\n"
	if ! (pkgGHInstall "$1"); then
		printf "exit with error.\n"
		return 1
	else
		printf "done.\n"
		return 0
	fi
}

# Read argument packages and install from their repositories
installPackages () {
	printf "Installing packages...\n"
	until [ -z "$1" ]; do
		installFromGitHub "$1" 
		shift
	done
}
