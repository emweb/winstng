This is a try-out for Wt binary releases. Report problems on the Wt forum.

Running the Wt examples
=======================
The binary package contains the Wt examples in compiled form and
in source form. To run an example, execute the .bat file in the
'bin' directory.

Building your own application
=============================
To compile your own application, set the following properties in your
MSVS project:
* In C/C++ -> General, Additional Include Directories:
  c:/location/of/wt-3.3.1/include
* In C/C++ -> Preprocessor, ensure that WIN32 is defined. Also define
  HPDF_DLL, which will allow you to generate pdf files.
* In Linker->General, Additional Library Directories:
  c:/location/of/wt-3.3.1/lib
* Go to Linker->Input. In the Additional Dependencies, fill out the Wt
  libraries you want to link to. At the topleft of the dialog, check the
  active Configuration. If it's Debug, link to wtd.lib, wthttpd.lib (and
  optionally wtdbod.lib, wtdbobackendXXXd.lib, ...). If it's release,
  link to wt.lib, wthttp.lib (and optionally wtdbo.lib, wtdbobackendXXX.lib).
  Notice that the debug libraries have a 'd' suffix. Be carefull. You need
  different libraries depending on the Release/Debug configuration, since
  it's not possible to mix different versions of the MSVC runtime libraries
  in one application.

If you want to run your fresh application, set these options:
* In the Debugging tab, set Command Arguments to
  --docroot . --http-address 0.0.0.0 --http-port 8080
* In the Debugging tab, set Environment to PATH=c:/location/of/wt-3.3.1/bin
  in order to find the DLLs required to run the executable.


Building the Wt examples
========================
The source code of the examples is in lib/Wt/examples. To compile the
examples from source, use CMake to generate an MSVS project, and then
build the generated project with MSVS. The CMakeLists.txt file to build
the examples yourself is located in lib/Wt/examples; it will create
projects for all subdirectories. The CMake project needs no configuration
to build.

Do not use a CMakeLists.txt from one individual example, that will not work.

