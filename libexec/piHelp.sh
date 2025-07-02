#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#########################################
# PI Options
#########################################

print_version () {
	printf "pi - Pharo Install [version %s - %s]\n" "$piVersion" "$piDate"
}

print_basic_help () {
	program_name=$(basename "$0")
	printf "Usage: %s {count | image | install <pkgname>} | list | run | search <pkgname> | update\n" "$program_name"
}

print_help () {
	print_version
cat << EOF

PI is a tool for installing Pharo Smalltalk packages (http://www.pharo.org)

EOF

	print_basic_help

cat << EOF

The options include:
	clean 			Clean cache package directory.
	count			Report how many packages were found in GitHub.
	examples		Show usage examples.
	image			Fetch the latest stable Pharo (VM + Image).
	init			Initialize and fetch PI Pharo package cache
	install <pkgname>	Install pkgname to the Image found in the current directory. Download image if not found.
	list			List Pharo packages found in GitHub.
	run			Run a Pharo Image.
	irun			Download and run Pharo.image.
	nrun			Download in a new timestamped directory and run Pharo.image.
	trun			Trash pharo-local and run Pharo.image.
	search <pkgname>	Search for pkgname in GitHub.
	update			Update package directory.
	version 		Show program version.

Pharo Install project home page: https://github.com/hernanmd/pi
To report bugs or get some help check: https://github.com/hernanmd/pi/issues
This software is licensed under the MIT License.
EOF
}

examples () {
	echo "$(<${BASH_SOURCE%/*}/../EXAMPLES)"
}
