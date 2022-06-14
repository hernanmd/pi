[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# Table of Contents

- [Description](#description)
- [Demo](#demo)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Bash users](#bash-users)
  - [Zsh users](#zsh-users)
- [Features](#features)
- [Usage](#usage)
  - [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contribute](#contribute)
- [Change Log](./CHANGELOG.md)
- [Develop](#develop)
- [License](./LICENSE)

# Description

Pharo Install - A command-line tool for installing [Pharo Smalltalk](https://www.pharo.org) packages.

PI is a MIT-pip-like application installer for Pharo Smalltalk. Copy & pasting Pharo install scripts found in forums or the web is an easy method, but it’s also time consuming because of the manual interaction, and hard to make the process reproducible.

PI turns copy & paste [Metacello](https://github.com/Metacello/metacello) install scripts into shell one-liners which works on Unix/Linux, MacOS and Windows (MinGW64/MSYS). 

PI automatically retrieves and parses Pharo GitHub repository information, and also downloads the latest stable Pharo image and virtual machine if none is found in the current directory. It also supports installing multiple packages at once.

# Demo

![pi-session](https://user-images.githubusercontent.com/4825959/173497407-e99cad9f-38ae-4b34-8615-92dbbad7a225.gif)

# Requirements

  - bash or zsh
  - curl or wget
  - jq (a command line JSON processor)
    - Install for MSYS users: `pacman -Suy jq`
    - Install for Linux users: `apt install jq` or `yum install jq` or `dnf install jq` etc.
    - Install for macOS users: `brew install jq`
  - gsed 
    - Install for MSYS users: `ln /usr/bin/sed.exe /usr/local/bin/gsed`
    - Install for Linux users: `ln /usr/bin/sed /usr/local/bin/gsed`
    - Install for macOS users: `brew install gsed`

# Installation

The first step is to download the package from a command line terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hernanmd/pi/master/install.sh)"
```

The next step is to configure your PATH variable to find the pi command. To find which shell you are using now, type:

```bash
echo $0
```

## bash users

To persist usage between multiple shell sessions:
```bash
echo "export PATH=$HOME/.pi/pi/bin:$PATH" >> ~/.bash_profile 
source ~/.bash_profile
```

## zsh users

To persist usage between multiple shell sessions:
```bash
echo -n 'export PATH=$HOME/.pi/pi/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

# Features

  - PI can install and list packages from GitHub repositories.
  - If the Github repository has "pharo" as topic, it will be listed.
  - It works with curl or wget.
  - Supports case-insensitive searching for package names or developer user name.
  - The "image" option download the current Pharo "stable" version to the current working directory.

# Usage

Installable packages must contain:

  - A Github README.md file
  - "pharo" specified as topic. 
  - A Metacello installation script ending with a dot ".".
  
If the current directory already contains a Pharo image, PI will use that image, otherwise it will download a new stable image.

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
pi search microdown
```

Output may contain multiple repositories

```bash
pi search magritte
GitHub: peteruhnak/xml-magritte-generator
GitHub: philippeback/Magritte3Doc
GitHub: grype/Magritte-Swift
GitHub: hernanmd/Seaside-Magritte-Voyage
GitHub: hernanmd/Seaside-Bootstrap-Magritte-Voyage
GitHub: udoschneider/BootstrapMagritte
```

in that case, disambiguate specifying <owner>/<repository_name>, ex:

```bash
pi install grype/Magritte-Swift
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
  - Ensure NVM is installed and accessible running: `source ~/.nvm/nvm.sh`
  - To interactively deploy  run `./deploy.sh`
