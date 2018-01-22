# Description
Pharo Install - A tool for installing Pharo Smalltalk packages

# Features

  - Listing supports only SmalltalkHub for now. 
  - Requires libxml2 (xmllint command).
  - Installs (only) Metacello Configurations from Catalog (command line handler: get) or SmalltalkHub (command line handler: config)
  - It works with curl or wget
  - Tested on Pharo >= 5.0 under Windows 8.1 (MinGW)

# Usage examples

Install BioSmalltalk stable

```bash
$ pi install biosmalltalk
```

Install BioSmalltalk development

```bash
$ pi install biosmalltalk dev
```

# License

This software is licensed under the MIT License.

Copyright Hernán Morales, 2017.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
