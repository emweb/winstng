winstng 0.1
  - a witty bootstrapper

(c) 2011 Pau Garcia i Quiles <pgquiles@elpauer.org>

WHAT AND WHY

Wt depends on a number of libraries which are not easily buildable, such as 
Boost, PostgreSQL, MySQL, etc. On Windows, in particular, the situation is not 
good. winstng also downloads and bootstraps CMake.

winstng is a bootstrapping script for Wt inspired by Emweb's own winst script.

winstng downloads and builds all the dependencies Wt requires, and Wt itself. 
Everything is installed in a self-contained, user-owned directory.

REQUIREMENTS

* Windows: a C++ compiler

* Unix: bash and a C++ compiler. On Linux, also wget.

Administrator/root permissions are not needed

USAGE

Windows
--------

Unpack the tarball and run "winst" to download and bootstrap. In the 'build' 
directory, run "nmake".

"winst /?" shows help

"winst fetch" downloads the dependencies in a "downloads" directory. Useful if 
you want to download in your machine and then build on another machine.
Dependencies for Windows builds must be downloaded on a Windows machine.


Unix
-----

Unpack the tarball and run "./winst". Change to the 'build' directory and 
run 'make'.

"./winst help", "./winst --help" or "./winst -h" shows help

"./winst fetch", "./winst --fetch" or "./winst -f" downloads the dependencies 
in a "downloads" directory. Useful if you want to download in your machine and 
then build on another machine. Dependencies for Unix builds must be downloaded 
on a Unix machine.

EXAMPLES

winstng installs wrapper scripts to run the examples:

* Windows: installed in 'bin'

* Unix: installed in 'lib/Wt/examples/<example subdir>


KNOWN ISSUES

- Cross-compilation does not work (yet). To make it work, CMake and GNU patch 
  have to be built for the host platform instead of the target platform.

- On Unix, some libraries which use autotools are built with rpath, which means 
  you cannot move the winst directory to some other place. This will be solved 
  with chrpath soon. 

  This problem does not exist on Windows: you can move the winst directory 
  with all its contents to wherever you want (but make sure you preserve the 
  hierarchy!)

- At this moment, it does not work with MSVC2010 solutions due to a CMake 
  limitation.

- On Windows, winstng does not build from source for everything: GNU patch, 
  CMake and PostgreSQL are downloaded as binaries because building them implies 
  a lot of hassle (setting up msys) the binaries available for 32-bit and 64-bit
  work fine.

- On Windows, GraphicsMagick is not available: public binaries are useless for 
  development (no headers or import libraries) and VisualMagick requires human 
  interaction. This will be fixed by making VisualMagick work from the command 
  line.

- On Windows, MySQL++ is not available (= hangman example not built) because it 
  uses a not-so-good build system (Bakefile) and, well, Emweb should really 
  port hangman to Wt Dbo.

- Not really an issue but worth noting: patches have DOS line-endings, otherwise 
  GNU patch on Windows crashes.

LICENSE

winst itself is under the MIT license.

The various patches have the same license as the software they apply for

Some patches are taken from the KDE on Windows project.



The MIT License

Copyright (c) 2011 Pau Garcia i Quiles <pgquiles@elpauer.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
