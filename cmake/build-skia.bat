REM could not escape the '=' sign in cmake
REM MSVS2010 installation is easily broken so that msbuild does not work
REM msbuild out/gyp/skia_lib.sln /target:Build /p:Configuration=%1
devenv.com out/gyp/skia_lib.sln /Build %1
