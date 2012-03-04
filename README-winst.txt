winstng 0.2
  - a witty bootstrapper
    http://gitorious.org/winstng
    
(c) 2011-2012 Pau Garcia i Quiles <pgquiles@elpauer.org>


WHAT AND WHY

Wt ( http://webtoolkit.eu ) depends on a number of libraries which are not easily buildable, such as 
Boost, PostgreSQL, MySQL, etc. On Windows, in particular, the situation is not 
good. winstng also downloads and bootstraps CMake.

winstng is a bootstrapping script for Wt inspired by Emweb's own winst script.

winstng downloads and builds all the dependencies Wt requires, and Wt itself. 
Everything is installed in a self-contained, user-owned directory.

REQUIREMENTS

* Windows: a C++ compiler

* Unix: bash and a C++ compiler. On Linux, also wget.

Administrator/root permissions are not needed

To build the bleeding edge Wt, you also need Git *in path*.

USAGE
 
Windows
--------

Unpack the tarball and run "winst" to download and bootstrap. In the 'build' 
directory, run "nmake". You can pass CMake options to winst.

  > winst -G "NMake Makefiles"
  > nmake
  
"winst /?" shows help

"winst fetch" downloads the dependencies in a "downloads" directory. Useful if 
you want to download in your machine and then build on another machine.
Dependencies for Windows builds must be downloaded on a Windows machine.

"winst git" downloads Wt from git and builds it.

  > winst git -G "NMake Makefiles"
  > nmake

  
Unix
-----

Unpack the tarball and run "./winst". Change to the 'build' directory and 
run 'make'. You can pass CMake options to winst.

  $ tar xf winstng.tar.gz
  $ cd winstng
  $ ./winst
  $ cd build
  $ make

"./winst help", "./winst --help" or "./winst -h" shows help

"./winst fetch", "./winst --fetch" or "./winst -f" downloads the dependencies 
in a "downloads" directory. Useful if you want to download in your machine and 
then build on another machine. Dependencies for Unix builds must be downloaded 
on a Unix machine.

"winst git" downloads Wt from git and builds it.

  $ ./winst git -G "NMake Makefiles"
  $ cd build
  $ make

  
EXAMPLES

winstng installs wrapper scripts to run the examples:

* Windows: installed in 'bin'

* Unix: installed in 'lib/Wt/examples/<example subdir>

Wrapper scripts have the same name as the example but need no parameters (you 
can still pass parameters, if you want to). Examples are started in port 8080.


PLATFORMS

Tested on:

 - Windows XP SP3 32-bit with MSVC2010 SP1 and Windows SDK 7.1
 - Mac OS X 10.6.6 64-bit with XCode 3.2.5
 - Ubuntu Maverick 10.10 32-bit with gcc 4.4
 

KNOWN ISSUES

- Race conditions. Especially on Windows, when building some package, winstng 
  some times fails in the "download" stage when unpacking: 
  
  [ 27%] Performing download step (download, verify and extract) for 'libpng'
  CMake Error at libpng-stamp/libpng-download.cmake:17 (message):
  Command failed: 1

   'G:/winst/winstng/bin/cmake.exe' '-Dmake=' '-Dconfig=' '-P' 'G:/winst/winstng
   /build/libpng-prefix/src/libpng-stamp/libpng-download-impl.cmake'

  See also

    G:/winst/winstng/build/libpng-prefix/src/libpng-stamp/libpng-download-*.log

  NMAKE : fatal error U1077: 'G:\winst\winstng\bin\cmake.exe' : return code '0x1'
  Stop.
  NMAKE : fatal error U1077: '"C:\Program Files\Microsoft Visual Studio 10.0\VC\BI
  N\nmake.exe"' : return code '0x2'
  Stop.
  NMAKE : fatal error U1077: '"C:\Program Files\Microsoft Visual Studio 10.0\VC\BI
  N\nmake.exe"' : return code '0x2'
  Stop.

  There is no solution to this yet (it's a CMake issue with ExternalProject). For 
  now, if you see an error in a "download" step, just delete the offending package 
  prefix and run make again:
  
  G:\winst\winstng\build>rd /q /s libpng-prefix
  G:\winst\winstng\build>nmake

- Cross-compilation does not work (yet). To make it work, CMake, GNU patch and 
  bjam have to be built for the host platform instead of the target platform.

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

- On Windows, MySQL++ is not available (= hangman example not built) because 
  MySQL++ uses a not-so-good build system (Bakefile) and, well, hangman should 
  really be ported to use Wt Dbo.

- Not really an issue but worth noting: patches have DOS line-endings, otherwise 
  GNU patch crashes on Windows.


TODO

- Do not attempt to build everything but use find_package to locate existing 
  depenencies. If dependencies are not found, build them.

- Support more platforms

- Cross-compilation

LICENSE

winst itself is under the MIT license.

The various patches have the same license as the software they apply for

Most patches to provide a CMake build system are taken from the 
KDE on Windows project ( http://windows.kde.org ).


The MIT License

Copyright (c) 2011-2012 Pau Garcia i Quiles <pgquiles@elpauer.org>

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
