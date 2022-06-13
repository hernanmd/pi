#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source "${BASH_SOURCE%/*}"/piHelp.sh
source "${BASH_SOURCE%/*}"/piGitHub.sh
source "${BASH_SOURCE%/*}"/piSearch.sh
source "${BASH_SOURCE%/*}"/piInstallPkg.sh
source "${BASH_SOURCE%/*}"/piPharo.sh

parse_cmd_line () {
	case "$1" in
		clean )
			remove_cache_directory
			;;	
		count )
			count_github_packages
			;;
		examples | EXAMPLES )
			examples && exit 0
			;;
		image | IMAGE )
			install_pharo
			;;
		init | INIT)
			init_db
			;;
		install | INSTALL )
			install_packages "${@:2}"
			;;
		list )
			list_github_packages
			;;
		run | RUN )
			run_pharo
			;;
		search )
			search_packages "${@:2}"
			;;
		update )
			update_packages
			;;
		version )
			print_version
			;;
		* )
			print_help
			exit 1
	esac
}
