#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source "${BASH_SOURCE%/*}"/piXMLLint.sh
# source piUtils.sh

dlStHubPkgNames () {
	$dApp $dListParams "$stHubUrl"list
}

fetchStHubPkgNames () {
        [[ -f $stHubPkgIndexFile ]] || { echo "Fetching SmalltalkHub packages list..."; dlStHubPkgNames; }
        downloadLibXML
	pkgs=$(xpath "//a[@class=\"project\"]/text()" "$stHubPkgIndexFile")
}

# Report how many packages were found in SmalltalkHub
countsh_packages () {
	fetchStHubPkgNames
	echo -ne "$pkgs" | wc -l
}

# Install from STHub
# Currently uses exact match for package names
pkgSHInstall () {
	pkgName="$1"
	fetchStHubPkgNames
	pkgFound=$(echo "$pkgs" | grep -w $pkgName)
	pkgCount=$(echo "$pkgFound" | wc -l)
	echo "Found $pkgCount package(s) with the name $pkgName."
	if [ "$pkgCount" -gt 1 ]; then
		echo "Listing follows..."
		cat -n <<< "$pkgFound"
		return 1
	else
		echo "Selected package: $pkgFound"
		IFS=/ read p USER <<< "$pkgFound"
		repoUrl="$stHubUrl"mc/"$USER/$pkgName"
		echo "Repository: $repoUrl"
	fi
	echo "Install command: ./pharo $imageName config $repoUrl "ConfigurationOf"$pkgName --install=$pkgVersion --printVersion"
	./pharo "$imageName" config "$repoUrl" ConfigurationOf"$pkgName" --install="$pkgVersion" --printVersion
	return $?
}
