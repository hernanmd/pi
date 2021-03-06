#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

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
installPharo () {
	findDistributionID
	case "$os" in
		"arm64")
			zeroConfUrl="http://files.pharo.org/vm/pharo-spur64-headless/Darwin-arm64/latest.zip"
			dlPharoAppleSilicon
			;;
		"elementary" )
			ppa_install
			;;
		"CentOS*" | "RedHat*" )
			yum_install
			;;
		"Ubuntu*")
			ppa_install
			;;
		* )
			dlPharo
			;;
	esac
}

#################################
## Pharo Installation Section
#################################

# Returns true if Pharo is detected in the current working directory
isPharoInstalled () {
	if [[ -d Pharo.app ]] || [[ -d "pharo-vm" ]] && [[ -f Pharo.image ]] && [[ -f Pharo.changes ]]; then
		printf "Pharo found in current directory\n"
		return 0
	else
		printf "Pharo not found in current directory\n"
		return 1
	fi
}

dlPharo () {
	printf "Checking Pharo installation in the current directory...\n"
	if ! isPharoInstalled; then
		printf "Downloading Pharo...\n"
		exec $dApp $dPharoParams $zeroConfUrl | bash
	fi
	[[ ! isPharoInstalled ]] && { printf "Could not download Pharo, exiting\n"; exit 1; }
}

dlPharoAppleSilicon () {
	printf "Checking Pharo installation in the current directory...\n"
	if ! isPharoInstalled; then
		printf "Downloading Pharo...\n"
		exec $dApp $zeroConfUrl
		unzip latest.zip
		exec $dApp $dPharoParams get.pharo.org/64/90 | bash -
	fi
	[[ ! isPharoInstalled ]] && { printf "Could not download Pharo, exiting\n"; exit 1; }	
}