#!/bin/bash
#
# pi - Pharo Install - A MIT-pip-like library for Pharo Smalltalk
#

source piUtils.sh

#################################################
# libXML / xmllint functions
#################################################

installLibXMLMac () {
	local libXMLMac1="combo-2007-10-07.dmg.gz"
	local libXMLMac2="combo-20031108.dmg.gz"
	local libXMLMacURL="https://www.explain.com.au/download/"
	# Using Leopard? xmllint and libxml2 version 2.6.16 are built-in! xsltproc and libxslt version 1.1.12 are also included.
	# Using Tiger? xmllint and libxml2 version 2.6.16 are built-in! xsltproc and libxslt version 1.1.11 are also included.
	# Using Panther? xmllint and libxml2 version 2.5.4 are built-in! Even better, 10.3.9 has libxml2-2.6.16 and libxslt-1.1.9 built-in!
	$dApp "$libXMLMacURL/$libXMLMac1"
	$dApp "$libXMLMacURL/$libXMLMac2"
	# From https://www.explain.com.au/oss/libxml2xslt.html
	sudo mkdir -p /usr/local/bin
	cd /usr/local/bin || exit
	sudo ln -s /Library/Frameworks/libxml.framework/Resources/Scripts/*
	sudo ln -s /Library/Frameworks/libxslt.framework/Resources/Scripts/*

	sudo mkdir -p /usr/local/include
	cd /usr/local/include || exit
	sudo ln -s /Library/Frameworks/libxml.framework/Headers/*
	sudo ln -s /Library/Frameworks/libxslt.framework/Headers/*
	sudo ln -s /Library/Frameworks/libexslt.framework/Headers/*

	mkdir -p /usr/local/lib
	cd /usr/local/lib || exit
	sudo ln -s /Library/Frameworks/libxml.framework/libxml libxml2.dylib
	sudo ln -s /Library/Frameworks/libxslt.framework/libxslt libxslt.dylib
	sudo ln -s /Library/Frameworks/libexslt.framework/libxslt libexslt.dylib

	sudo mkdir -p /usr/local/man/man1
	sudo mkdir -p /usr/local/man/man3
	echo "export PATH=/usr/local/bin:$PATH" >> "$HOME"/.bashrc
	echo "export MANPATH=/usr/local/man:$MANPATH" >> "$HOME"/.bashrc
	source "$HOME"/.bashrc
}

installLibXMLSolaris () {
	local libXMLSolarisURL="http://get.opencsw.org/now"
	pkgadd -d "$libXMLSolarisURL"
	/opt/csw/bin/pkgutil -U
	/opt/csw/bin/pkgutil -y -i libxml2_2
	/usr/sbin/pkgchk -L CSWlibxml2-2 # list files
}

installLibXMLMSYS () {
	local libXMLWin32="libxml2-2.7.8.win32.zip"
	local libXMLWin32URL="ftp://ftp.zlatkovic.com/libxml"
	local libXMLWin64="libxml2-2.9.3-win32-x86_64.7z"
	local libXMLWin64URL="ftp://ftp.zlatkovic.com/libxml/64bit/"

	echo_nline "Checking LibXML..."
	# Remove any previous download of ZIP file
	if is64Bit; then
		# Check if library installer already was downloaded
		if [ ! -f "$libXMLWin64" ]; then
			$dApp "$libXMLWin64URL/$libXMLWin64"
		fi
		# Download and install 7z to uncompress
		if [ ! -f "/c/Program\ Files\ \(x86\)/7-Zip" ]; then
			downloadWin7z
		fi
		echo_nline "Uncompressing libXML"
		/c/Program\ Files\ \(x86\)/7-Zip/7z.exe x "$libXMLWin64"
		# Copy to current directory
		cp -v "$libXMLWin64"/bin/* .
	else
		# Check if library installer already was downloaded
		if [ ! -f "$libXMLWin32" ]; then
			$dApp "$libXMLWin32URL/$libXMLWin32"
		fi
		unzip -u "$libXMLWin32"
		# Copy to current directory
		cp -v "$libXMLWin32"/bin/* .
	fi
}

downloadLibXML () {
	if ! cmdExists xmllint && [ ! -x ./xmllint ]; then
		echo_nline "Installing libxml2..."
		case "$OSTYPE" in
			solaris*)
				installLibXMLSolaris
				;;
			darwin*)
				installLibXMLMac
				;;
			linux*)
				echo "Should be implemented"
				;;
			bsd*)
				echo_line "BSD seems not supported by libxml2. See http://www.xmlsoft.org for details"
				;;
			msys*)
				installLibXMLMSYS
				;;
			*)
				echo "unknown: $OSTYPE"
				;;
		esac
		echo_nline "done"
	fi
}

# Search argument XPATH expression in HTML file
xpath() {
	if [ $# -ne 2 ]; then
		echo "Usage: xpath xpath file"
		return 1
	fi
	downloadLibXML
	# GitBash doesn't provide /usr/local/bin and cannot copy xmllint.exe to any PATH directory without permission denied
	if cmdExists xmllint; then
		xmllint --nonet --html --shell "$2" <<< "cat $1" | sed '/^\/ >/d;/^\ /d'
	else
		./xmllint --nonet --html --shell "$2" <<< "cat $1" | sed '/^\/ >/d;/^\ /d'
	fi
}