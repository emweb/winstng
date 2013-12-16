REM could not escape the '=' sign in cmake
msbuild out/skia.sln /target:skia_lib /p:Configuration=%1
