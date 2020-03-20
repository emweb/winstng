cmake_minimum_required(VERSION 3.14)
project( winst )

include (ExternalProject)

# This variable is set in the bootstrapping script (winst/winst.bat)
#set(WINST_PREFIX ${PROJECT_SOURCE_DIR}/prefix)
#set(WINST_BASEDIR ${PROJECT_SOURCE_DIR}/..

set(WINST_BATDIR ${WINST_BATDIR_} CACHE PATH "winst source directory" FORCE)
set(WINST_BASEDIR ${WINST_BASEDIR_} CACHE PATH "winst global work directory" FORCE)
set(WINST_PREFIX ${WINST_PREFIX_} CACHE PATH "winst prefix directory" FORCE)

SET(WINST_DOWNLOADS_DIR ${WINST_BASEDIR}/downloads CACHE PATH "path for downloads")

set(CMAKE_INSTALL_PREFIX "${WINST_BASEDIR}/build/installation" CACHE PATH "Installation prefix, required for CPack due to absolute paths" FORCE)

set(STANDALONE_ASIO ${STANDALONE_ASIO} CACHE BOOL "use standalone version of Asio instead of Boost.Asio" FORCE)

set(WTGIT ${WTGIT} CACHE BOOL "build git version instead of release version" FORCE)

if(MSVC_VERSION GREATER_EQUAL 1900)
    set(_ENABLE_MARIADB_CONNECTOR_C_DEFAULT ON)
else()
    set(_ENABLE_MARIADB_CONNECTOR_C_DEFAULT OFF)
endif()
option(ENABLE_MARIADB_CONNECTOR_C "enable MariaDB connector (and wtdbomysql), defaults to true if using a compiler supported by MariaDB" ${_ENABLE_MARIADB_CONNECTOR_C_DEFAULT})
set(_ENABLE_MARIADB_CONNECTOR_C_DEFAULT)

IF (NOT WT_VERSION)
    SET(WT_VERSION "4.0.0")
ENDIF (NOT WT_VERSION)
set(WT_VERSION ${WT_VERSION} CACHE STRING "Wt version to download (if not WTGIT)" FORCE)

IF(NOT WTGITREPO)
    set(WTGITREPO "git://github.com/emweb/wt.git")
ENDIF(NOT WTGITREPO)
set(WTGITREPO ${WTGITREPO} CACHE BOOL "git repository for wt" FORCE)

if (NOT WTGITTAG)
    SET(WTGITTAG "master")
endif (NOT WTGITTAG)
set(WTGITTAG ${WTGITTAG} CACHE STRING "the branch name, commit id or tag to use when building git version" FORCE)

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${WINST_PREFIX} )

