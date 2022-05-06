#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source "${BASH_SOURCE%/*}"/piUtils.sh

find_os_id () {
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
	elif [ "$(uname -p)" = "arm64" ]; then
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

#################################
## Pharo Installation Functions
#################################

# For Debian, Slackware and Ubuntu
# This function is currently not used
apt_install () {
	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo apt-get install libc6:i386 libssl1.0.0:i386 libfreetype6:i386
}

# For ElementaryOS
# This function is currently not used
ppa_install () {
	add-apt-repository ppa:pharo/stable
	apt-get update
	apt-get install pharo-vm-desktop
}

# For CentOS/RedHat
# This function is currently not used
yum_install () {
	yum install ld-linux.so.2 \
		glibc-devel.i686 \
		glibc-static.i686 \
		glibc-utils.i686 \
		libX11.i686 \
		libX11-devel.i686 \
		mesa-libGL.i686 \
		mesa-libGL-devel.i686 \
		libICE.i686 \
		libICE-devel.i686 \
		libSM.i686
}

# Prefer provider packages if distribution was found
install_pharo () {
	find_os_id
	case "$os" in
		"arm64")
			zeroConfUrl="http://files.pharo.org/vm/pharo-spur64-headless/Darwin-arm64/latest.zip"
			download_pharo_m1
			;;
		"CentOS*" | "RedHat*" )
			yum_install
			;;
		"Ubuntu*")
			ppa_install
			;;
		* )
			download_pharo
			;;
	esac
}

#################################
## Pharo Installation Section
#################################

# Returns true if Pharo is detected in the current working directory
is_pharo_installed () {
	if [[ -d Pharo.app ]] || [[ -d "pharo-vm" ]] && [[ -f Pharo.image ]] && [[ -f Pharo.changes ]]; then
		printf "Pharo found in current directory\n"
		return 0
	else
		printf "Pharo not found\n"
		return 1
	fi
}

run_pharo () {
	if is_pharo_installed; then
		sh './pharo-ui' &
	fi
}

download_pharo () {
	printf "Checking Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		printf "Downloading Pharo...\n"
		exec $dApp $dPharoParams $zeroConfUrl | bash
	fi
	[[ ! is_pharo_installed ]] && { err "Could not download Pharo, exiting\n"; exit 1; }
}

download_pharo_m1 () {
	printf "Checking Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		printf "Downloading Pharo...\n"
		exec $dApp $zeroConfUrl
		unzip latest.zip
		exec $dApp $dPharoParams get.pharo.org/64 | bash -
	fi
	[[ ! is_pharo_installed ]] && { err "Could not download Pharo, exiting\n"; exit 1; }	
}