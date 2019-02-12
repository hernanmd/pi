#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source "${BASH_SOURCE%/*}"/piHelp.sh
source "${BASH_SOURCE%/*}"/piSmalltalkHub.sh
source "${BASH_SOURCE%/*}"/piGitHub.sh
source "${BASH_SOURCE%/*}"/piSearch.sh
source "${BASH_SOURCE%/*}"/piInstallPkg.sh
source "${BASH_SOURCE%/*}"/piPharo.sh

parseCmdLine () {
	options="$1"
	case "$1" in
		listgh | listGH | LISTGH )
			silentMode=0
			fetchGitHubPkgNames "true"
			printf '%s\n' "${ghPkgNames[@]}"
			;;
		listsh | listSH | LISTSH )
			silentMode=0
			fetchStHubPkgNames
			echo "$pkgs"
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
		clean )
			removeCacheDir
			;;
		help | h )
			printHelp
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
		printHelp
		exit 1
	esac
}
