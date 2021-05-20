#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

# source piUtils.sh
source "${BASH_SOURCE%/*}"/piEnvVars.sh
source "${BASH_SOURCE%/*}"/piPharo.sh

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
	[[ -s ${cacheDir}/"$pIndex".js ]] || $dApp "$ghPharoTopics" -O ${cacheDir}/"$pIndex".js
}

readGitHubPkgNames () {
	local cpkgs
    # Remove quotes from pkgs string
    cpkgs=$(sed -e 's/^"//' -e 's/"$//' <<< "$pkgs")
	declare -a fetchedPkgNames
    # Split package names into array
    while read -rd" "; do fetchedPkgNames+=("$pkg"); done <<< $cpkgs
    fetchedPkgNames=($(echo $cpkgs | tr ' ' "\n" ))
	#[[ ${#fetchedPkgNames[@]} -eq 0 ]] && return 1
	ghPkgNames=( "${ghPkgNames[@]}" "${fetchedPkgNames[@]}" )
	# Update package count
    ghCurPkgsCount=${#ghPkgNames[@]}
	#echo "# of fetchedPkgNames found : "${#fetchedPkgNames[@]}
	#echo "# of ghCurPkgsCount found : "${#ghCurPkgsCount[@]}
    #echo "# of packages found : "${#ghPkgNames[@]}
	#echo " --- "
}

fetchGitHubPkgNames () {
	local pageIndex=1
	local perPage=100

 	# Download JSON file if not present
	downloadGitHubPkgNames "$pageIndex" "$perPage"
	# Parse JSON file
	parseGitHubPkgNames ${cacheDir}/"$pageIndex.js"
	readGitHubPkgNames
	parseGitHubPkgCount ${cacheDir}/"$pageIndex.js"
	while [ "$ghCurPkgsCount" -lt "$ghPkgCount" ]; do
		# Set new download page URL
		pageIndex=$(($pageIndex+1))
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
	downloadGitHubPkgNames "$pageIndex" "$perPage"
	parseGitHubPkgCount ${cacheDir}/"$pageIndex.js"
	printf "Number of Pharo packages in GitHub: %s\n" "$ghPkgCount"
}

# Install from GitHub
# Currently uses exact match for package names
pkgGHInstall () {
	pkgNameToInstall="$1"
	fetchGitHubPkgNames "false"
	declare -a matchingPackages
	local lcPharoPkgName installExpr fullInstallExpr saveImageExp fullInstallExpr

	for pharoPackage in "${ghPkgNames[@]}"; do
		# Lowercase strings before comparison
		# Don't use "${pkgName,,}" because it's not supported in macOS bash
		lcPharoPkgName=$(echo "$pharoPackage" | tr '[:upper:]' '[:lower:]')
		lcPkgNameToInstal=$(echo "$pkgNameToInstall" | tr '[:upper:]' '[:lower:]')
		if [[ "$lcPharoPkgName" == *$lcPkgNameToInstal || "$lcPharoPkgName" == "$lcPkgNameToInstal" ]]; then
			 matchingPackages+=("$pharoPackage")
		fi
	done
	# How many packages with the package name typed by the user?
	pkgCount=${#matchingPackages[@]}

	if [ "$pkgCount" -gt 1 ]; then
		printf "Found %s repositories with the package name \"%s\"\n" "$pkgCount" "$pkgNameToInstall"
		printf "Listing follows...\n"
		cat -n <<< "${matchingPackages[@]}"
		printf "Please provide the full name for the package you want to install <repository>/<package name>\n"
		printf "%s\n" "${matchingPackages[@]}"
		return 1
	else
		fullPackageName=${matchingPackages[0]}
		printf "Selected package: %s\n" "$fullPackageName"
		# Parse GitHub repository name with package name
		IFS=/ read user p <<< "$fullPackageName"

		# Download README.md file
		$dApp -O README.md "https://raw.githubusercontent.com/$user/$p/master/README.md"
		[ -f "README.md" ] || { printf "Could not find any README.md in the repository\n"; exit 1; }
		# Extract installation expression from tag
		installExpr=$(grep "^\[//]\:\ #\ (pi)" -A 15 README.md | sed '/\#/d;/^\[\/\//d;/^[[:space:]]*$/d;/.*smalltalk/d;/```/d')
		if [ -z "$installExpr" ]; then
			printf "PI-compatible installation expression not found\n"
			return $?
		fi
		saveImageExp=".Smalltalk snapshot: true andQuit: true."
		fullInstallExpr="${installExpr} ${saveImageExp}"
		# Download and install Pharo image if not present
		installPharo
		printf "Install command: ./pharo --headless %s eval \"%s\"" "$imageName" "$fullInstallExpr"
		./pharo --headless "$imageName" eval "$fullInstallExpr"
	fi
	return $?
}

# List packages in cache
listgh_packages () {
	# Parse JSON file
	jq -jr '.items[]|.name,"|",.owner.login,"|",.description,"\n"' \
		${cacheDir}/*.js \
		| column -s'|' -t -c 500 \
		| LC_ALL='C' sort -t$'\t' -i -b -k1,2 -f 
}
