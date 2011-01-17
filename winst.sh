#!/bin/bash -x
echo ""
echo "*******************************************************"
echo "*                  Wt bootstrapper                    *"
echo "*******************************************************"
echo ""

_DIRNAME=`dirname "$0"`
PREFIX=`readlink -e $_DIRNAME`


if [ -n $1 ] && ( [ "$1" == "--help" ] || [ "$1" == "-h" ] )
then
  echo "Usage:" 
  echo "  $0 -h | --help          This help"
  echo "  $0 [CMake parameters]   Download and build Wt and its dependencies. CMake parameters are optional."
  echo "  $0 --fetch              Download dependencies, do not build anything now [for later usage]"
  exit
fi

# On Mac, use curl (built-in)
DOWNLOADER=wget -N -c

CMAKE_ZIP=cmake-2.8.3.20110115-gf8614.tar.gz
CMAKE_FULLURL=http://www.cmake.org/files/vCVS/$CMAKE_ZIP
CMAKE_DIRECTORY=cmake-2.8.3.20110115-gf8614

echo "Checking directories..."
[ -d devutil ] || mkdir devutil
[ -d downloads ] || mkdir downloads
[ -d build ] || mkdir build

echo "Downloading CMake..."
cd downloads
[ -f $CMAKE_ZIP ] || $DOWNLOADER $CMAKE_FULLURL

if [ ! -f ../bin/cmake ]
then
  echo "Building and installing CMake..."
  tar xf ../downloads/$CMAKE_ZIP
  cd $CMAKE_DIRECTORY
  ./bootstrap --prefix=$PREFIX
  make
  make install
  cd ..
  rm -rf $CMAKE_DIRECTORY
fi

echo "Bootstrapping..."

if [ -n $1 ] && [ "$1" == "--fetch" ]
then
  echo "blah - pwd = `pwd`"
  shift
  cd ../build
  ../bin/cmake -DFETCH_ONLY:BOOL=1 $@ ..
else
  echo "blah - pwd2 = `pwd`"
  if [ -f ../build/fetch-only ]
  then
    echo "blah - pwd3 = `pwd`"
    rm -rf ../build
    mkdir ../build
  fi
  echo "blah - pwd4 = `pwd`"
  cd ../build
  ../bin/cmake $@ ..
fi

# @echo on
# @IF NOT [%1]==[] (
#     @IF /I "%1"=="fetch" ( 
#         SHIFT
#         cd ..\build
#         ..\bin\cmake -DFETCH_ONLY:BOOL=1 %* ..
#     ) ELSE (
#         @IF EXIST ..\build\fetch-only (
#             @rd /q /s ..\build
#             @mkdir ..\build
#             @cd ..\build
#             ..\bin\cmake %* ..
#         ) ELSE (
#             @echo There is something wrong with your build directory, please remove it and start again
#         )
#     )
# ) ELSE (
#     @IF EXIST ..\build\fetch-only (
#         @rd /q /s ..\build
#         @mkdir ..\build
#     )
# 
#     @cd ..\build
#     ..\bin\cmake %* ..
# )
