#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#########################################
# PI Options
#########################################

versionString () {
	silentMode=0
	echo_nline "pi - Pharo Install [version $piVersion - $piDate]"
}

printBasicHelp () {
	program_name="$0"
	echo "Usage: $(basename $program_name) {list[GH,SH] | count[GH,SH] | clean | help | image | examples | install <pkgname>}"
}

# Future version
#		--dev			Set Configuration/Baseline to install development versions.
#		--bleedingEdge		Set Configuration/Baseline to install bleedingEdge version.
printHelp () {
	silentMode=0
	versionString
cat << EOF

PI is a tool for installing Pharo Smalltalk packages (http://www.pharo.org)

EOF

	printBasicHelp

cat << EOF
The options include:
	clean 			Clean cache package directory
	countgh			Report how many packages were found in GitHub
	countsh			Report how many packages were found in SmalltalkHub
	examples		Show usage examples
	image			Fetch the latest stable Pharo (VM + Image).
	install <pkgname>	Install pkgname to the Image found in the current directory. Download Image if not found.
	listgh			List packages found in GitHub
	listsh			List packages found in SmalltalkHub
	search <pgname>		Search for pkgname in SmalltalkHub and GitHub repositories
	searchgh <pkgname>	Search for pkgname in GitHub repository
	searchsh <pkgname>	Search for pkgname in SmalltalkHub repository
	version 		Show program version

Pharo Install project home page: https://github.com/hernanmd/pi
To report bugs or get some help check: https://github.com/hernanmd/pi/issues
This software is licensed under the MIT License.
EOF
}

examples () {
	echo "$(<EXAMPLES)"
}
