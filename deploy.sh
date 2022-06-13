#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

set -eo pipefail


main () {
    local version

	if [ -f .nvmrc ]; then
		source ~/.nvm/nvm.sh
		nvm use
	else
		printf "Couldn't find .nvmrc file"
	fi
    echo $(date "+%d-%m-%Y") > DATE
    [[ -f DATE ]] || { printf "Couldn't write DATE file for release\n"; exit 1; }

    if [ $# -eq 0 ]; then
        release-it
    else
        version="$1"
        echo $version > VERSION
        release-it "$version"
    fi
}

main $*
