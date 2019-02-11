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
install_pharo () {
	silentMode=1
	findDistributionID
	case "$os" in
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
			echo_nline "Installing Pharo from get.pharo.org"
			dlPharo
			;;
	esac
}

#################################
## Pharo Installation Section
#################################
dlPharo () {
	silentMode=0
	echo_line "Checking Pharo installation in the current directory..."
	if [ ! -f "$imageName" ]; then
		echo_nline "not found"
		echo_line "Downloading Pharo (stable version)..."
#		exec $dApp $dPharoParams get.pharo.org/$pharoVersion+vm | bash
		exec $dApp $dPharoParams $zeroConfUrl | bash
	else
		echo_line "found $imageName in the current directory"
	fi

	if [ ! -f pharo ]; then
		echo_nline "Try again. Pharo was not downloaded correctly, exiting"
		exit 1
	fi
}
