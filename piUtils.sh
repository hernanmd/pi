#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

#################################
## Helper Functions
#################################

# Echo parameter text without carriage return/new line
echo_line () {
	[ "$silentMode" == 0 ] && echo -n "$1"
}

# Echo parameter text with carriage return/new line
echo_nline () {
	[ "$silentMode" == 0 ] && echo "$1"
}

# Returns 0 if command was found in the current system, 1 otherwise
cmdExists () {
    type "$1" &> /dev/null || [ -f "$1" ];
	return $?
}

trim_both () {
	echo -e "${1}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

setDownloadApp () {
	# echo_line "Checking for wget or curl..."
	if cmdExists wget ; then
		# echo_nline "wget found..."
		dApp="wget --show-progress --progress=bar:force:noscroll -q --no-check-certificate "
		dListParams="-O $stHubPkgIndexFile"
		dPharoParams="-O-"
	elif cmdExists curl ; then
			# echo_nline "curl found..."
			dApp="curl -s "
			dListParams="-o $stHubPkgIndexFile"
			dPharoParams=""
		else
			echo_nline "I require wget or curl, but it's not installed. (brew install wget?) Aborting."
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

	echo_nline "Downloading 7-Zip..."
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

downloadJQ () {
	if ! cmdExists jq && [ ! -x ./jq ]; then
		# wget http://stedolan.github.io/jq/download/linux32/jq (32-bit system)
		echo_nline "Downloading jq..."
		case "$OSTYPE" in
			solaris*)
				echo_line "Solaris seems not supported by jq. See https://stedolan.github.io/jq/ for details"
				exit 1
				;;
			darwin*)
				$dApp https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64
				mv jq-osx-amd64 jq
				chmod +x ./jq
				;;
			linux*)
				$dApp http://stedolan.github.io/jq/download/linux64/jq
				chmod +x ./jq
				;;
			bsd*)
				echo_line "BSD seems not supported by jq. See https://stedolan.github.io/jq/ for details"
				exit 1
				;;
			msys*)
				$dApp -O jq.exe https://github.com/stedolan/jq/releases/download/jq-1.5/jq-win64.exe
				;;
			*)
				echo "unknown: $OSTYPE"
				;;
		esac
	fi
}

findDistributionID () {
	# Find our distribution or OS
	echo_nline "Current OS is: "
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
	echo_nline "Found $os"
}