# Are we building for 32-bit or 64-bit?
if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 64-bit
    set(_WT_ADDRESS_WIDTH 64)
    if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        set(_WT_ARCH x64)
    else( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        set(_WT_ARCH ia64)
        message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
    endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 32-bit
    set(_WT_ADDRESS_WIDTH 32)
    set(_WT_ARCH x86)
endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

if(MSVC_VERSION EQUAL 1600)
    set(FANCY_MSVC_VERSION "2010")
elseif(MSVC_VERSION EQUAL 1700)
    set(FANCY_MSVC_VERSION "2012")
elseif(MSVC_VERSION EQUAL 1800)
    set(FANCY_MSVC_VERSION "2013")
elseif(MSVC_VERSION EQUAL 1900)
    set(FANCY_MSVC_VERSION "2015")
elseif(MSVC_VERSION GREATER_EQUAL 1910 AND MSVC_VERSION LESS 1920)
    set(FANCY_MSVC_VERSION "2017")
elseif(MSVC_VERSION GREATER_EQUAL 1920 AND MSVC_VERSION LESS 1930)
    set(FANCY_MSVC_VERSION "2019")
else()
    set(FANCY_MSVC_VERSION ${MSVC_VERSION})
endif()

# Files to download

if (STANDALONE_ASIO)
    set( asio_ver "1.12.2" )
    set( asio_URL https://prdownloads.sourceforge.net/asio/asio-${asio_ver}.tar.gz )
    set( asio_HASH SHA1=9fb618d489f9b695c52477660984d9a3e21d8fc3 )
    set( _PACKAGES ${_PACKAGES} asio )
endif()

set( zlib_URL https://prdownloads.sourceforge.net/libpng/zlib-1.2.11.tar.gz )
set( zlib_HASH SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)
set( _PACKAGES ${_PACKAGES} zlib )

set( libpng_URL https://sourceforge.net/projects/libpng/files/libpng14/1.4.22/libpng-1.4.22.tar.gz )
set( libpng_HASH SHA256=64b0632f7c528a7afd58c351be416fba3c9348a50a31b465d937e718febe81a7)
set( _PACKAGES ${_PACKAGES} libpng )

set( postgresql_URL https://ftp.postgresql.org/pub/source/v12.2/postgresql-12.2.tar.bz2 )
set( postgresql_HASH SHA256=ad1dcc4c4fc500786b745635a9e1eba950195ce20b8913f50345bb7d5369b5de )
set( _PACKAGES ${_PACKAGES} postgresql )

set( openssl_DLLVER 1_1 )
set( openssl_URL https://www.openssl.org/source/openssl-1.1.1e.tar.gz )
set( openssl_HASH SHA256=694f61ac11cb51c9bf73f54e771ff6022b0327a43bbdfa1b2f19de1662a6dcbe )
set( _PACKAGES ${_PACKAGES} openssl )

set( libharu_URL http://github.com/libharu/libharu/archive/RELEASE_2_3_0.tar.gz )
set( libharu_MD5 4f916aa49c3069b3a10850013c507460 )
set( _PACKAGES ${_PACKAGES} libharu )

set( mariadb_URL https://github.com/MariaDB/mariadb-connector-c/archive/v3.1.7.zip )
set( mariadb_HASH SHA256=6106d4bd5ea2bd162ba57ba9ffe2d7581870ef1cc903056dd4ba5ec11faed7d7 )
set( _PACKAGES ${_PACKAGES} mariadb )

set( boost_ver "1_72" )
set( boost_URL https://dl.bintray.com/boostorg/release/1.72.0/source/boost_${boost_ver}_0.tar.bz2 )
set( boost_HASH SHA256=59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722 )
set( _PACKAGES ${_PACKAGES} boost )

set( tinymce_URL http://download.tiny.cloud/tinymce/community/tinymce_3.5.12.zip )
set( tinymce_HASH SHA256=030d133dd3f4c2b092f28d8645a6fa058e8ac0e7e92d552fb8d4e29bdd0020c5 )
set( _PACKAGES ${_PACKAGES} tinymce )

set( wt_URL https://github.com/emweb/wt/archive/${WT_VERSION}.tar.gz )
set( _PACKAGES ${_PACKAGES} wt )

set( patch_URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip )
set( patch_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905)
set( _PACKAGES ${_PACKAGES} patch )

set( nasm_URL https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/win32/nasm-2.14.02-win32.zip )
set( nasm_HASH SHA256=250f9b5eeb2111e8c7b494a977490985b8604fe7518a6f5041cde37cc727a067 )
set( _PACKAGES ${_PACKAGES} nasm )

if( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
    set( perl_URL http://strawberryperl.com/download/5.24.1.1/strawberry-perl-5.24.1.1-64bit-portable.zip )
    set( perl_HASH SHA1=5e7bd4d9eecef30e9cfef95f45d4f94237a4d7a4)
    set( _PACKAGES ${_PACKAGES} perl )

    set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.7.27050-0_x64.zip )
    set( firebirdsql_MD5 aa0bcb781feb25d303520b94d2c0e0df )
    set( _PACKAGE ${_PACKAGES} firebirdsql )
elseif( _WT_ARCH STREQUAL "x86" ) # Win 32-bit
    set( perl_URL http://strawberryperl.com/download/5.24.1.1/strawberry-perl-5.24.1.1-32bit-portable.zip )
    set (perl_HASH SHA1=f1e64debc3b61010fe1885a668eaf2272e67153e )
    set( _PACKAGES ${_PACKAGES} perl )

    set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.7.27050-0_Win32.zip )
    set( firebirdsql_MD5 2cb088dd11b14d59ee97fd19f2038e99 )
    set( _PACKAGE ${_PACKAGES} firebirdsql )
elseif( _WT_ARCH STREQUAL "ia64" ) # Win Itanium
    message( ERROR "${_WT_ARCH} architecture is not supported by the Wt bootstrapper, please build manually." )
else() #ARM
    message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
endif()

# If in fetch mode, only download and set a "fetch-only" indicator
if (FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
        message( STATUS "Downloading ${pkg}" )
        get_filename_component( fn ${${pkg}_URL} NAME )
        file( DOWNLOAD ${${pkg}_URL} ${WINST_DOWNLOADS_DIR}/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)

    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )
ELSE ( FETCH_ONLY )
    # GNU patch
    ExternalProject_Add( patch
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${patch_URL}
        URL_MD5 ${patch_MD5}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${WINST_BATDIR}/patches/patch.exe.manifest ${WINST_PREFIX}/bin/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
    set( PATCH_EXECUTABLE ${WINST_PREFIX}\\bin\\patch.exe )

    # Make sure autotools-based 3rd-parties use the bootstrapped libraries
    file( WRITE ${WINST_PREFIX}/share/config.site "CPPFLAGS='-I${WINST_PREFIX}/include'\nLDFLAGS='-L${WINST_PREFIX}/lib'\n" )

    # Netwide Assembler
    ExternalProject_Add( nasm
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${nasm_URL}
        URL_HASH ${nasm_HASH}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/bin
        INSTALL_COMMAND ""
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    # Perl - required for OpenSSL
    file(MAKE_DIRECTORY ${WINST_PREFIX}/perl)
    ExternalProject_Add( perl
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${perl_URL}
        URL_HASH ${perl_HASH}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${WINST_PREFIX}/perl
        INSTALL_COMMAND ""
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/zlib)
    ExternalProject_Add( zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${zlib_URL}
        URL_HASH ${zlib_HASH}
        LIST_SEPARATOR ^^
        PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/zlib.h ${WINST_PREFIX}/licenses/zlib/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib-debug
        DEPENDS zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib-release
        DEPENDS zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib
        DEPENDS zlib-release zlib-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/libpng)
    ExternalProject_Add( libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${libpng_URL}
        URL_HASH ${libpng_HASH}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/libpng
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libpng-debug
        DEPENDS zlib libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
            -DCMAKE_BUILD_TYPE=Debug
            -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
            -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
            -DPNG_SHARED:BOOL=OFF
            -DPNG_STATIC:BOOL=ON
            -DZLIB_DEBUG_LIBRARY:PATH=${WINST_PREFIX}/lib/zlibstaticd.lib
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
    ExternalProject_Add( libpng-release
        DEPENDS zlib libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
            -DCMAKE_BUILD_TYPE=RelWithDebInfo
            -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
            -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
            -DPNG_SHARED:BOOL=OFF
            -DPNG_STATIC:BOOL=ON
            -DZLIB_RELEASE_LIBRARY=${WINST_PREFIX}/lib/zlibstatic.lib
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libpng
        DEPENDS libpng-release libpng-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        )

    # OpenSSL requires some extra effort
    if( _WT_ARCH STREQUAL "x64" ) # Windows 64-bit
        set( OPENSSL_DEBUG_CONFIGURE_COMMAND "${WINST_PREFIX}/perl/bin/perl Configure VC-WIN64A --debug --openssldir=${WINST_PREFIX} --prefix=${WINST_PREFIX}" )
        set( OPENSSL_RELEASE_CONFIGURE_COMMAND "${WINST_PREFIX}/perl/bin/perl Configure VC-WIN64A --release --openssldir=${WINST_PREFIX} --prefix=${WINST_PREFIX}" )
    else( _WT_ARCH STREQUAL "x86" ) # Windows 32-bit
        set( OPENSSL_DEBUG_CONFIGURE_COMMAND "${WINST_PREFIX}/perl/bin/perl Configure VC-WIN32 --debug --openssldir=${WINST_PREFIX} --prefix=${WINST_PREFIX}" )
        set( OPENSSL_RELEASE_CONFIGURE_COMMAND "${WINST_PREFIX}/perl/bin/perl Configure VC-WIN32 --release --openssldir=${WINST_PREFIX} --prefix=${WINST_PREFIX}" )
    endif()

    set( OPENSSL_DEBUG_BUILD_COMMAND "nmake" )
    set( OPENSSL_RELEASE_BUILD_COMMAND "nmake" )

    set( OPENSSL_DEBUG_INSTALL_COMMAND "nmake install" )
    set( OPENSSL_RELEASE_INSTALL_COMMAND "nmake install" )

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${WINST_PREFIX}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )

    ExternalProject_Add( openssl-debug
        DEPENDS perl patch nasm
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${openssl_URL}
        URL_HASH ${openssl_HASH}
        LIST_SEPARATOR ^^
        UPDATE_COMMAND ""
        PATCH_COMMAND ${PATCH_EXECUTABLE} --binary -p1 < ${WINST_BATDIR}/patches/openssl-library-names.patch
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_DEBUG_CONFIGURE_COMMAND} -P ${WINST_BATDIR}/cmake/configure-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND:STRING=${OPENSSL_DEBUG_BUILD_COMMAND} -P ${WINST_BATDIR}/cmake/build-openssl.cmake
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND:STRING=${OPENSSL_DEBUG_INSTALL_COMMAND} -P ${WINST_BATDIR}/cmake/install-openssl.cmake
        TEST_COMMAND ${CMAKE_COMMAND} -E rename ${WINST_PREFIX}/lib/libcrypto.lib ${WINST_PREFIX}/lib/libcryptod.lib
        COMMAND ${CMAKE_COMMAND} -E rename ${WINST_PREFIX}/lib/libssl.lib ${WINST_PREFIX}/lib/libssld.lib
        BUILD_IN_SOURCE 1
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( openssl-release
        DEPENDS perl patch nasm openssl-debug
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${openssl_URL}
        URL_HASH ${openssl_HASH}
        LIST_SEPARATOR ^^
        UPDATE_COMMAND ""
        PATCH_COMMAND ${PATCH_EXECUTABLE} --binary -p1 < ${WINST_BATDIR}/patches/openssl-library-names.patch
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_RELEASE_CONFIGURE_COMMAND} -P ${WINST_BATDIR}/cmake/configure-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND:STRING=${OPENSSL_RELEASE_BUILD_COMMAND} -P ${WINST_BATDIR}/cmake/build-openssl.cmake
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND:STRING=${OPENSSL_RELEASE_INSTALL_COMMAND} -P ${WINST_BATDIR}/cmake/install-openssl.cmake
        TEST_COMMAND ""
        BUILD_IN_SOURCE 1
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/openssl)
    ExternalProject_Add( openssl
        DEPENDS openssl-release openssl-debug
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${openssl_URL}
        URL_HASH ${openssl_HASH}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/openssl/
        )

    if(ENABLE_MARIADB_CONNECTOR_C)
        file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/mariadb)
        ExternalProject_Add( mariadb-fetch
            DEPENDS patch
            SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
            DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
            URL ${mariadb_URL}
            URL_HASH ${mariadb_HASH}
            LIST_SEPARATOR ^^
            PATCH_COMMAND ${PATCH_EXECUTABLE} --binary -p1 < ${WINST_BATDIR}/patches/mariadb-native-client.patch
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/COPYING.LIB ${WINST_PREFIX}/licenses/mariadb/
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )

        ExternalProject_Add( mariadb-debug
            DEPENDS mariadb-fetch zlib
            SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
            DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
            LIST_SEPARATOR ^^
            CMAKE_ARGS
                -DINSTALL_LIBDIR=lib
                -DCMAKE_BUILD_TYPE=Debug
                -DCMAKE_MODULE_PATH:STRING=${WINST_MODULE_PATH}
                -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
                -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
                -DWITH_EXTERNAL_ZLIB:BOOL=ON
                -DZLIB_DEBUG_LIBRARY:PATH=${WINST_PREFIX}/lib/zlibstaticd.lib
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )

        ExternalProject_Add( mariadb-release
            DEPENDS mariadb-fetch zlib
            SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
            DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
            LIST_SEPARATOR ^^
            CMAKE_ARGS
                -DINSTALL_LIBDIR=lib
                -DCMAKE_BUILD_TYPE=RelWithDebInfo
                -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
                -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
                -DCMAKE_MODULE_PATH:STRING=${WINST_MODULE_PATH}
                -DWITH_EXTERNAL_ZLIB:BOOL=ON
                -DZLIB_RELEASE_LIBRARY=${WINST_PREFIX}/lib/zlibstatic.lib
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )

        ExternalProject_Add( mariadb
            DEPENDS mariadb-release mariadb-debug
            SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
            DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            )
    endif()


    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/postgresql)
    ExternalProject_Add( postgresql-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/postgresql-src
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${postgresql_URL}
        DOWNLOAD_NAME ${postgresql_NAME}
        URL_HASH ${postgresql_HASH}
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/COPYRIGHT ${WINST_PREFIX}/licenses/postgresql/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    configure_file( ${winst_SOURCE_DIR}/postgresql-11.1-config_default.pl.cmake ${CMAKE_BINARY_DIR}/postgres_config.pl @ONLY )

    set(postgresql_CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/postgres_config.pl <SOURCE_DIR>/src/tools/msvc/config.pl)
    set(postgresql_BUILD_COMMAND ${CMAKE_COMMAND} -E env MSBFLAGS=-property:ConfigurationType=StaticLibrary ${WINST_BATDIR}/cmake/execute-with-path.bat ${WINST_PREFIX}/perl/bin ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/src/tools/msvc build.bat)
    set(postgresql_INSTALL_COMMAND ${WINST_BATDIR}/cmake/execute-with-path.bat ${WINST_PREFIX}/perl/bin ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/src/tools/msvc install.bat ${WINST_PREFIX})
    set(postgresql_TEST_COMMAND ${CMAKE_COMMAND} -E echo)

    if( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
        SET(POSTGRES_CPU "AMD64")
    elseif( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
        SET(POSTGRES_CPU "i386")
    endif( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
    ExternalProject_Add( postgresql-debug
        DEPENDS postgresql-fetch perl
        SOURCE_DIR ${CMAKE_BINARY_DIR}/postgresql-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ${postgresql_CONFIGURE_COMMAND}
        #for ssl: add SSL_INC="..." SSL_LIB_PATH="..." USE_SSL=1
        BUILD_COMMAND ${postgresql_BUILD_COMMAND} DEBUG libpq
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND lib /OUT:${WINST_PREFIX}/lib/libpqd.lib <SOURCE_DIR>/Debug/libpq/libpq.lib <SOURCE_DIR>/Debug/libpgport/libpgport.lib <SOURCE_DIR>/Debug/libpgcommon/libpgcommon.lib
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        TEST_AFTER_INSTALL 1
        TEST_COMMAND ${postgresql_TEST_COMMAND}
        )

    ExternalProject_Add( postgresql-release
        DEPENDS postgresql-fetch postgresql-debug perl
        SOURCE_DIR ${CMAKE_BINARY_DIR}/postgresql-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ${postgresql_CONFIGURE_COMMAND}
        BUILD_COMMAND ${postgresql_BUILD_COMMAND} libpq
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND lib /OUT:${WINST_PREFIX}/lib/libpq.lib <SOURCE_DIR>/Release/libpq/libpq.lib <SOURCE_DIR>/Release/libpgport/libpgport.lib <SOURCE_DIR>/Release/libpgcommon/libpgcommon.lib
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        TEST_AFTER_INSTALL 1
        TEST_COMMAND ${postgresql_TEST_COMMAND}
        )

    ExternalProject_Add( postgresql
        DEPENDS postgresql-release postgresql-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/postgresql-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ${WINST_BATDIR}/cmake/install-postgres-headerfiles.bat <SOURCE_DIR> ${WINST_PREFIX}/include ${CMAKE_COMMAND}
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/firebirdsql)
    # Download and extract firebird binaries. Or build it?
    ExternalProject_Add( firebirdsql
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${firebirdsql_URL}
        URL_MD5 ${firebirdsql_MD5}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/IPLicense.txt ${WINST_PREFIX}/licenses/firebirdsql/
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/IDPLicense.txt ${WINST_PREFIX}/licenses/firebirdsql/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/libharu)
    ExternalProject_Add( libharu-fetch
        DEPENDS patch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${libharu_URL}
        URL_MD5 ${libharu_MD5}
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/libharu-2.3.0RC3.patch
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/README ${WINST_PREFIX}/licenses/libharu/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        )

    ExternalProject_Add( libharu-debug
        DEPENDS libharu-fetch zlib libpng
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
            -DCMAKE_BUILD_TYPE=Debug
            -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
            -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
            -DZLIB_LIBRARY_DEBUG:PATH=${WINST_PREFIX}/lib/zlibstaticd.lib
            -DPNG_LIBRARY_DEBUG:PATH=${WINST_PREFIX}/lib/libpng14_staticd.lib
            -DLIBHPDF_STATIC:BOOL=OFF
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libharu-release
        DEPENDS libharu-fetch libharu-debug zlib libpng
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
            -DCMAKE_BUILD_TYPE=RelWithDebInfo
            -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH}
            -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
            -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
            -DZLIB_LIBRARY_RELEASE:PATH=${WINST_PREFIX}/lib/zlibstatic.lib
            -DPNG_LIBRARY_RELEASE:PATH=${WINST_PREFIX}/lib/libpng14_static.lib
            -DLIBHPDF_STATIC:BOOL=OFF
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libharu
        DEPENDS libharu-release libharu-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/boost)
    set( boost_BOOTSTRAP_COMMAND "bootstrap.bat" )
    set( boost_B2 "b2" )
    set( boost_LINKAGE link=static )

    if(MSVC_VERSION EQUAL 1600)
        set( boost_TOOLSET toolset=msvc-10.0 )
    elseif(MSVC_VERSION EQUAL 1700)
        set( boost_TOOLSET toolset=msvc-11.0 )
    elseif(MSVC_VERSION EQUAL 1800)
        set( boost_TOOLSET toolset=msvc-12.0 )
    elseif(MSVC_VERSION EQUAL 1900)
        set( boost_TOOLSET toolset=msvc-14.0 )
    elseif(MSVC_VERSION GREATER_EQUAL 1910 AND MSVC_VERSION LESS 1920)
        set( boost_TOOLSET toolset=msvc-14.1 )
    elseif(MSVC_VERSION GREATER_EQUAL 1920 AND MSVC_VERSION LESS 1930)
        set( boost_TOOLSET toolset=msvc-14.2 )
    endif()

    if( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
        set( boost_ADDRESS_MODEL address-model=64)
    elseif( _WT_ARCH STREQUAL "x86" ) # Win 32-bit
        set( boost_ADDRESS_MODEL address-model=32)
    elseif( _WT_ARCH STREQUAL "ia64" )
        message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
    endif( )

    set( boost_COMMAND ${boost_B2} --build-type=minimal ${boost_TOOLSET} ${boost_ADDRESS_MODEL} --variant=release --without-python ${boost_LINKAGE} threading=multi include=${WINST_PREFIX}/include linkflags=-L${WINST_PREFIX}/lib )
    ExternalProject_Add( boost
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${boost_URL}
        URL_HASH ${boost_HASH}
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ${boost_BOOTSTRAP_COMMAND}
        BUILD_COMMAND ${boost_COMMAND}
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${boost_COMMAND} --prefix=${WINST_PREFIX} install
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE_1_0.txt ${WINST_PREFIX}/licenses/boost/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    set( wt_CMAKE_ARGS
        -DSHARED_LIBS:BOOL=1
        -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
        -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        -DBoost_NO_SYSTEM_PATHS:BOOL=1
        -DBOOST_ROOT:PATH=${WINST_PREFIX}
        -DBOOST_DYNAMIC:BOOL=0
        -DCONFIGDIR:PATH=c:/witty
        -DWT_WRASTERIMAGE_IMPLEMENTATION=Direct2D
        -DHARU_PREFIX=${WINST_PREFIX}
        -DHARU_DYNAMIC:BOOL=1
        -DPOSTGRES_PREFIX=${WINST_PREFIX}
        -DZLIB_LIBRARY_DEBUG:PATH=${WINST_PREFIX}/lib/zlibstaticd.lib
        -DZLIB_LIBRARY_RELEASE:PATH=${WINST_PREFIX}/lib/zlibstatic.lib
        -DPNG_LIBRARY_DEBUG:PATH=${WINST_PREFIX}/lib/libpng14_staticd.lib
        -DPNG_LIBRARY_RELEASE:PATH=${WINST_PREFIX}/lib/libpng14_static.lib
        -DRUNDIR=${WINST_PREFIX}/var/run/wt
        -DSSL_PREFIX=${WINST_PREFIX}
        -DMYSQL_PREFIX=${WINST_PREFIX}
        -DMYSQL_LIBRARY=libmariadb
        -DEXAMPLES_DESTINATION=lib/Wt/examples
        -DENABLE_OPENGL:BOOL=1
        -DSSL_LIB_NAMES=libssl
        -DSSL_LIB_TOO_NAMES=libcrypto
        -DENABLE_QT4:BOOL=0
        -DENABLE_QT5:BOOL=0
        -DWTHTTP_CONFIGURATION:PATH=c:/witty/wthttpd
        )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/wt)

    if(STANDALONE_ASIO)
        set( wt_CMAKE_ARGS
            ${wt_CMAKE_ARGS}
            -DASIO_PREFIX:PATH=${WINST_PREFIX}
            -DWT_ASIO_IMPLEMENTATION=standalone
        )
    endif()
    
    if(WT_VERSION VERSION_LESS 4.0.0)
        set(WT_MARIADB_PATCH wt_static_mariadbclient.patch)
    else()
        set(WT_MARIADB_PATCH wt3_static_mariadbclient.patch)
    endif()

    if(WT_VERSION VERSION_LESS 4.0.0)
        set(WT_PATCH_COMMAND "")
    else()
        set(WT_PATCH_COMMAND ${PATCH_EXECUTABLE} --binary -p1 < ${WINST_BATDIR}/patches/wt-4.3.0-rc1.patch)
    endif()

    if( WTGIT )
        ExternalProject_Add( wt-fetch
            # git
            SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
            DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
            GIT_REPOSITORY ${WTGITREPO}
            GIT_TAG ${WTGITTAG}
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            PATCH_COMMAND ${WT_PATCH_COMMAND}
            LOG_INSTALL 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/wt/
        )
    else( WTGIT )
        ExternalProject_Add( wt-fetch
            SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
            DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
            URL ${wt_URL}
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            PATCH_COMMAND ${WT_PATCH_COMMAND}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/wt/
        )
    endif( WTGIT )

    ExternalProject_Get_Property( wt-fetch source_dir )

    file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/tinymce)
    ExternalProject_Add( tinymce
        DEPENDS wt-fetch
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${tinymce_URL}
        URL_HASH ${tinymce_HASH}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/jscripts/ ${source_dir}/resources/
        BUILD_COMMAND ${CMAKE_COMMAND} -E remove ${source_dir}/resources/tiny_mce/tiny_mce_src.js
        INSTALL_COMMAND ${CMAKE_COMMAND} -E remove ${source_dir}/resources/tiny_mce/license.txt
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jscripts/tiny_mce/license.txt ${WINST_PREFIX}/licenses/tinymce/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    if (STANDALONE_ASIO)
        file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/asio)
        ExternalProject_Add( asio
        DOWNLOAD_DIR ${WINST_DOWNLOADS_DIR}
        URL ${asio_URL}
        URL_HASH ${asio_HASH}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include/asio ${WINST_PREFIX}/include/asio
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/include/asio.hpp ${WINST_PREFIX}/include/
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE_1_0.txt ${WINST_PREFIX}/licenses/asio/
        TEST_COMMAND ""
        )
    endif (STANDALONE_ASIO)

    set(wt_DEPENDS
        tinymce
        wt-fetch
        zlib
        libpng
        libharu
        openssl
        firebirdsql
        postgresql
        boost
    )
    if(STANDALONE_ASIO)
        set(wt_DEPENDS ${wt_DEPENDS} asio)
    endif()
    if(ENABLE_MARIADB_CONNECTOR_C)
        set(wt_DEPENDS ${wt_DEPENDS} mariadb)
    endif()
    ExternalProject_Add( wt-debug
        DEPENDS ${wt_DEPENDS}
        SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=Debug
            -DBoost_USE_DEBUG_RUNTIME:BOOL=1
            -DMYSQL_DEBUG_LIB:FILEPATH=${WINST_PREFIX}/lib/mariadbclientd.lib
            ${wt_CMAKE_ARGS}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
    )
    ExternalProject_Add( wt-release
        DEPENDS ${wt_DEPENDS}
        SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=RelWithDebInfo
            -DINSTALL_EXAMPLES:BOOL=1
            -DINSTALL_DOCUMENTATION:BOOL=1
            -DBoost_USE_DEBUG_RUNTIME:BOOL=0
            -DMYSQL_LIB:FILEPATH=${WINST_PREFIX}/lib/mariadbclient.lib
            ${wt_CMAKE_ARGS}            
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
    )
    ExternalProject_Add( wt
        DEPENDS wt-release wt-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )

    string(REGEX MATCHALL "[0-9]+" WT_VERSION_LIST ${WT_VERSION})
    list(GET WT_VERSION_LIST 0 WT_VERSION_MAJOR)
    list(GET WT_VERSION_LIST 1 WT_VERSION_MINOR)
    list(GET WT_VERSION_LIST 2 WT_VERSION_PATCH)

    # INSTALLATION

    INSTALL(DIRECTORY "${WINST_PREFIX}/licenses" DESTINATION "." COMPONENT binaries)
    INSTALL(DIRECTORY "${WINST_PREFIX}/share/doc/Wt/" DESTINATION "doc" COMPONENT documentation)


    # Headers

    INSTALL(DIRECTORY "${WINST_PREFIX}/include/Wt" DESTINATION "include" COMPONENT binaries)
    if (STANDALONE_ASIO)
        INSTALL(DIRECTORY "${WINST_PREFIX}/include/asio" DESTINATION "include" COMPONENT binaries)
        INSTALL(FILES "${WINST_PREFIX}/include/asio.hpp" DESTINATION "include" COMPONENT binaries)
    else (STANDALONE_ASIO)
        INSTALL(DIRECTORY "${WINST_PREFIX}/include/boost-${boost_ver}/boost" DESTINATION "include" COMPONENT binaries)
    endif (STANDALONE_ASIO)

    # Libraries

    IF (NOT STANDALONE_ASIO)
       INSTALL(DIRECTORY "${WINST_PREFIX}/lib/" DESTINATION "lib" COMPONENT binaries
         FILES_MATCHING
             PATTERN "engines-*" EXCLUDE
             PATTERN "libpng" EXCLUDE
             PATTERN "mariadb" EXCLUDE
             PATTERN "pkgconfig" EXCLUDE
             PATTERN "libboost*")
    ENDIF (NOT STANDALONE_ASIO)

    INSTALL(
        FILES
            "${WINST_PREFIX}/bin/libcrypto-${openssl_DLLVER}.dll"
            "${WINST_PREFIX}/bin/libcrypto-${openssl_DLLVER}d.dll"
            "${WINST_PREFIX}/bin/libssl-${openssl_DLLVER}.dll"
            "${WINST_PREFIX}/bin/libssl-${openssl_DLLVER}d.dll"
        DESTINATION "bin"
        COMPONENT binaries)
    INSTALL(
        FILES
            "${WINST_PREFIX}/lib/libcrypto.lib"
            "${WINST_PREFIX}/lib/libcryptod.lib"
            "${WINST_PREFIX}/lib/libssl.lib"
            "${WINST_PREFIX}/lib/libssld.lib"
        DESTINATION "lib"
        COMPONENT binaries)
    INSTALL(
        FILES
            "${WINST_PREFIX}/bin/libcrypto-${openssl_DLLVER}.pdb"
            "${WINST_PREFIX}/bin/libcrypto-${openssl_DLLVER}d.pdb"
            "${WINST_PREFIX}/bin/libssl-${openssl_DLLVER}.pdb"
            "${WINST_PREFIX}/bin/libssl-${openssl_DLLVER}d.pdb"
        DESTINATION "bin"
        COMPONENT symbols)

    INSTALL(DIRECTORY "${WINST_PREFIX}/include/" DESTINATION "include" COMPONENT binaries
        FILES_MATCHING
            PATTERN "boost-*" EXCLUDE
            PATTERN "libpng*" EXCLUDE
            PATTERN "mariadb" EXCLUDE
            PATTERN "openssl" EXCLUDE
            PATTERN "postgresql" EXCLUDE
            PATTERN "hpdf*")
    INSTALL(FILES "${WINST_PREFIX}/lib/libhpdf.lib" "${WINST_PREFIX}/lib/libhpdfd.lib" DESTINATION "lib" COMPONENT binaries)
    INSTALL(FILES "${WINST_PREFIX}/bin/libhpdf.dll" "${WINST_PREFIX}/bin/libhpdfd.dll" DESTINATION "bin" COMPONENT binaries)
    INSTALL(FILES "${CMAKE_BINARY_DIR}/libharu-debug-prefix/src/libharu-debug-build/src/libhpdfd.pdb" DESTINATION "bin" COMPONENT symbols)
    INSTALL(FILES "${CMAKE_BINARY_DIR}/libharu-release-prefix/src/libharu-release-build/src/libhpdf.pdb" DESTINATION "bin" COMPONENT symbols)


    set(ALL_DYN_WT_LIBS wt wtdbo wtdbofirebird wtdbomssqlserver wtdbopostgres wtdbosqlite3 wthttp wttest)
    if(ENABLE_MARIADB_CONNECTOR_C)
        set(ALL_DYN_WT_LIBS ${ALL_DYN_WT_LIBS} wtdbomysql)
    endif()
    set(ALL_WT_LIBS ${ALL_DYN_WT_LIBS} wtisapi)
    FOREACH(lib ${ALL_DYN_WT_LIBS})
        INSTALL(FILES "${WINST_PREFIX}/bin/${lib}.dll" "${WINST_PREFIX}/bin/${lib}d.dll" DESTINATION "bin" COMPONENT binaries)
    ENDFOREACH(lib)
    FOREACH(lib ${ALL_WT_LIBS})
        INSTALL(FILES "${WINST_PREFIX}/lib/${lib}.lib" "${WINST_PREFIX}/lib/${lib}d.lib" DESTINATION "lib" COMPONENT binaries)
    ENDFOREACH(lib)

    INSTALL(FILES
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/wtd.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/wtdbod.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/backend/wtdbofirebirdd.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/backend/wtdbosqlite3d.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/backend/wtdbomssqlserverd.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/backend/wtdbopostgresd.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/http/wthttpd.pdb"
        "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/wttestd.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/wt.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/wtdbo.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/backend/wtdbofirebird.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/backend/wtdbosqlite3.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/backend/wtdbomssqlserver.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/backend/wtdbopostgres.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/http/wthttp.pdb"
        "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/wttest.pdb"
        DESTINATION "bin" COMPONENT symbols
    )
    if (ENABLE_MARIADB_CONNECTOR_C)
        INSTALL(FILES
            "${CMAKE_BINARY_DIR}/wt-debug-prefix/src/wt-debug-build/src/Wt/Dbo/backend/wtdbomysqld.pdb"
            "${CMAKE_BINARY_DIR}/wt-release-prefix/src/wt-release-build/src/Wt/Dbo/backend/wtdbomysql.pdb"
            DESTINATION "bin" COMPONENT symbols
        )
    endif()

    SET(EXAMPLE_EXES "")
    SET(EXAMPLE_BATS "")
    MACRO(ADD_EXAMPLE path name)
      LIST(APPEND EXAMPLE_EXES "${WINST_PREFIX}/lib/Wt/examples/${path}/${name}.wt.exe")
      LIST(APPEND EXAMPLE_BATS "${WINST_PREFIX}/bin/${name}.bat")
    ENDMACRO(ADD_EXAMPLE)
    MACRO(ADD_DBO_EXAMPLE path name)
      LIST(APPEND EXAMPLE_EXES "${WINST_PREFIX}/lib/Wt/examples/${path}/${name}.exe")
    ENDMACRO(ADD_DBO_EXAMPLE)

    ADD_EXAMPLE(blog blog)
    IF(NOT MSVC10)
      ADD_EXAMPLE(chart3D chart3D)
    ENDIF()
    ADD_EXAMPLE(charts charts)
    ADD_EXAMPLE(codeview codingview)
    ADD_EXAMPLE(composer composer)
    ADD_EXAMPLE(dialog dialog)
    ADD_EXAMPLE(dragdrop dragdrop)
    ADD_EXAMPLE(filedrop filedrop)
    ADD_EXAMPLE(filetreetable filetreetable)
    ADD_EXAMPLE(form formexample)
    ADD_EXAMPLE(hangman hangman)
    ADD_EXAMPLE(hello hello)
    ADD_EXAMPLE(http-client http-client)
    ADD_EXAMPLE(javascript javascript)
    ADD_EXAMPLE(leaflet leaflet)
    ADD_EXAMPLE(mandelbrot mandelbrot)
    ADD_EXAMPLE(mission impossible)
    ADD_EXAMPLE(onethread hello1thread)
    ADD_EXAMPLE(painting paintexample)
    ADD_EXAMPLE(planner planner)
    ADD_EXAMPLE(qrlogin qrlogin)
    ADD_EXAMPLE(simplechat simplechat)
    ADD_EXAMPLE(style styleexample)
    IF(ENABLE_MARIADB_CONNECTOR_C)
        ADD_EXAMPLE(te-benchmark te-benchmark)
    ENDIF()
    ADD_EXAMPLE(te-benchmark te-benchmark-pg)
    ADD_EXAMPLE(treelist demotreelist)
    ADD_EXAMPLE(treeview treeviewexample)
    ADD_EXAMPLE(treeview-dragdrop treeviewdragdrop)
    ADD_EXAMPLE(webgl webgl)
    IF(NOT MSVC10)
      ADD_EXAMPLE(widgetgallery widgetgallery)
    ENDIF()
    ADD_EXAMPLE(wt-homepage Home)

    ADD_EXAMPLE(feature/auth1 auth1)
    ADD_EXAMPLE(feature/auth2 auth2)
    ADD_EXAMPLE(feature/broadcast broadcast)
    ADD_EXAMPLE(feature/client-ssl-auth client-ssl-auth)
    ADD_EXAMPLE(feature/locale locale)
    ADD_EXAMPLE(feature/mediaplayer mediaplayer)
    ADD_EXAMPLE(feature/miniwebgl miniwebgl)
    ADD_EXAMPLE(feature/multiple_servers multiple)
    ADD_EXAMPLE(feature/oauth oauth)
    ADD_EXAMPLE(feature/oidc oidc)
    ADD_EXAMPLE(feature/paypal paypal)
    IF (NOT ${WT_VERSION_MAJOR} STREQUAL "3")
        ADD_EXAMPLE(feature/postall postall)
    ENDIF()
    ADD_EXAMPLE(feature/scrollvisibility scrollvisibility)
    ADD_EXAMPLE(feature/serverpush serverpush)
    ADD_EXAMPLE(feature/socketnotifier socketnotifier)
    ADD_EXAMPLE(feature/suggestionpopup suggestionpopup)
    ADD_EXAMPLE(feature/template-fun widgetfunction)
    IF (NOT ${WT_VERSION_MAJOR} STREQUAL "3")
        ADD_EXAMPLE(feature/urlparams urlparams)
    ENDIF()
    ADD_EXAMPLE(feature/video video)
    ADD_EXAMPLE(feature/widgetset hellowidgetset)

    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial1)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial2)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial3)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial4)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial5)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial6)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial7)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial8)
    ADD_DBO_EXAMPLE(feature/dbo dbo-tutorial9)

    INSTALL(FILES ${EXAMPLE_EXES} ${EXAMPLE_BATS} DESTINATION "bin" COMPONENT examples)

    INSTALL(DIRECTORY "${WINST_PREFIX}/lib/Wt" DESTINATION "lib" COMPONENT binaries)
    INSTALL(DIRECTORY "${WINST_PREFIX}/share/Wt" DESTINATION "lib/share" COMPONENT binaries)
    IF(STANDALONE_ASIO)
        INSTALL(DIRECTORY "${WINST_PREFIX}/lib/cmake/wt" DESTINATION "lib/cmake" COMPONENT binaries OPTIONAL)
    ELSE()
        INSTALL(DIRECTORY "${WINST_PREFIX}/lib/cmake" DESTINATION "lib" COMPONENT binaries OPTIONAL)
    ENDIF()


    # Compose a meaningful compiler string
    set(_WT_COMPILER "msvs${FANCY_MSVC_VERSION}")

    #
    # Packages/installers
    #

    # Put everything in a single ZIP file
    set(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE 1)

    set(CMAKE_INSTALL_PREFIX "${WINST_BASEDIR}/build/installation" CACHE PATH "Installation prefix, required for CPack due to absolute paths" FORCE)
    SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Wt binary build")
    SET(CPACK_PACKAGE_VENDOR "emweb bvba")
    SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
    SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
    SET(CPACK_PACKAGE_VERSION_MAJOR ${WT_VERSION_MAJOR})
    SET(CPACK_PACKAGE_VERSION_MINOR ${WT_VERSION_MINOR})
    SET(CPACK_PACKAGE_VERSION_PATCH ${WT_VERSION_PATCH})
    SET(CPACK_PACKAGE_INSTALL_DIRECTORY "Wt ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH} ${_WT_COMPILER} ${_WT_ARCH}")

    SET(CPACK_GENERATOR "ZIP;NSIS")

    set(CPACK_COMPONENTS_ALL binaries documentation examples symbols)

    set(CPACK_COMPONENT_BINARIES_DISPLAY_NAME "Binaries")
    set(CPACK_COMPONENT_BINARIES_DESCRIPTION "Wt binaries and third party dependencies. Includes DLLs and import libraries.")
    set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
    set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Examples, ready to run. Source code is not included.")
    set(CPACK_COMPONENT_DOCUMENTATION_DISPLAY_NAME "Documentation")
    set(CPACK_COMPONENT_DOCUMENTATION_DESCRIPTION "Wt documentation in HTML format")
    set(CPACK_COMPONENT_SYMBOLS_DISPLAY_NAME "Debug Symbols")
    set(CPACK_COMPONENT_SYMBOLS_DESCRIPTION "PDB files for all debug DLLs")

    set(CPACK_COMPONENT_BINARIES_REQUIRED TRUE)
   
   #set(CPACK_COMPONENT_EXAMPLES_DEPENDS binaries)
   
   IF(WT_GIT)
       SET(CPACK_PACKAGE_FILE_NAME "Wt-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${_WT_COMPILER}-${CMAKE_SYSTEM_NAME}-${_WT_ARCH}-SDK")
   ELSE(WT_GIT)
       #want to get release candidate indication in filename version
       SET(CPACK_PACKAGE_FILE_NAME "Wt-${WT_VERSION}-${_WT_COMPILER}-${CMAKE_SYSTEM_NAME}-${_WT_ARCH}-SDK")
   ENDIF(WT_GIT)

   INCLUDE(CPack)

ENDIF( FETCH_ONLY )
