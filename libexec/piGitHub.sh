#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#
set -u  # Exit on undefined variables
set -o pipefail  # Catch errors in pipes

source "${BASH_SOURCE%/*}"/piUtils.sh
source "${BASH_SOURCE%/*}"/piPharo.sh

# Download package list
init_db () {
	pi_log "Please wait while the package list is downloaded... "
	fetch_github_pkg_names
	parse_github_pkg_count "${cacheDir}/1.js"
	pi_log "Detected Pharo packages in GitHub: %s\n" "$ghPkgCount"
}

# Parse and store package names from GitHub API
parse_github_pkg_names () {
	pkgs=$(jq -r '.items[].full_name' "$1")
}

# Parse package count from GitHub API
parse_github_pkg_count () {
	ghPkgCount=$(jq '.total_count' $1)
}

download_github_pkg_names () {
    local pIndex="$1"
    local perPage="$2"
    local ghPharoTopics="https://api.github.com/search/repositories?per_page=$perPage&page=$pIndex&q=topic:pharo"
	[[ -s "${cacheDir}/$pIndex.js" ]] || $dApp "$ghPharoTopics" -o "${cacheDir}/$pIndex.js"
}

read_github_pkg_names () {
	# Read pkgs (global variable set by parse_github_pkg_names)
	# Split by whitespace into array
	local cpkgs="$pkgs"
	# Convert newlines to spaces for consistent splitting
	cpkgs=$(echo "$cpkgs" | tr '\n' ' ')
	# Split into array
	read -ra fetchedPkgNames <<< "$cpkgs"
	# Append to global array
	ghPkgNames=( "${ghPkgNames[@]}" "${fetchedPkgNames[@]}" )
	# Update package count
	ghCurPkgsCount=${#ghPkgNames[@]}
}

fetch_github_pkg_names () {
	local pageIndex=1
	local perPage=100
	# Reset package array
	ghPkgNames=()

 	# Download JSON file if not present
	download_github_pkg_names "$pageIndex" "$perPage"
	# Parse JSON file
	parse_github_pkg_names "${cacheDir}/${pageIndex}.js"
	read_github_pkg_names
	parse_github_pkg_count "${cacheDir}/${pageIndex}.js"
	while [ "$ghCurPkgsCount" -lt "$ghPkgCount" ]; do
		# Set new download page URL
		pageIndex=$(($pageIndex+1))
		# Download new results
		download_github_pkg_names "$pageIndex" "$perPage"
		# Parse JSON result into String
		parse_github_pkg_names "${cacheDir}/${pageIndex}.js"
		read_github_pkg_names
	done
}

# Report how many packages were found in GitHub
count_github_packages () {
	local pageIndex=1
	local perPage=1
	download_github_pkg_names "$pageIndex" "$perPage"
	parse_github_pkg_count "${cacheDir}/${pageIndex}.js"
	pi_log "Detected Pharo packages in GitHub: %s\n" "$ghPkgCount"
}

# Install from GitHub
# Currently uses exact match for package names
install_pkg_from_github () {
	local pkgNameToInstall="$1"
	fetch_github_pkg_names
	local -a matchingPackages
	local lcPharoPkgName installExpr fullInstallExpr

	for pharoPackage in "${ghPkgNames[@]}"; do
		# Lowercase strings before comparison
		# Don't use "${pkgName,,}" because it's not supported in macOS bash
		lcPharoPkgName=$(echo "$pharoPackage" | tr '[:upper:]' '[:lower:]')
		lcPkgNameToInstal=$(echo "$pkgNameToInstall" | tr '[:upper:]' '[:lower:]')
		if [[ "$lcPharoPkgName" == *"$lcPkgNameToInstal"* || "$lcPharoPkgName" == "$lcPkgNameToInstal" ]]; then
			 matchingPackages+=("$pharoPackage")
		fi
	done
	# How many packages with the package name typed by the user?
	local pkgCount=${#matchingPackages[@]}

	if [ "$pkgCount" -gt 1 ]; then
		pi_log "Found %s repositories with the package name \"%s\"\n" "$pkgCount" "$pkgNameToInstall"
		pi_log "Listing follows...\n"
		cat -n <<< "${matchingPackages[@]}"
		pi_log "Please provide the full name for the package you want to install <repository>/<package name>\n"
		pi_log "%s\n" "${matchingPackages[@]}"
		return 1
	elif [ "$pkgCount" -eq 0 ]; then
		pi_err "No packages found matching \"%s\"\n" "$pkgNameToInstall"
		return 1
	else
		local fullPackageName="${matchingPackages[0]}"
		pi_log "Selected package: %s\n" "$fullPackageName"
		# Parse GitHub repository name with package name
		local user="${fullPackageName%%/*}"
		local p="${fullPackageName#*/}"

		# Download README.md file
		$dApp -O README.md "https://raw.githubusercontent.com/$user/$p/master/README.md"
		[ -f "README.md" ] || { pi_err "Could not find any README.md in the repository\n"; exit 1; }
		# Extract installation expression from tag
		# Use gsed to overcome BSD sed ignore-case limitations
		# Ignore Smalltalk expressions past the first dot
		installExpr=$(gsed -n '/^```smalltalk/I,/\.$/ p; /\]\./q' < README.md | gsed '/^```/ d;/^spec/I d')
		if [ -z "$installExpr" ]; then
			pi_err "PI-compatible Smalltalk install expression not found\n"
			rm -f README.md
			return 1
		fi
		fullInstallExpr="${installExpr}"
		# Download and install Pharo image if not present
		install_pharo "$imageName"
		# Save image after each Metacello package installation
		pi_log "Install command: ./pharo --headless %s eval --save \"%s\"" "$imageName" "$fullInstallExpr"
		./pharo --headless "$imageName" eval --save "$fullInstallExpr"
		# Remove README.md file
		rm -f README.md
		return 0
	fi
}

# List packages in cache
list_github_packages () {
	# Parse JSON file
	jq -jr ${jqListOptions} \
		"${cacheDir}"/*.js \
		| column -s'|' -t -c 500 \
		| LC_ALL='C' sort -t$'-' -i -b -k1,2 -f
}
