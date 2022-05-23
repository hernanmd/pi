[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# Table of Contents

- [Description](#description)
- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
  - [Notes](#notes)
  - [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contribute](#contribute)
- [Change Log](./CHANGELOG.md)
- [Develop](#develop)
- [License](./LICENSE)

# Description

Pharo Install - A command-line tool for installing [Pharo Smalltalk](https://www.pharo.org) packages.

PI is a MIT-pip-like application installer for Pharo Smalltalk. Copy & pasting install scripts found in forums or the web is an easy method, but it’s also time consuming because of the manual interaction, and hard to make the process reproducible.

PI turns copy & paste Smalltalk (Metacello Configurations) install scripts into shell one-liners which works on Unix/Linux, MacOS and Windows (MinGW64/MSYS). 

PI automatically retrieve and parse Pharo GitHub repository information, and also downloads the latest stable Pharo image and virtual machine if none is found in the current directory. It also supports installing multiple packages at once.

# Requirements

  - bash or zsh
  - curl or wget
  - jq (a command line JSON processor)
  - gsed

# Installation

The first step is to download the package from a command line terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hernanmd/pi/master/install.sh)"
```

The next step is to configure your PATH variable to find the pi command. To find which shell you are using now, type:

```bash
echo $0
```

To check the contents of the PATH variable:

```bash
env | grep -i path
```

## bash users

For one shell session:
```bash
export PATH=$HOME/.pi/pi/bin:$PATH
```
and you're done.

To persist usage between multiple shell sessions:
```bash
echo "export PATH=\$HOME/.pi/pi/bin:\$PATH" >> ~/.profile 
```

To see the effect, do:
```bash
source ~/.profile
```
in the same tab or open a new tab.

## zsh users

For one shell session:
```bash
path+=$HOME/.pi/pi/bin
```
and you're done.

To persist usage between multiple shell sessions:
```bash
echo -n 'export PATH=\$HOME/.pi/pi/bin:\$PATH' >> ~/.zshrc
```

To see the effect, do:
```bash
source ~/.zshrc
```
in the same tab or open a new tab.

# Features

  - PI can install and list packages from GitHub repositories.
  - If the Github repository has "pharo" as topic, it will be listed.
  - It works with curl or wget.
  - Supports case-insensitive searching for package names or developer user name.
  - The "image" option download the current Pharo "stable" version to the current working directory.

# Usage

GitHub repositories must contain a README.md file and have "pharo" specified as topic. Pi parses the README.md file and stops on the first smalltalk expression enclosed with backticks. This expression must contain an installation script in a Pharo image, i.e. that starts with Metacello. If the current directory already contains a Pharo image, PI will use that image.

## Examples

### Installing

Installing NeoCSV package:
```bash
pi install NeoCSV
```

Installing multiple packages:
```bash
pi install Diacritics ISO3166 StringExtensions
```

### Listing

List packages from GitHub
```bash
pi list
```

### Searching

Search in GitHub repositories:

```bash
pi search pillar
```

# Troubleshooting

If you experiment problems with pi, please run the collect environment script: 

```bash
./runPiCollectEnv
```

And open an issue with the output in the [Issue Tracker](https://github.com/hernanmd/pi/issues)).

You can obtain the pi version with:

```bash
pi version
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

# Develop

## To add tests
  
  - Have a look at [bats](https://github.com/bats-core/bats-core).
  - Check the .bats files in the tests directory
  
## To deploy a new release
  
  - Install [release-it](https://www.npmjs.com/package/release-it)
  - Copy or setup a [GitHub token](https://github.com/settings/tokens)
  - Evaluate `export GITHUB_TOKEN=...` with the coped token as value. Alternatively, log-in to your GitHub account with your web browser and release-it will authenticate.

