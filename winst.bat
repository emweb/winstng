@echo *******************************************************
@echo *                  Wt bootstrapper                    *
@echo *******************************************************

setlocal

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

@rem Parse command line
@set WTGIT=-DWTGIT:BOOL=OFF
:arg_loop
@IF "%~1" neq "" (
  @IF /I "%~1"=="fetch" (
    SET FETCHONLY=1
  ) ELSE (
    @IF /I "%~1"=="git" (
      set WTGIT=-DWTGIT:BOOL=ON
      echo Using git version of Wt
    ) ELSE (
      @IF /I "%~1"=="gitrepo" (
        set WTGITREPO=-DWTGITREPO:STRING=%2
        echo Using git repository %2
        SHIFT
      ) ELSE (
        @IF /I "%~1"=="wtversion" (
          set WTVERSION=-DWT_VERSION:STRING=%2
          echo Using wt version %2
          SHIFT
        ) ELSE (
          set CMAKE_ARGS=%CMAKE_ARGS% %1
        )
      )
    )
  )
  SHIFT
  goto :arg_loop
)

@SET BASEDIR=%CD%
@SET BATDIR=%~dp0
@SET WGET_FILENAME=wget.exe
@SET WGET_URL=https://eternallybored.org/misc/wget/1.20.3/64/wget.exe

@IF EXIST downloaddir.txt (SET /p DOWNLOADS=<downloaddir.txt) else (SET DOWNLOADS=%BASEDIR%\downloads)
@echo Downloading into %DOWNLOADS%

@SET CMAKE_VERSION=3.21.4
@SET CMAKE_ZIP=cmake-%CMAKE_VERSION%-windows-i386.zip
@SET CMAKE_FULLURL=https://www.cmake.org/files/v3.21/%CMAKE_ZIP%
@SET CMAKE_DIRECTORY=%BASEDIR%/prefix/cmake-%CMAKE_VERSION%-windows-i386
@SET CMAKE_EXE=%CMAKE_DIRECTORY%/bin/cmake.exe
@SET CPACK_EXE=%CMAKE_DIRECTORY%/bin/cpack.exe

::@SET CMAKE_OPTIONS=--build

@SET PREFIX=%BASEDIR%\prefix

@IF EXIST prefix\bin GOTO MKDIRDOWNLOADS
@mkdir prefix
@mkdir prefix\bin

:MKDIRDOWNLOADS
@IF EXIST %DOWNLOADS% GOTO MKDIRBUILD
@mkdir %DOWNLOADS%

:MKDIRBUILD
@IF EXIST build GOTO WGET
@mkdir build

:: Downloading CMake with PowerShell wouldn't work for some reason,
:: so we download wget with powershell, and then CMake with wget
:WGET
@echo Downloading wget...

@IF EXIST "%DOWNLOADS%\%WGET_FILENAME%" GOTO DOWNLOAD
@powershell -Command "(New-Object Net.WebClient).DownloadFile('%WGET_URL%', '%DOWNLOADS%\%WGET_FILENAME%')"

:DOWNLOAD
@cd %DOWNLOADS%

:DOWNLOADCMAKE
@echo Downloading CMake...
@IF EXIST %CMAKE_ZIP% GOTO INSTALLSTEP
@wget -N -c %CMAKE_FULLURL%

:INSTALLSTEP
@echo Setting up prerequisites...
@cd "%PREFIX%"

:INSTALLCMAKE
@echo Setting up CMake...
@IF EXIST "%CMAKE_EXE%" GOTO BOOTSTRAP
@cscript ..\unzip.vbs "%DOWNLOADS%\%CMAKE_ZIP%"
@rem xcopy /Y /S "%CMAKE_DIRECTORY%\*.*" "%PREFIX%\"
@rem rd /q /s "%CMAKE_DIRECTORY%"

:BOOTSTRAP

@set PATH=..\prefix;..\prefix\bin;%PATH%

@echo Bootstrapping...

@echo on
@IF NOT [%1]==[] (
    @IF /I "%FETCHONLY"=="1" (
        cd "%BASEDIR%\build"
        "%CMAKE_EXE%" -DWINST_DOWNLOADS_DIR:PATH="%DOWNLOADS%" -DFETCH_ONLY:BOOL=1 %WTGIT% %WTGITREPO% %WTVERSION% %CMAKE_ARGS% "%BATDIR%\cmake"
    ) ELSE (
        
        @IF EXIST "%BASEDIR%\build\fetch-only" (
            @rd /q /s "%BASEDIR%\build"
            @mkdir "%BASEDIR%\build"
            @cd "%BASEDIR%\build"
            "%CMAKE_EXE%" -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" -DWINST_DOWNLOADS_DIR:PATH="%DOWNLOADS%" %WTGIT% %WTGITREPO% %WTVERSION% %CMAKE_ARGS% "%BATDIR%\cmake"
        ) ELSE (
            @IF EXIST %BASEDIR%\build\Nul (
                @cd "%BASEDIR%\build"
                "%CMAKE_EXE%" %CMAKE_OPTIONS% -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" -DWINST_DOWNLOADS_DIR:PATH="%DOWNLOADS%" %WTGIT% %WTGITREPO% %WTVERSION% %CMAKE_ARGS% "%BATDIR%\cmake"
            )
        )
    )
) ELSE (
    @IF EXIST "%BASEDIR%\build\fetch-only" (
        @rd /q /s "%BASEDIR%\build"
        @mkdir "%BASEDIR%\build"
    )

    @cd "%BASEDIR%\build"
    "%CMAKE_EXE%" %CMAKE_OPTIONS% -DWINST_BASEDIR_:PATH=%BASEDIR% -DWINST_BATDIR_:PATH=%BATDIR% -DWINST_PREFIX_:PATH="%PREFIX%" -DWINST_DOWNLOADS_DIR:PATH="%DOWNLOADS%" %WTGIT% %WTGITREPO% %WTVERSION% %CMAKE_ARGS% "%BATDIR%\cmake"
)

:: Required to workaround Assembla issue #20 (missing files in packages)
:: %CMAKE_EXE% %BATDIR%\cmake

:: Create packages
:: %CPACK_EXE% %BATDIR%\cmake

:end

