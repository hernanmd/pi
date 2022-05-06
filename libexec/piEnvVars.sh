#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

set_zconf_url () {
    if [ $(uname -m) == 'x86_64' ]; then
        zeroConfUrl="https://get.pharo.org/64"
    else
        zeroConfUrl="https://get.pharo.org"
    fi
}

#################################
## Pharo Installer Settings
#################################

piDate="$(<${BASH_SOURCE%/*}/../DATE)"
piVersion="$(<${BASH_SOURCE%/*}/../VERSION)"

cacheDir=$HOME/.pi/.pi-cache
# Default image name
imageName="Pharo.image"
set_zconf_url
# Default Configuration/Baseline version (stable, development, bleedingEdge)
pkgVersion="stable"
# Detected Operating System
os="Unknown"

#################################
## GitHub Settings
#################################

declare -a ghPkgNames
declare -a pkgs
ghPkgCount=0
ghCurPkgsCount=0
jqListOptions='.items[]|.name,"|",.owner.login,"|",.description,"\n"'
