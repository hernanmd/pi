#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

set -eo pipefail

main () {
    local version

    echo $(date "+%d-%m-%Y") > DATE
    [[ -f DATE ]] || { printf "Couldn't write DATE file for release\n"; exit 1; }

    if [ $# -eq 0 ]; then
        release-it
    else
        version="$1"
        release-it "$version"
    fi
}

main $*