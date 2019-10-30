#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

# source piUtils.sh

# Parse and store package names from GitHub API
parseGitHubPkgNames () {
	pkgs=$(jq '.items[].full_name' $1)
}

# Parse package count from GitHub API
parseGitHubPkgCount () {
	ghPkgCount=$(jq '.total_count' $1)
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
	printf "Number of packages in GitHub: %s: " "$ghPkgCount"
	printf "\n"
}

# Install from GitHub
# Currently uses exact match for package names
pkgGHInstall () {
	pkgName="$1"
	fetchGitHubPkgNames "false"
	pkgFound=$(echo $pkgs | grep -w "$pkgName")
	pkgCount=$(echo "$pkgFound" | wc -l)

	printf "Found %s package(s) with the name %s" "$pkgCount" "$pkgName"
	if [ "$pkgCount" -gt 1 ]; then
		printf "Listing follows...\n"
		cat -n <<< "$pkgFound"
		return 1
	else
		printf "Selected package: %s" "$pkgFound"
		# Parse GitHub user name
		IFS=/ read p user <<< "$pkgFound"

		# echo "Packages = $pkgs"
		echo "User = $user"
		echo "Pkg = $pkgFound"
		# Download README.md file
		$dApp -d -O README.md "https://raw.githubusercontent.com/$user/$pkgName/master/README.md"
#		[ -f "README.md" ] || exit 1
		# Extract installation expression from tag
		local installExpr=$(grep "^\[//]\:\ #\ (pist)" -A 8 README.md | sed '/\#/d;/^\[/d;/^[[:space:]]*$/d;/.*smalltalk/d;/```/d')
		# local instDevExpr=$(grep "^\[//]\:\ #\ (pidev)" README.md | sed 's/.*smalltalk//;s/\(.*\).../\1/')
		if [ -z "$installExpr" ]; then
			echo "Installation expression not found."
			return $?
		fi
	fi
	printf "Install command: ./pharo %s eval %s" "$imageName" "$installExpr"
	./pharo "$imageName" eval "$installExpr"
	return $?
}
