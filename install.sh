	{ # Prevent execution if this script was only partially downloaded

	oops() {
		echo "$0:" "$@" >&2
		exit 1
	}

	readonly ERR_INVALID_USAGE=2
	readonly tmpDir="$(mktemp -d -t pi-tarball-unpack.XXXXXXXXXX || \
			oops "Can't create temporary directory for downloading the Pi tarball")"

	require_util() {
		command -v "$1" > /dev/null 2>&1 ||
			oops "you do not have '$1' installed, which I need to $2"
	}

	die() {
		local message="$1"
		local -i exit_code="${2:-1}"

		printf "%sError $exit_code: $message%s\n" "${RED}" "${NORMAL}" >&2
		exit $exit_code
	}

	# Return the latest version URL in the form: https://github.com/hernanmd/pi/releases/tag/0.4.8
	get_latest_version() {
		basename "$(curl -s -o /dev/null -I -w "%{redirect_url}" https://github.com/hernanmd/pi/releases/latest)"
	}

	cleanup() {
		rm -rf "$tmpDir"
	}

	trap cleanup EXIT INT QUIT TERM

	do_install() {
		require_util curl "download the binary tarball"
		require_util tar "unpack the binary tarball"
		local latest
		local url
		local tarball
		local unpack

		latest="$(get_latest_version)"
		url="https://github.com/hernanmd/pi/archive/$latest.tar.gz"
		tarball="$tmpDir/pi.tar.gz"
		curl -sSL "$url" -o "$tarball" || oops "failed to download '$url'"
		unpack="$HOME/.pi"
		# Create a user local directory for pi
		mkdir -pv "$unpack"
		# Check previous installation and remove it to prevent Directory not empty on rename "
		printf "Checking previous installation on %s ..." "$unpack"
		[ -e "$unpack/pi-$latest" ] && { printf "\nRemoving previous installation..."; rm -rf "$unpack/pi-$latest"; }
		[ -e "$unpack/pi" ] && { printf "\nRemoving previous installation..."; rm -rf "$unpack/pi"; }
		printf "done\n"
		# Uncompress, untar and move to a non-versioned persistent user directory
		( cd "$unpack" && tar zxvf "$tarball" && mv -fv "pi-$latest" pi ) || oops "failed to unpack '$url'"
		# Check if main script was uncompressed succesfully
		script=$(echo "$unpack"/pi/bin/pi)
		[ -e "$script" ] || oops "main script is missing from the tarball!"
	}

	check_install() {
		[[ "$(type -t pi)" == "file" ]]
	}

	check_noroot() {
		[[ "$(whoami)" != "root" ]] || die "Don't install with sudo or as root"
	}

	install_pi() {
		local os

		# Use colors, but only if connected to a terminal, and that terminal supports them.
		if command -v tput >/dev/null 2>&1; then
			ncolors=$(tput colors)
		fi
		if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
		RED="$(tput setaf 1)"
		GREEN="$(tput setaf 2)"
		YELLOW="$(tput setaf 3)"
		NORMAL="$(tput sgr0)"
		else
		RED=""
		GREEN=""
		YELLOW=""
		NORMAL=""
		fi

		# Only enable exit-on-error after the non-critical colorization stuff,
		# which may fail on systems lacking tput or terminfo
		set -e

		printf "%sInstalling pi...%s\n" "${YELLOW}" "${NORMAL}"
		os="$(uname)"
		case "$os" in
			(Linux | Darwin | MINGW*)
				check_noroot

				local -i upgrade=0
				check_install && upgrade=1

				do_install

				if ! check_install; then
					cat <<-EOF
						${YELLOW}
						In order to make Pharo Install (pi) work, if you are using bash, you need to execute the following to add pi to your .bash_profile/.profile file:

							echo "export PATH=\$HOME/.pi/pi/bin:\$PATH" >> \$HOME/.profile

						If you are using zsh, execute the following to add pi to your path:

							path+=\$HOME/.pi/pi/bin
						${NORMAL}"
					EOF
				fi

				local version
				version="$(get_latest_version)"
				if [[ $upgrade -eq 1 ]]; then
					show_banner "$version" "upgraded"
				else
					show_banner "$version" "installed"
				fi

				;;
			(*)
				die "Unsupported OS: $os"
				;;
		esac
	}

	show_banner () {
		printf "${GREEN}"
		echo '            #     '
		echo '           ###    '
		echo '            #     '
		echo '                  '
		echo '   /###   ###     '
		echo '  / ###  / ###    '
		echo ' /   ###/   ##    '
		echo '##    ##    ##    '
		echo '##    ##    ##    '
		echo '##    ##    ##    '
		echo '##    ##    ##    '
		echo '##    ##    ##    '
		echo '#######     ### / '
		echo '######       ##/  '
		echo '##                '
		echo '##                '
		echo '##                '
		echo '##	'
		echo '   ....is now installed!'
		echo 'Please look over "pi help" command to access options.'
		echo ''
		printf "${NORMAL}"
		echo 'p.s. If you like this work star it at Pharo Install repository https://github.com/hernanmd/pi'
		echo ''
	}

	show_usage() {
		cat <<-EOF
			Usage: $(basename $0) COMMAND

			Commands:
				-h|--help                   Shows usage
				-u|--upgrade|--update       Upgrades pi to the latest version
				-v|--version		        Shows version
		EOF
	}

	usage() {
		show_usage
		exit $ERR_INVALID_USAGE
	}

	main() {
		[[ $# -gt 0 ]] || usage

		local command="${1:-}"
		case "$command" in
			("-h" | "--help")
				shift
				show_usage
				;;
			("-u" | "--upgrade" | "--update")
				shift
				install_pi
				;;
			(*)
				shift
				show_usage
				;;
		esac
	}

	if [[ -z "${BASH_SOURCE[0]:-}" ]]; then
		install_pi
	else
		main "$@"
	fi

	} # End of wrapping
