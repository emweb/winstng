REM could not escape the '=' sign in cmake
SET PATH=%1;%PATH%
cd %3
SET GYP_DEFINES=skia_arch_width=%4
%5 %6 %7 %8 %9 -G msvs_version=%2
