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
		list )
			list_github_packages
			;;
		init )
			init_db
			;;
		count )
			count_github_packages
			;;
		install | INSTALL )
			install_packages "${@:2}"
			;;
		image | IMAGE )
			install_pharo
			;;
		run | RUN )
			run_pharo
			;;
		search )
			search_packages "${@:2}"
			;;
		clean )
			remove_cache_directory
			;;
		help | h )
			print_help
			;;
		version )
			print_version
			;;
		examples | EXAMPLES )
			examples && exit 0
			;;
		* )
			print_help
			exit 1
	esac
}
