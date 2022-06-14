#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#set -eo pipefail

main () {
    local version

	if [ -f .nvmrc ]; then
		source ~/.nvm/nvm.sh
		nvm use
	else
		printf "Couldn't find .nvmrc file.\nYou can generate a .nvmrc file for your node version with nvm ls"
	fi
    echo $(date "+%d-%m-%Y") > DATE
    [[ -f DATE ]] || { printf "Couldn't write DATE file for release\n"; exit 1; }

    # It is highly recommended to supply a version number, otherwise we lose tracking the number in VERSION file
    if [ $# -eq 0 ]; then
        release-it
    else
    	printf "PI: Version supplied: %s\n" "$1"
        version="$1"
        echo $version > VERSION
        release-it "$version"
    fi
}

main $*
