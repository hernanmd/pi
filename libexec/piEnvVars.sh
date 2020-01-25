#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#################################
## Pharo Installer Settings
#################################

piVersion=$(<VERSION)
piDate="$(<DATE)"
cacheDir=$HOME/.pi/.pi-cache
imageName="Pharo.image"
zeroConfUrl="https://get.pharo.org"
# Work in verbose (1) or silent mode (0)
silentMode=0
# Default Configuration/Baseline version (stable, development, bleedingEdge)
pkgVersion="stable"
# Detected Operating System
os="Unknown"

#################################
## SmalltalkHub Settings
#################################

stHubUrl="http://smalltalkhub.com/"
stHubPkgIndexFile="index.html"

#################################
## GitHub Settings
#################################

declare -a ghPkgNames
declare -a pkgs
ghPkgCount=0
ghCurPkgsCount=0
