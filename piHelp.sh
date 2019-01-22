#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source piEnvVars.sh

#########################################
# PI Options
#########################################

versionString () {
	silentMode=0
	echo_nline "pi - Pharo Install [version $piVersion]"
}

printBasicHelp () {
	program_name="$0"
	echo "Usage: $(basename $program_name) {listGH | listSH | countGH | countSH | image | examples | [--dev | --bleedingEdge] install <pkgname>}"
}

printHelp () {
	silentMode=0
cat << EOF
pi - Pharo Install [version $piVersion]

PI is a tool for installing Pharo Smalltalk packages (http://www.pharo.org)

EOF

	printBasicHelp

cat << EOF
The options include:
		listgh			List packages found in GitHub
		listsh			List packages found in SmalltalkHub
		countsh			Report how many packages were found in SmalltalkHub
		countgh			Report how many packages were found in GitHub
		search <pgname>		Search for pkgname in SmalltalkHub and GitHub repositories
		searchgh <pkgname>	Search for pkgname in GitHub repository
		searchsh <pkgname>	Search for pkgname in SmalltalkHub repository
		image			Fetch the latest stable Pharo (VM + Image).
		examples		Show usage examples
		version 		Show program version
		install <pkgname>	Install pkgname to the Image found in the current directory. Download Image if not found.

		--dev			Set Configuration/Baseline to install development versions.
		--bleedingEdge		Set Configuration/Baseline to install bleedingEdge version.

Pharo Install project home page: https://github.com/hernanmd/pi
To report bugs or get some help check: https://github.com/hernanmd/pi/issues
This software is licensed under the MIT License.
EOF
}

examples () {
	program_name="$0"
	echo "
List GitHub packages:
$(basename $program_name) listgh

List SmalltalkHub packages:
$(basename $program_name) listsh

Search Both SmalltalkHub and GitHub packages:
$(basename $program_name) search pillar

Download latest stable Pharo image and VM:
$(basename $program_name) image

Install multiple packages:
$(basename $program_name) install Diacritics ISO3166 StringExtensions"
}
