#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

# Install from Catalog
pkgCatalogInstall () {
	pkgName="$1"
	./pharo "$imageName" get "$pkgName"
	return $?
}