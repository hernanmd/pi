readonly PI_VERSION="0.4.4"

readonly PI_HOME="$HOME/.pi"
readonly PI_REL="$HOME/pi/pi-$PI_VERSION.tar.gz"

readonly ERR_UNSUPPORTED_OS=1
readonly ERR_INVALID_USAGE=2

die() {
	local message="$1"
	local -i exit_code="${2:-1}"

	printf "%sError $exit_code: $message%s\n" "${RED}" "${NORMAL}" >&2
	exit $exit_code
}

get_latest_version() {
	basename "$(curl -s -o /dev/null -I -w "%{redirect_url}" https://github.com/hernanmd/pi/releases/latest)"
}

assignment() {
	local variable="${1:-}"
	local value="${2:-}"

	echo "$variable=\"$value\""
}

do_install() {
	mkdir -p "$(dirname "$PI_REL")"
	rm -f "$PI_REL"
	local self="${BASH_EXECUTION_STRING:-$(curl -sL https://raw.githubusercontent.com/hernanmd/pi/master/install.sh)}"
	echo "${self/$(assignment PI_VERSION)/$(assignment PI_VERSION "$(get_latest_version)")}" > "$PI_REL"
	tar zxvf "$PI_REL"
	chmod +x "$PI_REL"/pi
}

check_install() {
	[[ "$(type -t pi)" == "file" ]]
}

install_pi() {
	# Use colors, but only if connected to a terminal, and that terminal supports them.
	if command -v tput >/dev/null 2>&1; then
		ncolors=$(tput colors)
	fi
	if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
	  RED="$(tput setaf 1)"
	  GREEN="$(tput setaf 2)"
	  YELLOW="$(tput setaf 3)"
	  BLUE="$(tput setaf 4)"
	  BOLD="$(tput bold)"
	  NORMAL="$(tput sgr0)"
	else
	  RED=""
	  GREEN=""
	  YELLOW=""
	  BLUE=""
	  BOLD=""
	  NORMAL=""
	fi

	# Only enable exit-on-error after the non-critical colorization stuff,
	# which may fail on systems lacking tput or terminfo
	set -e

	printf "%sInstalling pi...%s\n" "${YELLOW}" "${NORMAL}"
	local os="$(uname)"
	case "$os" in
		(Linux | Darwin)
			[[ "$(whoami)" != "root" ]] || die "Don't install with sudo or as root"

			local -i upgrade=0
			check_install && upgrade=1

			do_install

			if ! check_install; then
				cat <<-EOF
					In order to make pi work, you need to add the following
					to your .bash_profile/.profile file:

					    export PATH="$HOME/bin:$PATH"

				EOF
			fi

			local version="$(get_latest_version)"
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
	echo '   ....is now $2!'
	echo 'Please look over pi help to access options.'
	echo ''
	echo 'p.s. If you like this work star it at https://github.com/hernanmd/pi'
	echo ''
	printf "${NORMAL}"
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
