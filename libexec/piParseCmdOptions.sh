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
	case "$1" in
		list )
			listgh_packages
			;;
		count )
			countgh_packages
			;;
		install | INSTALL )
			install_packages "${@:2}"
			;;
		image | IMAGE )
			install_pharo
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
		* )
			printHelp
			exit 1
	esac
}
