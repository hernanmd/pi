#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

##################################
## Packages Installation Functions
##################################

# Detect which Configuration version to install.
# This setting is global: Applied to all Configuration names passed as parameters.
setPkgVersionSetting () {
	echo_nline "Setting package version..."
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
	echo_nline "Selected package version: $pkgVersion"
}

# Read argument packages and install from their repositories
install_packages () {
	until [ -z "$1" ]; do
		echo_nline "Trying to install from Pharo Catalog..."
		if ! (pkgCatalogInstall "$1"); then
			echo_line "not found"
			echo_nline "Trying to install from SmalltalkHub..."
			if ! (pkgSHInstall "$1"); then
				echo_line "not found"
				echo_nline "Trying to install from GitHub..."
				if ! (pkgGHInstall "$1"); then
					echo_line "not found"
				else
					echo_nline "done"
				fi
			else
				echo_nline "done"
			fi
		else
			echo_nline "done"
		fi
		shift
	done
}