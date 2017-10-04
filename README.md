# winstng

winstng is a tool to build binary releases of [Wt](https://www.webtoolkit.eu/wt). It is used by [Emweb](https://www.emweb.be) to create binary releases on Windows, along with its dependencies.

winstng was originally created by Pau Garcia i Quiles for both Windows and Linux, but only the Windows building functionality is currently maintained by Emweb.

You can download the binary builds from the [Wt releases page](https://github.com/emweb/wt/releases).

## Usage instructions on Windows

### Dependencies

* [NSIS](http://nsis.sourceforge.net/Main_Page). The `nsis.exe` executable must be installed in a location where CMake will find it. If NSIS is not installed in a standard location, you can add it to the path with `set Path=C:\path\to\nsis;%Path%`.
* For generation of documentation:
  * [Doxygen](http://www.stack.nl/~dimitri/doxygen/)
  * [Graphviz](http://www.graphviz.org/)
  * [Qt](https://info.qt.io/download-qt-for-application-development) (for qhelpgenerator)
* An installation of Microsoft Visual Studio 2015 or later for Wt 4, or Microsoft Visual Studio 2010 or later for Wt 3.

### Making a Wt build

These are the commands that Emweb uses to generate the Windows builds of Wt 4.

1. Start a command prompt with Visual Studio tools, e.g. "x64 Native Tools Command Prompt for VS 2017".
2. Navigate to the winstng source directory
3. - To build a Wt release build:  
     `winst.bat wtversion x.y.z -G "NMake Makefiles" "-DSTANDALONE_ASIO=ON"` (substitute x.y.z with the version of the Wt release)
   - To build a version of Wt from git:  
     `winst.bat git gitrepo https://github.com/emweb/wt.git wtversion x.y.z -G "NMake Makefiles" "-DSTANDALONE_ASIO=ON"`  
      Substitute x.y.z with the version of your choice. This has no effect on the used git commit, but changes the version number used in the name of the packages.
      You can also use `"-DWTGITTAG=abcdef..."` to build a specific commit or tag.
4. `cd build`
5. `nmake.exe package`: this will generate a `.zip` file and a `.exe` installer

The Wt 3 instructions are identical, but we can't build Wt 3 with standalone asio, so the `"-DSTANDALONE_ASIO=ON`" option is omitted.
