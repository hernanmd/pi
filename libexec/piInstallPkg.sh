#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

##################################
## Packages Installation Functions
##################################

source "${BASH_SOURCE%/*}"/piCatalog.sh

# Detect which Configuration version to install.
# This setting is global: Applied to all Configuration names passed as parameters.
setPkgVersionSetting () {
	printf "Setting package version...\n"
	for param in "$@"; do
		case "$param" in
			"--dev")
				pkgVersion="development"
				;;
			"--bleedingEdge")
				pkgVersion="bleedingEdge"
				;;
		esac
	done
	printf "Selected package version: %s\n" "$pkgVersion"
}

install_from_catalog () {
	printf "Trying to install from Pharo Catalog...\n"
	if ! (pkgCatalogInstall "$1"); then
		printf "not found\n"
		return 1
	else
		printf "done\n"
		return 0
	fi
}

install_from_smalltalkhub () {
	printf "Trying to install from SmalltalkHub...\n"
	if ! (pkgSHInstall "$1"); then
		printf "not found\n"
		return 1
	else
		printf "done\n"
		return 0
	fi
}

install_from_github () {
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
install_packages () {
	printf "Installing packages...\n"
	until [ -z "$1" ]; do
		install_from_github "$1" 
		# || install_from_catalog "$1"
		shift
	done
}
