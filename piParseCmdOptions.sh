#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

parseCmdLine () {
	options="$1"
	case "$1" in
		listgh | listGH | LISTGH )
			silentMode=0
			fetchGitHubPkgNames "true"
			echo "$ghPkgNames"
			;;
		listsh | listSH | LISTSH )
			silentMode=0
			fetchStHubPkgNames
			echo "$pkgs"
			;;
		help | h )
			printHelp
			;;
		countsh | countSH | COUNTSH )
			silentMode=1
			countsh_packages
			;;
		countgh | countGH | COUNTGH )
			countgh_packages
			;;
		install | INSTALL )
			install_pharo
			install_packages "${@:2}"
			;;
		image | IMAGE )
			install_pharo
			;;
		searchsh )
			searchsh_packages "${@:2}"
			;;
		searchgh )
			searchgh_packages "${@:2}"
			;;
		search )
			search_packages "${@:2}"
			;;
		version )
			versionString
			;;
		examples | EXAMPLES )
			examples && exit 0
			;;
		"--dev" | "--bleedingEdge")
			setPkgVersionSetting "${@}"
			#install_pharo
			#install_packages "${@:3}"
			;;
		* )
		printBasicHelp
		exit 1
	esac
}