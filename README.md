# Description

Pharo Install - A tool for installing Pharo Smalltalk packages.

PI is a MIT-pip-like library for Pharo Smalltalk.

# Features

  - Listing supports only SmalltalkHub for now. 
  - Installs (only) Metacello Configurations from Catalog (command line handler: get) or SmalltalkHub (command line handler: config)
  - It works with curl or wget

# Usage notes

  - The "install" option defaults to the current Pharo "stable" version. 
  - PI can query SmalltalkHub or GitHub. 
  - PI can install packages from SmalltalkHub (working on GitHub repositories).
  - Package search is case-sensitive.
  - For GitHub repositories: 
  - - If it has "pharo" as topic, then it will be listed.
  - - If jq is not available, it will be downloaded to the directory where pi was executed.
  - For SmalltalkHub repositories: 
  - - Requires libxml2 (xmllint command).
  

# Usage examples

List SmalltalkHub packages:

```bash
$ pi listsh
```

List GitHub packages:

```bash
$ pi listgh
```

Install BioSmalltalk stable:

```bash
$ pi install biosmalltalk
```

Install multiple packages at once:

```bash
$ pi install Diacritics ISO3166 StringExtensions
```

# Sample outputs

## Listing from GitHub

```bash
$ ./pi listgh
"SquareBracketAssociates/UpdatedPharoByExample"
"OpenSmalltalk/opensmalltalk-vm"
"pharo-project/pharo"
"pharo-vcs/iceberg"
"SquareBracketAssociates/EnterprisePharo"
"SquareBracketAssociates/NumericalMethods"
"PolyMathOrg/PolyMath"
...
```

## Listing from SmalltalkHub

```bash
$ ./pi listsh
15Puzzle/OlesDobosevych
2048Game/PierreChanson
3DaysVM/ClementBera
528-TicTakToe/johnmcconnell
...
```

# ToDo

  - Timestamp output
  - "search" option
  - Implement GitHub package installation

# License

This software is licensed under the MIT License.

Copyright Hernán Morales, 2018.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
