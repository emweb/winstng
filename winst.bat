@echo *******************************************************
@echo *                  Wt bootstrapper                    *
@echo *******************************************************

@IF NOT !%1!==!! (
@IF "%1"=="/?" ( 
@echo.
@echo Usage: 
@echo   %0 /?                       This help
@echo   %0 fetch                    Download dependencies, do not build anything now
@echo   %0 [CMake parameters]       Download and build Wt and its dependencies
@echo   %0 git [CMake parameters]   Download and build Wt -git version- and its dependencies
@echo.
@echo   Example: winst git -G "NMake Makefiles"
@echo.
@GOTO:EOF
)
)

@SET BASEDIR=%CD%
@SET BATDIR=%~dp0
@SET WGET_FILENAME=wget.exe
@SET WGET_FTP_SITE=ftp.kfki.hu
@SET WGET_FTP_DIRECTORY=/pub/w2

@SET UNZIP_SFX=unz600xn.exe
@SET UNZIP_FULLURL=http://www.mirrorservice.org/sites/ftp.info-zip.org/pub/infozip/win32/%UNZIP_SFX%

@SET WGET_FTP_PATH=%WGET_FTP_DIRECTORY%/%WGET_FILENAME%
@SET CMAKE_ZIP=cmake-2.8.11.2-win32-x86.zip
@SET CMAKE_FULLURL=http://www.cmake.org/files/v2.8/%CMAKE_ZIP%
@SET CMAKE_DIRECTORY=%BASEDIR%/downloads/cmake-2.8.11.2-win32-x86
@SET CMAKE_EXE=%CMAKE_DIRECTORY%/bin/cmake.exe
@SET CPACK_EXE=%CMAKE_DIRECTORY%/bin/cpack.exe

::@SET CMAKE_OPTIONS=--build

@SET PREFIX=%BASEDIR%\prefix

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

@IF EXIST "%BASEDIR%\downloads\%WGET_FILENAME%" GOTO DOWNLOAD
@echo open %WGET_FTP_SITE% >> "%BASEDIR%\downloads\curl.ftp"
@echo anonymous >> "%BASEDIR%\downloads\curl.ftp"
@echo pass ano@nymo.us >> "%BASEDIR%\downloads\curl.ftp"
@echo binary >> "%BASEDIR%\downloads\curl.ftp"
@echo get %WGET_FTP_PATH% %BASEDIR%\downloads/%WGET_FILENAME% >> "%BASEDIR%\downloads\curl.ftp"
@echo close >> "%BASEDIR%\downloads\curl.ftp"

@echo quit >> "%BASEDIR%\downloads\curl.ftp"

@ftp -s:"%BASEDIR%\downloads\curl.ftp"

:DOWNLOAD
@cd downloads

:DOWNLOADUNZIP
@echo Downloading unzip...
@IF EXIST %UNZIP_SFX% GOTO DOWNLOADCMAKE
@wget -N -c %UNZIP_FULLURL%

:DOWNLOADCMAKE
@echo Downloading CMake...
@IF EXIST %CMAKE_ZIP% GOTO INSTALLSTEP
@wget -N -c %CMAKE_FULLURL%

:INSTALLSTEP
@echo Setting up prerequisites...
@cd "%PREFIX%"

:INSTALLUNZIP
@echo Setting up unzip...
@IF EXIST unzip.exe GOTO INSTALLCMAKE
@"%BASEDIR%\downloads\%UNZIP_SFX%" -o

:INSTALLCMAKE
@echo Setting up CMake...
@IF EXIST "%CMAKE_EXE%" GOTO BOOTSTRAP
@unzip "%BASEDIR%\downloads\%CMAKE_ZIP%"
@rem xcopy /Y /S "%CMAKE_DIRECTORY%\*.*" "%PREFIX%\"
@rem rd /q /s "%CMAKE_DIRECTORY%"

:BOOTSTRAP
@echo Bootstrapping...

@echo on
@IF NOT [%1]==[] (
    @IF /I "%1"=="fetch" ( 
        SHIFT
        cd "%BASEDIR%\build"
        "%CMAKE_EXE%" -DFETCH_ONLY:BOOL=1 %* "%BATDIR%\cmake"
    ) ELSE (
        @IF /I "%1"=="git" (
            set WTGIT=-DWTGIT:BOOL=1
        ) ELSE (
            set WTGIT=-DWTGIT:BOOL=0
        )
        
        @IF EXIST "%BASEDIR%\build\fetch-only" (
            @rd /q /s "%BASEDIR%\build"
            @mkdir "%BASEDIR%\build"
            @cd "%BASEDIR%\build"
            "%CMAKE_EXE%" -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" %WTGIT% %* "%BATDIR%\cmake"
        ) ELSE (
            @IF EXIST %BASEDIR%\build\Nul (
                @cd "%BASEDIR%\build"
                "%CMAKE_EXE%" %CMAKE_OPTIONS% -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" %WTGIT% %* "%BATDIR%\cmake"
            )
        )
    )
) ELSE (
    @IF EXIST "%BASEDIR%\build\fetch-only" (
        @rd /q /s "%BASEDIR%\build"
        @mkdir "%BASEDIR%\build"
    )

    @cd "%BASEDIR%\build"
    "%CMAKE_EXE%" %CMAKE_OPTIONS% -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" %* "%BATDIR%\cmake"
)

@set PATH=..\prefix;..\prefix\bin;%PATH%

:: Required to workaround Assembla issue #20 (missing files in packages)
:: %CMAKE_EXE% %BATDIR%\cmake

:: Create packages
:: %CPACK_EXE% %BATDIR%\cmake
