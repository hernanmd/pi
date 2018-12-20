#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#########################################
# PI Options
#########################################

versionString () {
	silentMode=0
	echo_nline "pi - Pharo Install [version $piVersion]"
}

printBasicHelp () {
	echo "Usage: $0 {listGH | listSH | countGH | countSH | image | examples | [--dev | --bleedingEdge] install <pkgname>}"
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
		install <pkgname>	Install pkgname to the image found in the current working directory. Download the image if not found.

		--dev			Set Configuration/Baseline to install development versions.
		--bleedingEdge		Set Configuration/Baseline to install bleedingEdge version.

Pharo Install project home page: https://github.com/hernanmd/pi
To report bugs or get some help check: https://github.com/hernanmd/pi/issues
This software is licensed under the MIT License.
EOF
}

examples () {
	echo "
List GitHub packages:
$0 listgh

List SmalltalkHub packages:
$0 listsh

Search Both SmalltalkHub and GitHub packages:
$0 search pillar

Download latest stable Pharo image and VM:
$0 image

Install multiple packages:
$0 install Diacritics ISO3166 StringExtensions"
}
