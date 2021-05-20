#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#################################
## Helper Functions
#################################

#function finish {
  # Your cleanup code here
  # printf "Finished\n"
#}
#trap finish EXIT

# Returns 0 if command was found in the current system, 1 otherwise
cmdExists () {
	type "$1" &> /dev/null || [ -f "$1" ];
	return $?
}

cacheNotEmpty () {
	[[ -z "$(find "${cacheDir}" -maxdepth 0 -type d -empty 2>/dev/null)" ]]
	return $?
}

trim_both () {
	echo -e "${1}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# Remove cache directory contents
removeCacheDir () {
	if ! cacheNotEmpty; then
		 printf "Cache is empty\n"
		 exit 1
	else
		[[ -d ${cacheDir} ]] && cacheNotEmpty && rm ${cacheDir}/* && printf "Cache successfully cleaned\n"
	fi
}

initApp () {
	# Create cache directory if does not exist
	[[ -d ${cacheDir} ]] || mkdir ${cacheDir}
	# Set download application (wget or curl)
	if cmdExists wget ; then
		dApp="wget --progress=bar:force:noscroll -q --no-check-certificate "
		dListParams="-O $stHubPkgIndexFile"
		dPharoParams="-O-"
	elif cmdExists curl ; then
			dApp="curl -s "
			dListParams="-o $stHubPkgIndexFile"
			dPharoParams=""
		else
			printf "I require wget or curl, but it's not installed. Aborting.\n"
			exit 1
	fi
}

is64Bit () {
	[ "$(uname -m)" == "x86_64" ];
	return $?
}

downloadWin7z () {
	local zip7Win64Exec="7z1801-x64.exe"
	local zip7Win64URL="https://www.7-zip.org/a/$zip7Win64Exec"

	local zip7Win32Exec="7z1801.exe"
	local zip7Win32URL="https://www.7-zip.org/a/$zip7Win32Exec"

	printf "Downloading 7-Zip...\n"
	if is64Bit; then
		if [ ! -f "$zip7Win64Exec" ]; then
			$dApp "$zip7Win64URL"
		fi
		if [ ! -f /c/Program\ Files\ \(x86\)/7-Zip/7z.exe ]; then
			# Install 7z
			exec ./$zip7Win64Exec
		fi
	else
		if [ ! -f $zip7Win32Exec ]; then
			$dApp "$zip7Win32URL"
		fi
		# Install 7z
		exec ./$zip7Win32Exec
	fi
}

findDistributionID () {
	# Find our distribution or OS
	# printf "Current OS is: "
	if [ -f /etc/os-release ]; then
		# freedesktop.org and systemd
		. /etc/os-release
		os="$NAME"
		ver="$VERSION_ID"
	elif type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		os=$(lsb_release -si)
		ver=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
		# For some versions of Debian/Ubuntu without lsb_release command
		. /etc/lsb-release
		os="$DISTRIB_ID"
		ver="$DISTRIB_RELEASE"
	elif $(uname -p) == "arm64"; then
		os=$(uname -p)
		ver=$(uname -r)
	elif [ -f /etc/debian_version ]; then
		# Older Debian/Ubuntu/etc.
		os="Debian"
		ver=$(cat /etc/debian_version)
	elif [ -f /etc/SuSe-release ]; then
		# Older SuSE/etc.
		os="SuSE"
	elif [ -f /etc/redhat-release ]; then
		# Older Red Hat, CentOS, etc.
		os="RedHat"
	else
		# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
		os=$(uname -s)
		ver=$(uname -r)
	fi
	# printf "$os\n"
}
