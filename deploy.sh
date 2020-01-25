#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

set -eo pipefail

main () {
    local version

    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        exit 1
    fi
    version="$1"

    echo $(date "+%d-%m-%Y") > DATE
    [[ -f DATE ]] || { echo "Couldn't write DATE file for release"; exit 1; }
    release-it "$version"
}

main $*