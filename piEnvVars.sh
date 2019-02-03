#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#################################
## Pharo Installer Settings
#################################

piVersion=0.3.9
cacheDir=$HOME/.pi-cache
imageName="Pharo.image"
zeroConfUrl="https://get.pharo.org"
stHubUrl="http://smalltalkhub.com/"
stHubPkgIndexFile="index.html"
# Work in verbose (1) or silent mode (0)
silentMode=0
# Default Configuration/Baseline version (stable, development, bleedingEdge)
pkgVersion="stable"
# Detected Operating System
os="Unknown"
# GitHub Globals
declare -a ghPkgNames
declare -a pkgs
ghPkgCount=0
ghCurPkgsCount=0