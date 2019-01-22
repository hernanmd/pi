[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# Description

Pharo Install - A tool for installing [Pharo Smalltalk](https://www.pharo.org) packages.

PI is a MIT-pip-like command line application installer for Pharo Smalltalk. Copy & pasting install scripts found in forums 
or the web is an easy method, but it’s also time consuming because of the manual interaction, and hard to make the process 
reproducible.

PI turns copy & paste Smalltalk (Metacello Configurations) install scripts into bash one-liners which works on Unix/Linux, 
MacOS and Windows (MinGW64/MSYS). PI automatically tries to download necessary dependencies for parsing both
[SmalltalkHub](https://www.smalltalkhub.com) and GitHub repositories lists, and also downloads the latest stable Pharo image and virtual machine if none is found in the current directory. It also supports installing multiple packages at once.

# Installation

curl users:
```bash
curl -O https://raw.githubusercontent.com/hernanmd/pi/master/pi
```

[wget](https://eternallybored.org/misc/wget/ "wget web site") users:
```bash
wget --no-cache --no-check-certificate https://raw.githubusercontent.com/hernanmd/pi/master/pi
```

Copy the executable script to a location included in the PATH environment variable:

> Note: If your system does not have /usr/local/bin, please mkdir before executing the following commands

```bash
chmod 755 pi
mv pi /usr/local/bin
```

# Features

  - Listing packages supports GitHub and SmalltalkHub repositories. 
  - Installing packages is supported for:
    - Metacello Configurations from Catalog (command line handler: get)
    - SmalltalkHub (command line handler: config)
    - GitHub (experimental)	
  - It works with curl or wget.
  - Supports case-insensitive searching for package names or developer user name.

# Usage notes

  - The "image" option defaults to the current Pharo "stable" version.
  - Assume only one image in a directory. Future version will add support for multiple images.
  - PI can query SmalltalkHub or GitHub for package names or usernames.
  - PI can install packages from SmalltalkHub (GitHub repositories is currently working progress).
  - Package and username search is case-sensitive.
  - For GitHub repositories:
    - If it has "pharo" as topic, it will be listed.
    - If jq (a command line JSON processor) is not available, it will be downloaded to the directory where pi was executed.
  - For SmalltalkHub repositories:
    - If xmllint is not available, it will be downloaded to the directory where pi was executed.

# Usage examples

## Installing

![Installing examples](images/ex_install.png)

## Listing

![Listing examples](images/ex_list.png)

## Searching

Search both in SmalltalkHub and GitHub repositories:

![Search examples](images/ex_search.png)

# Sample outputs

![Listing output from GitHub](images/list_1.png)

![Listing output from SmalltalkHub](images/list_2.png)

# Troubleshooting

If you experiment problems with pi, check first the versions of the following dependencies (copy & paste results when submitting an issue). PI is being developed in the following environment:

```bash
$ bash --version
GNU bash, version 4.4.23(1)-release (x86_64-pc-msys)
Copyright (C) 2016 Free Software Foundation, Inc.
```

```bash
$ git --version
git version 2.19.1
```

```bash
$ wget --version
GNU Wget 1.19.5 built on msys.

-cares +digest +gpgme +https +ipv6 +iri +large-file +metalink +nls
+ntlm +opie +psl +ssl/openssl
```

```bash
$ curl --version
curl 7.62.0 (x86_64-w64-mingw32) libcurl/7.62.0 OpenSSL/1.1.1a (WinSSL) zlib/1.2.11 brotli/1.0.7 libidn2/2.0.5 libpsl/0.20.2 (+libidn2/2.0.5) nghttp2/1.35.0
Release-Date: 2018-10-31
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp smtp smtps telnet tftp
Features: AsynchDNS IDN IPv6 Largefile SSPI Kerberos SPNEGO NTLM SSL libz brotli TLS-SRP HTTP2 HTTPS-proxy MultiSSL PSL Metalink
```

```bash
$ openssl version
OpenSSL 1.1.1a  20 Nov 2018
```


# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on 
GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.

If you'd like to make some changes yourself, see the following:

  - Fork this repository to your own GitHub account and then clone it to your local device
  - Edit the pi file with your favorite text editor.
  - Test PI.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

# ChangeLog

## 0.3.8

  - Fixed minor bug while downloading JQ on MSYS

## 0.3.7

  - Refactorings and style corrections

## 0.3.6

  - Remove the caching "feature" for Pharo GihHub packages.
  - For obtaining the count of GitHub packages download just one item which is enough.
  - Set download application once.
  - Make download applications silent.
  - Remove temprary JSON files from GitHub
  - Added help usage details

## 0.3.5

  - List Pharo GitHub package names.

## 0.3.4

  - Download GitHub package list paginating results (still needs fix & testing)
  - Minor enhacements

## 0.3.3

  - Removed unnecessary function checkLibXML()
  - Removed --no-check-certificate for the Pharo zeroconf website
  - Added specific platform function for installing libXML
  - Added function installLibXMLMSYS to install 32-bit and 64-bit versions depending on platform architecture 
  - All variable names now are lowercased
  - Started to implement function to install packages from GitHub

# ToDo

  - Timestamp output ?
  - Implement GitHub package installation
  - Install individual packages instead of only Metacello Configurations.
  - Uninstall packages

# License

This software is licensed under the MIT License.

Copyright Hernán Morales, 2018.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
