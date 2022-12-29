#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source "${BASH_SOURCE%/*}"/piUtils.sh
pharoLatest="110+vm"

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

# Install latest version of Pharo
linstall_pharo () {
	find_os_id
	case "$os" in
		"arm64")
			zeroConfUrl="http://files.pharo.org/vm/pharo-spur64-headless/Darwin-arm64/latest.zip"
			download_pharo_m1_latest
			;;
		* )
			download_pharo_latest
			;;
	esac
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
		pi_log "Pharo found in current directory\n"
		return 0
	else
		pi_log "Pharo not found\n"
		return 1
	fi
}

run_pharo () {
	if is_pharo_installed; then
		sh './pharo-ui' &
	fi
}

# Install a stable image and run Pharo
irun_pharo () {
	install_pharo
	run_pharo
}

# Install latest Pharo and run Pharo.image
lrun_pharo () {
	linstall_pharo
	run_pharo
}

# Trash pharo-local (requires trash utility) and run Pharo.image
trun_pharo () {
	if [[ -d "pharo-local" ]]; then
		trash pharo-local
	fi
	run_pharo
}

# Trash pharo-local (requires trash utility) and run Pharo.image
nrun_pharo () {
	dirname=$(date +%Y-%m-%d-%S)
	(mkdir -v "$dirname" && cd "$dirname" && irun_pharo) || pi_log "Cannot run Pharo Image"
}

# Install latest Pharo in a new timestamed directory and run Pharo.image
nlrun_pharo () {
	dirname=$(date +%Y-%m-%d-%S)
	(mkdir -v "$dirname" && cd "$dirname" && lrun_pharo) || pi_log "Cannot run Pharo Image"
}

download_pharo () {
	pi_log "Checking Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		pi_log "Downloading Pharo...\n"
		exec $dApp $dPharoParams $zeroConfUrl | bash
	fi
	[[ ! is_pharo_installed ]] && { pi_err "Could not download Pharo, exiting\n"; exit 1; }
}

download_pharo_latest () {
	pi_log "Checking latest Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		pi_log "Downloading latest Pharo...\n"
		exec $dApp $dPharoParams $zeroConfUrl/$pharoLatest | bash
	fi
	[[ ! is_pharo_installed ]] && { pi_err "Could not download latest Pharo, exiting\n"; exit 1; }
}

download_pharo_m1 () {
	pi_log "Checking Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		pi_log "Downloading Pharo...\n"
		exec $dApp $zeroConfUrl
		unzip latest.zip
		exec $dApp $dPharoParams get.pharo.org/64 | bash -
	fi
	[[ ! is_pharo_installed ]] && { pi_err "Could not download Pharo, exiting\n"; exit 1; }	
}

# Latest version of Pharo for ZeroConf download
download_pharo_m1_latest () {
	pi_log "Checking latest Pharo installation in the current directory...\n"
	if ! is_pharo_installed; then
		pi_log "Downloading latest Pharo...\n"
		exec $dApp $zeroConfUrl
		unzip latest.zip
		exec $dApp $dPharoParams get.pharo.org/64/$pharoLatest | bash -
	fi
	[[ ! is_pharo_installed ]] && { pi_err "Could not download latest Pharo, exiting\n"; exit 1; }	
}