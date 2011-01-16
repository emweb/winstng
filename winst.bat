@echo *******************************************************
@echo *                  Wt bootstrapper                    *
@echo *******************************************************

@echo OFF
@IF EXIST devutil GOTO MKDIRDOWNLOADS
@mkdir devutil

:MKDIRDOWNLOADS
@IF EXIST downloads GOTO MKDIRBUILD
@mkdir downloads

:MKDIRBUILD
@IF EXIST build GOTO WGET
@mkdir build

:WGET
@echo Downloading wget...

IF EXIST downloads\wget.exe GOTO DOWNLOAD
@echo open ftp.kfki.hu >> downloads\curl.ftp
@echo anonymous >> downloads\curl.ftp
@echo pass ano@nymo.us >> downloads\curl.ftp
@echo binary >> downloads\curl.ftp
@echo get /pub/w2/wget.exe downloads/wget.exe >> downloads\curl.ftp
@echo close >> downloads\curl.ftp

@echo quit >> downloads\curl.ftp

@ftp -s:downloads\curl.ftp

:DOWNLOAD
@cd downloads

:DOWNLOADUNZIP
@echo Downloading unzip...
IF EXIST unz600xn.exe GOTO DOWNLOADCMAKE
@wget -N -c ftp://ftp.info-zip.org/pub/infozip/win32/unz600xn.exe

:DOWNLOADCMAKE
@echo Downloading CMake...
IF EXIST cmake-2.8.4-rc1-win32-x86.zip GOTO UNPACK
REM @wget -N -c http://www.cmake.org/files/v2.8/cmake-2.8.4-rc1-win32-x86.zip
@wget -N -c http://www.cmake.org/files/vCVS/cmake-2.8.3.20110115-gf8614-win32-x86.zip

:UNPACK
@cd ..\devutil
@IF %1=="fetch" GOTO :BOOTSTRAP

:SETUPUNZIP
@echo Setting up unzip...
@IF EXIST unzip.exe GOTO SETUPCMAKE
@..\downloads\unz600xn.exe -o

:SETUPCMAKE
@echo Setting up CMake...
@IF EXIST ..\bin\cmake.exe GOTO BOOTSTRAP
@unzip ..\downloads\cmake-2.8.4-rc1-win32-x86.zip
@xcopy /Y /S cmake-2.8.4-rc1-win32-x86\*.* ..
@rd /q /s cmake-2.8.4-rc1-win32-x86

:BOOTSTRAP
cd ..\build
@echo Bootstrapping...

REM IF ""%1""=="" GOTO NOGENERATOR

@echo on
REM Fails if %1=="fetch"
@IF "%1"=="fetch" (SHIFT
..\bin\cmake -DFETCH_ONLY:BOOL=1 %* ..) ELSE (..\bin\cmake %* ..)

REM :NOGENERATOR
REM @echo on
REM ..\bin\cmake ..
