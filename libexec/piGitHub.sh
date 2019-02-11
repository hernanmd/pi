#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source piUtils.sh

# Parse and store package names from GitHub API
parseGitHubPkgNames () {
    if type jq &> /dev/null; then
        pkgs=$(jq '.items[].full_name' $1)
    else
        pkgs=$(./jq '.items[].full_name' $1)
    fi
}

# Parse package count from GitHub API
parseGitHubPkgCount () {
    if type jq &> /dev/null; then
        ghPkgCount=$(jq '.total_count' $1)
    else
        ghPkgCount=$(./jq '.total_count' $1)
    fi
}

downloadGitHubPkgNames () {
    local pIndex="$1"
    local perPage="$2"
    # echo "Download JSON file"
    local ghPharoTopics="https://api.github.com/search/repositories?per_page=$perPage&page=$pIndex&q=topic:pharo"
	[[ -f ${cacheDir}/"$pIndex".js ]] || $dApp "$ghPharoTopics" -O ${cacheDir}/"$pIndex".js
    # echo "Done"
}

readGitHubPkgNames () {
    # Remove quotes from pkgs string
    local cpkgs=$(sed -e 's/^"//' -e 's/"$//' <<< "$pkgs")
	declare -a fetchedPkgNames
    # Split package names into array
    while read -rd" "; do fetchedPkgNames+=("$pkg"); done <<< $cpkgs
    fetchedPkgNames=($(echo $cpkgs | tr ' ' "\n" ))
	ghPkgNames=( "${ghPkgNames[@]}" "${fetchedPkgNames[@]}" )
	# Update package count
    ghCurPkgsCount=${#ghPkgNames[@]}
    # echo "# of packages found : "${#ghPkgNames[@]}
}

fetchGitHubPkgNames () {
	local pageIndex=1
	local perPage=100
	local printPkgs="$1"
	downloadJQ

 	# Download JSON file if not present
	downloadGitHubPkgNames "$pageIndex" "$perPage"
	# Parse JSON file
	parseGitHubPkgNames ${cacheDir}/"$pageIndex.js"
	readGitHubPkgNames
	parseGitHubPkgCount ${cacheDir}/"$pageIndex.js"
	while [ "$ghCurPkgsCount" -lt "$ghPkgCount" ]; do
		# Set new download page URL
		pageIndex=$(("$pageIndex"+1))
		# Download new results
		downloadGitHubPkgNames "$pageIndex" "$perPage"
		# Parse JSON result into String
		parseGitHubPkgNames ${cacheDir}/"$pageIndex.js"
		readGitHubPkgNames
	done
}

# Report how many packages were found in GitHub
countgh_packages () {
	local pageIndex=1
	local perPage=1
	silentMode=1
	downloadGitHubPkgNames "$pageIndex" "$perPage"
	parseGitHubPkgCount ${cacheDir}/"$pageIndex.js"
	echo "# Packages found in GitHub: $ghPkgCount"
}

# Install from GitHub
# Currently uses exact match for package names
pkgGHInstall () {
	pkgName="$1"
	fetchGitHubPkgNames "false"
	pkgFound=$(echo $pkgs | grep -w "$pkgName")
	pkgCount=$(echo "$pkgFound" | wc -l)

	echo "Found $pkgCount package(s) with the name $pkgName."
	if [ "$pkgCount" -gt 1 ]; then
		echo "Listing follows..."
		cat -n <<< "$pkgFound"
		return 1
	else
		echo "Selected package: $pkgFound"
		# Parse GitHub user name
		IFS=/ read p user <<< "$pkgFound"

		# echo "Packages = $pkgs"
		echo "User = $user"
		echo "Pkg = $pkgFound"
		# Download README.md file
#		$dApp -d -O README.md "https://raw.githubusercontent.com/$user/$pkgName/master/README.md"
#		[ -f "README.md" ] || exit 1
		# Extract installation expression from tag
#		local installExpr=$(grep "^\[//]\:\ #\ (pist)" -A 8 README.md \
#			| sed '/\#/d;/^\[/d;/^[[:space:]]*$/d;/.*smalltalk/d;/```/d')
		# local instDevExpr=$(grep "^\[//]\:\ #\ (pidev)" README.md | sed 's/.*smalltalk//;s/\(.*\).../\1/')
		if [ -z "$installExpr" ]; then
			echo "Installation expression not found."
			return $?
		fi
	fi
	echo "Install command: ./pharo $imageName eval $installExpr"
#	./pharo "$imageName" eval "$installExpr"
	return $?
}