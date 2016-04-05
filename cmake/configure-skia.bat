REM could not escape the '=' sign in cmake
SET PATH=%1;%PATH%
cd %3
REM old skia uses skia_arch_width (32/64), new skia uses skia_arch_type (x86/x86_64)
SET GYP_DEFINES=skia_arch_width=%4 skia_arch_type=%5
REM SET "GYP_GENERATORS=ninja,msvs"
%6 %7 %8 %9 %10 -G msvs_version=%2
