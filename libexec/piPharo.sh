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
			dlPharo
			;;
	esac
}

#################################
## Pharo Installation Section
#################################

dlPharo () {
	# echo_line "Checking Pharo installation in the current directory..."
	[[ ! -f $imageName ]] && {
		printf "Downloading Pharo...\n"
		exec $dApp $dPharoParams $zeroConfUrl | bash
	}
	[[ ! -f pharo ]] && { printf "Could not download Pharo, exiting\n"; exit 1; }
}
