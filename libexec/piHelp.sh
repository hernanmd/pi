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

printBasicHelp () {
	program_name=$(basename "$0")
	printf "Usage: %s {list | count | init | clean | help | image | run | examples | install <pkgname>}\n" "$program_name"
}

# Future version
#		--dev			Set Configuration/Baseline to install development versions.
#		--bleedingEdge		Set Configuration/Baseline to install bleedingEdge version.
print_help () {
	print_version
cat << EOF

PI is a tool for installing Pharo Smalltalk packages (http://www.pharo.org)

EOF

	printBasicHelp

cat << EOF

The options include:
	clean 			Clean cache package directory
	count			Report how many packages were found in GitHub
	examples		Show usage examples
	image			Fetch the latest stable Pharo (VM + Image)
	run				Run a Pharo Image
	init			Initialize and fetch PI Pharo package cache
	install <pkgname>	Install pkgname to the Image found in the current directory. Download Image if not found.
	list			List Pharo packages found in GitHub
	search <pgname>	Search for pkgname in GitHub
	version 		Show program version

Pharo Install project home page: https://github.com/hernanmd/pi
To report bugs or get some help check: https://github.com/hernanmd/pi/issues
This software is licensed under the MIT License.
EOF
}

examples () {
	echo "$(<${BASH_SOURCE%/*}/../EXAMPLES)"
}
