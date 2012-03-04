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

@SET WGET_FILENAME=wget.exe
@SET WGET_FTP_SITE=ftp.kfki.hu
@SET WGET_FTP_DIRECTORY=/pub/w2

@SET UNZIP_SFX=unz600xn.exe
@SET UNZIP_FULLURL=ftp://ftp.info-zip.org/pub/infozip/win32/%UNZIP_SFX%

@SET WGET_FTP_PATH=%WGET_FTP_DIRECTORY%/%WGET_FILENAME%
@SET CMAKE_ZIP=cmake-2.8.7-win32-x86.zip
@SET CMAKE_FULLURL=http://www.cmake.org/files/v2.8/%CMAKE_ZIP%
@SET CMAKE_DIRECTORY=cmake-2.8.7-win32-x86

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

@IF EXIST downloads\%WGET_FILENAME% GOTO DOWNLOAD
@echo open %WGET_FTP_SITE% >> downloads\curl.ftp
@echo anonymous >> downloads\curl.ftp
@echo pass ano@nymo.us >> downloads\curl.ftp
@echo binary >> downloads\curl.ftp
@echo get %WGET_FTP_PATH% downloads/%WGET_FILENAME% >> downloads\curl.ftp
@echo close >> downloads\curl.ftp

@echo quit >> downloads\curl.ftp

@ftp -s:downloads\curl.ftp

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
@cd ..\devutil

:INSTALLUNZIP
@echo Setting up unzip...
@IF EXIST unzip.exe GOTO INSTALLCMAKE
@..\downloads\%UNZIP_SFX% -o

:INSTALLCMAKE
@echo Setting up CMake...
@IF EXIST ..\bin\cmake.exe GOTO BOOTSTRAP
@unzip ..\downloads\%CMAKE_ZIP%
@xcopy /Y /S %CMAKE_DIRECTORY%\*.* ..
@rd /q /s %CMAKE_DIRECTORY%

:BOOTSTRAP
@echo Bootstrapping...

@echo on
@IF NOT [%1]==[] (
    @IF /I "%1"=="fetch" ( 
        SHIFT
        cd ..\build
        ..\bin\cmake -DFETCH_ONLY:BOOL=1 %* ..
    ) ELSE (
        @IF /I "%1"=="git" (
            set WTGIT=-DWTGIT:BOOL=1
        ) ELSE (
            set WTGIT=-DWTGIT:BOOL=0
        )
        echo WTGIT = %WTGIT%
        
        @IF EXIST ..\build\fetch-only (
            @rd /q /s ..\build
            @mkdir ..\build
            @cd ..\build
            ..\bin\cmake %WTGIT% %* ..
        ) ELSE (
            @IF EXIST ..\build\Nul (
                @cd ..\build
                ..\bin\cmake %WTGIT% %* ..
            )
        )
    )
) ELSE (
    @IF EXIST ..\build\fetch-only (
        @rd /q /s ..\build
        @mkdir ..\build
    )

    @cd ..\build
    ..\bin\cmake %* ..
)
