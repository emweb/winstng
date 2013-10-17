
project( winst )

# TODO Missing dependencies:
# - Firebird
# - Pango (needs glib)
# - Replace jpeg with jpeg-turbo

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)

# This variable is set in the bootstrapping script (winst/winst.bat)
#set(WINST_PREFIX ${PROJECT_SOURCE_DIR}/prefix)
#set(WINST_BASEDIR ${PROJECT_SOURCE_DIR}/..

set(WINST_BATDIR ${WINST_BATDIR_} CACHE PATH "winst source directory" FORCE)
set(WINST_BASEDIR ${WINST_BASEDIR_} CACHE PATH "winst global work directory" FORCE)
set(WINST_PREFIX ${WINST_PREFIX_} CACHE PATH "winst prefix directory" FORCE)

set(CMAKE_INSTALL_PREFIX "${WINST_BASEDIR}/build/installation" CACHE PATH "Installation prefix, required for CPack due to absolute paths" FORCE)

#our version of FindXXX.cmake
set(WINST_MODULE_PATH ${WINST_BATDIR}/cmake/Modules)

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${WINST_PREFIX} )

# Are we building for 32-bit or 64-bit?
# TODO Support ARM, MIPS and others
if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 64-bit
	if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
		set(_WT_ARCH x64)
	else( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
		set(_WT_ARCH ia64)
		message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
	endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 32-bit
	set(_WT_ARCH x86)		 
endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

# Files to download

set( zlib_URL http://prdownloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz )
set( zlib_MD5 44d667c142d7cda120332623eab69f40 )
set( _PACKAGES ${_PACKAGES} zlib )

set( bzip2_URL http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz )
set( bzip2_MD5 00b516f4704d4a7cb50a1d97e6e8e15b )
set( _PACKAGES ${_PACKAGES} bzip2 )

set( libpng_URL http://sourceforge.net/projects/libpng/files/libpng14/older-releases/1.4.3/libpng-1.4.3.tar.gz ) 
set( libpng_MD5 df3521f61a1b8b69489d297c0ca8c1f8 )
set( _PACKAGES ${_PACKAGES} libpng )

set( libjpeg_URL http://www.ijg.org/files/jpegsrc.v8d.tar.gz )
set( libjpeg_MD5 52654eb3b2e60c35731ea8fc87f1bd29 )
set( _PACKAGES ${_PACKAGES} libjpeg )

set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.bz2 )
set( freetype_MD5 c72e9010b1d986d556fc0b2b5fcbf31a )
set( _PACKAGES ${_PACKAGES} freetype )

if(WIN32)
    set( openssl_URL https://github.com/openssl/openssl/archive/OpenSSL_1_0_1e.zip )
    set( openssl_MD5 5a8d690c6cd83f0c532a96f5bb55a0b8 )
else(WIN32)
    set( openssl_URL http://openssl.org/source/openssl-1.0.1e.tar.gz )
    set( openssl_MD5 66bf6f10f060d561929de96f9dfe5b8c )
endif(WIN32)
set( _PACKAGES ${_PACKAGES} openssl )

#set( libharu_URL http://libharu.org/files/libhpdf-2.3.0RC2.tar.bz2 )
#set( libharu_MD5 504afd61fc26b65279a2179a2b0aa948 )
set( libharu_URL https://github.com/libharu/libharu.git )
set( _PACKAGES ${_PACKAGES} libharu )

set( mariadb_URL http://mariadb.cu.be/client-native-1.0.0/Source/mariadb-native-client.tar.gz )
set( mariadb_NAME "mariadb-native-client.tar.gz" )
set( mariadb_MD5 3a6fb7b4fdda4fb247ed3474995ad4ff )
set( _PACKAGES ${_PACKAGES} mariadb )

set( boost_URL http://prdownloads.sourceforge.net/boost/boost_1_53_0.tar.bz2 )
set( boost_MD5 a00d22605d5dbcfb4c9936a9b35bc4c2 )
set( _PACKAGES ${_PACKAGES} boost )

set( tinymce_URL http://download.moxiecode.com/tinymce/tinymce_4.0.8.zip )
set( tinymce_MD5 62eab0051a20c617142cbcf64a1f4bef )
set( _PACKAGES ${_PACKAGES} tinymce )

set( wt_URL http://prdownloads.sourceforge.net/witty/wt-3.3.1.tar.gz )
set( wt_MD5 3e93152c0ba3feb4ee687e7370b27552 )
set( _PACKAGES ${_PACKAGES} wt )

if( WIN32 AND NOT UNIX )

    set( patch_URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip )
    set( patch_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905)
    set( _PACKAGES ${_PACKAGES} patch )

    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10.07/win32/nasm-2.10.07-win32.zip )
    set( nasm_MD5 1dafe433d8c83854188934617eec3032 )
    set( _PACKAGES ${_PACKAGES} nasm )
	
	set( nsis_URL http://prdownloads.sourceforge.net/nsis/nsis-2.46.zip )
	set( nsis_MD5 d7e43beabc017a7d892a3d6663e988d4 )
	set( _PACKAGES ${_PACKAGES} nsis )

#    if( FETCH_ONLY OR WTGIT )
        # set( 7zip_URL http://prdownloads.sourceforge.net/sevenzip/7za920.zip )
        # set( 7zip_MD5 2fac454a90ae96021f4ffc607d4c00f8 )
        # set( _PACKAGES ${_PACKAGES} 7zip )
        
        #set( git_ZIPFILE PortableGit-1.7.3.1-preview20101002.7z )
#        set( git_URL http://msysgit.googlecode.com/files/${git_ZIPFILE} )
#        SET( git_MD5 36c26ebc6b6e58d995efd994b8dd85f2 )
#        set( _PACKAGES ${_PACKAGES} git )
#    endif( FETCH_ONLY OR WTGIT )

    if( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
		set( perl_URL http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit-portable.zip )
		set( perl_MD5 2f00e848a678c425b9affb593c664537 )
		set( _PACKAGES ${_PACKAGES} perl )

		set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.3.1-1-windows-x64-binaries.zip )
		set( postgresql_MD5 d3425593ebda827b40b11798306bc6e3 )
		set( _PACKAGES ${_PACKAGES} postgresql )

		set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/graphicsmagick-binaries/1.3.18/GraphicsMagick-1.3.18-Q8-win64-dll.exe )
		set( graphicsmagick_MD5 bd25adb9e8218aabcd68a034116396e6 )
		set( _PACKAGES ${_PACKAGES} graphicsmagick )

		set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.2.26540-0_x64.zip )
		set( firebirdsql_MD5 069743c3ed3e8f62179dde3d93bb2333 )
		set( _PACKAGE ${_PACKAGES} firebirdsql )

    elseif( _WT_ARCH STREQUAL "x86" ) # Win 32-bit
    
        set( perl_URL http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-32bit-portable.zip )
        set (perl_MD5 8f3ef667e9a2b7fc402610da29bb8074 )
        set( _PACKAGES ${_PACKAGES} perl )

        set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.3.1-1-windows-binaries.zip )
        set( postgresql_MD5 3893bb12570ac3c450745a768fe11fe4 )
        set( _PACKAGES ${_PACKAGES} postgresql )
        
        set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.2.26540-0_Win32.zip )
        set( firebirdsql_MD5 ae81c884896c9c93ca7a55a4f5d86369 )
        set( _PACKAGE ${_PACKAGES} firebirdsql )
			
	elseif( _WT_ARCH STREQUAL "ia64" ) # Win Itanium
            message( ERROR "${_WT_ARCH} architecture is not supported by the Wt bootstrapper, please build manually." )
	else() #ARM	
            message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
    endif()

else( WIN32 AND NOT UNIX )

    set( patch_URL http://ftp.gnu.org/gnu/patch/patch-2.7.tar.bz2 )
    set( patch_MD5 1f3a075ea06705f194a2a4ce7045f072 )
    set( _PACKAGES ${_PACKAGES} patch )

    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10.07/nasm-2.10.07.tar.bz2 )
    set( nasm_MD5 af1cd6669f5e98148cd5ec42dee90f19 )
    set( _PACKAGES ${_PACKAGES} nasm )

    if( FETCH_ONLY OR WTGIT )
        set( git_URL https://git-core.googlecode.com/files/git-1.8.2.2.tar.gz )
        set( git_MD5 f7407df37facf579dcaa979266cc3c59 )
        set( _PACKAGES ${_PACKAGES} git )
    endif( FETCH_ONLY OR WTGIT )
    
    set( perl_URL http://www.cpan.org/src/5.0/perl-5.16.3.tar.gz )
    set( perl_MD5 eb5c40f2575df6c155bc99e3fe0a9d82 )
    set( _PACKAGES ${_PACKAGES} perl )

    set( postgresql_URL http://ftp3.de.postgresql.org/pub/Mirrors/ftp.postgresql.org/source/v9.3.1/postgresql-9.3.1.tar.bz2 )
    set( postgresql_MD5 c003d871f712d4d3895956b028a96e74 )
    set( _PACKAGES ${_PACKAGES} postgresql )

    set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/GraphicsMagick-1.3.18.tar.bz2 )
    set( graphicsmagick_MD5 b2c7f2fbfc0862525b047655953efd62 )
    set( _PACKAGES ${_PACKAGES} graphicsmagick )

    set( fcgi_URL http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz )
    set( fcgi_MD5 d15060a813b91383a9f3c66faf84867e )
    set( _PACKAGES ${_PACKAGES} fcgi )

    # TODO Move to pdcurses? (it's buildable on Win32 with nmake and others, might need win32a - http://www.projectpluto.com/win32a.htm )
    set( ncurses_URL http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz )
    set( ncurses_MD5 8cb9c412e5f2d96bc6f459aa8c6282a1 )
    set( _PACKAGES ${_PACKAGES} ncurses )
#    set( ncurses_URL http://prdownloads.sourceforge.net/pdcurses/PDCurses-3.4.tar.gz )
#    set( ncurses_MD5 4e04e4412d1b1392a7f9a489b95b331a )
#    set( _PACKAGES ${_PACKAGES} ncurses )

    set( fakerootng_URL http://prdownloads.sourceforge.net/fakerootng/fakeroot-ng-0.17.tar.gz )
    set( fakerootng_MD5 972b022a10cdeb0f61052982002f42b4 )
    set( _PACKAGES ${_PACKAGES} fakerootng )

    # TODO Build FirebirdSQL on Unix - On Windows, too?
    set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.2.26540-0.tar.bz2 )
    set( firebirdsql_MD5 21154d2004e025c8a3666625b0357bb5 )
    set( _PACKAGES ${_PACKAGES} firebirdsql )

endif( WIN32 AND NOT UNIX )

# If in fetch mode, only download and set a "fetch-only" indicator
if (FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
	message( STATUS "Downloading ${pkg}" )
        get_filename_component( fn ${${pkg}_URL} NAME )
        file( DOWNLOAD ${${pkg}_URL} ${WINST_BASEDIR}/downloads/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)
    
    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )
    
ELSE ( FETCH_ONLY )

    # GNU patch
    if( WIN32 AND NOT UNIX )
        ExternalProject_Add( patch
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
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
    else( WIN32 AND NOT UNIX )
        ExternalProject_Add( patch
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${patch_URL}
            URL_MD5 ${patch_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX}
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
	set( PATCH_EXECUTABLE ${WINST_PREFIX}/bin/patch )
    endif( WIN32 AND NOT UNIX )

    # Make sure autotools-based 3rd-parties use the bootstrapped libraries
    file( WRITE ${WINST_PREFIX}/share/config.site "CPPFLAGS='-I${WINST_PREFIX}/include'\nLDFLAGS='-L${WINST_PREFIX}/lib'\n" )

    # Netwide Assembler
    if( WIN32 AND NOT UNIX )
        ExternalProject_Add( nasm
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            URL ${nasm_URL}
            URL_MD5 ${nasm_MD5}
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
    else( WIN32 AND NOT UNIX )
        ExternalProject_Add( nasm
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${nasm_URL}
            URL_MD5 ${nasm_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX}
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( WIN32 AND NOT UNIX )

    # Perl - required for OpenSSL
    if( WIN32 AND NOT UNIX )
        ExternalProject_Add( perl
                DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
                URL ${perl_URL}
                URL_MD5 ${perl_MD5}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${WINST_PREFIX}/
                INSTALL_COMMAND ""
                LOG_DOWNLOAD 1
                LOG_UPDATE 1
                LOG_CONFIGURE 1
                LOG_BUILD 1
                LOG_TEST 1
                LOG_INSTALL 1
                )
    else( WIN32 AND NOT UNIX )
        ExternalProject_Add( perl
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${perl_URL}
            URL_MD5 ${perl_MD5}
            CONFIGURE_COMMAND ./Configure -de -Dprefix=${WINST_PREFIX}
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
        set( PERL_EXECUTABLE ${WINST_PREFIX}/bin/perl )
    endif( WIN32 AND NOT UNIX )
	
	if(WIN32)
        ExternalProject_Add( nsis
			DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
			URL ${nsis_URL}
			URL_MD5 ${nsis_MD5}
			CONFIGURE_COMMAND ""
			BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/
			INSTALL_COMMAND ""
			LOG_DOWNLOAD 1
			LOG_UPDATE 1
			LOG_CONFIGURE 1
			LOG_BUILD 1
			LOG_TEST 1
			LOG_INSTALL 1
			)
	endif(WIN32)

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/zlib)
    ExternalProject_Add( zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${zlib_URL}
        URL_MD5 ${zlib_MD5}
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
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
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

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/bzip2)
    ExternalProject_Add( bzip2
        DEPENDS patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${bzip2_URL}
        URL_MD5 ${bzip2_MD5}
		LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/bzip2.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
		TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/bzip2/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/libpng)
    ExternalProject_Add( libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${libpng_URL}
        URL_MD5 ${libpng_MD5}
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
#	LIST_SEPARATOR ^^
#	PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/libpng-export.patch
        CMAKE_ARGS 
	# -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
		-DCMAKE_BUILD_TYPE=Debug -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
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
#	LIST_SEPARATOR ^^
#	PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/libpng-export.patch
        CMAKE_ARGS 
	# -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
		-DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
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

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/libjpeg)
    ExternalProject_Add( libjpeg
        DEPENDS patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${libjpeg_URL}
        URL_MD5 ${libjpeg_MD5}
		LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/jpeg8.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
		TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/README ${WINST_PREFIX}/licenses/libjpeg/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/freetype)
    ExternalProject_Add( freetype
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${freetype_URL}
        URL_MD5 ${freetype_MD5}
		LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/freetype-2.5.0.1.diff
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX} 
		TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/docs/LICENSE.TXT ${WINST_PREFIX}/licenses/freetype/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    # OpenSSL requires some extra effort
    if( WIN32 AND NOT UNIX ) # Windows compilers but Cygwin
        if( _WT_ARCH STREQUAL "x64" ) # Windows 64-bit
        
            set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_win64a.bat" )
            if( MSVC ) # Visual C++
                if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
					set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_win64a.bat" )
                    set( OPENSSL_DEBUG_CONFIGURE_COMMAND "${WINST_PREFIX}/bin/perl Configure debug-VC-WIN64A --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_RELEASE_CONFIGURE_COMMAND "${WINST_PREFIX}/bin/perl Configure VC-WIN64A --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                elseif( CMAKE_SYSTEM_PROCESSOR STREQUAL IA64 )
					set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_win64i.bat" )
                    set( OPENSSL_DEBUG_CONFIGURE_COMMAND "${WINST_PREFIX}/bin/perl Configure debug-VC-WIN64I --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_RELEASE_CONFIGURE_COMMAND "${WINST_PREFIX}/bin/perl Configure VC-WIN64I --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
            else(MSVC) # Watcom? Borland 64-bit (not sure it exists) ? - This configuration won't work, probably
                set( OPENSSL_DEBUG_CONFIGURE_COMMAND "./config shared --prefix=${WINST_PREFIX}" )
                set( OPENSSL_RELEASE_CONFIGURE_COMMAND "./config shared --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )

        else( _WT_ARCH STREQUAL "x86" ) # Windows 32-bit
        
            if( MSVC )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_DEBUG_CONFIGURE_COMMAND "perl Configure debug-VC-WIN32 --prefix=${WINST_PREFIX}" )
                set( OPENSSL_RELEASE_CONFIGURE_COMMAND "perl Configure VC-WIN32 --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
            elseif( BORLAND )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_DEBUG_CONFIGURE_COMMAND "perl Configure debug-BC-32 no-asm --prefix=${WINST_PREFIX}" )
                set( OPENSSL_RELEASE_CONFIGURE_COMMAND "perl Configure BC-32 no-asm --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak install" )
            else(MSVC)
                set( OPENSSL_GENASM_COMMAND )
                set( OPENSSL_DEBUG_CONFIGURE_COMMAND ./config shared --prefix=${WINST_PREFIX} )
                set( OPENSSL_RELEASE_CONFIGURE_COMMAND ./config shared --prefix=${WINST_PREFIX} )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )
            
        endif()
    else( WIN32 AND NOT UNIX ) # Unix, Cygwin and MSYS
        set( OPENSSL_GENASM_COMMAND )

        if( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Mac OS X 64-bit
          set( OPENSSL_DEBUG_CONFIGURE_COMMAND ./Configure^^shared^^darwin64-x86_64-cc^^--prefix=${WINST_PREFIX} )
          set( OPENSSL_RELEASE_CONFIGURE_COMMAND ./Configure^^shared^^darwin64-x86_64-cc^^--prefix=${WINST_PREFIX} )
        else( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Mac OS X 32-bit and all other Unix platforms
          set( OPENSSL_DEBUG_CONFIGURE_COMMAND ./config^^shared^^--prefix=${WINST_PREFIX} )
          set( OPENSSL_RELEASE_CONFIGURE_COMMAND ./config^^shared^^--prefix=${WINST_PREFIX} )
        endif( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 )

        set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
        set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL}^^install )
    endif( WIN32 AND NOT UNIX )

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${WINST_PREFIX}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )
    ExternalProject_Add( openssl-release
        DEPENDS zlib perl patch nasm
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ${openssl_MD5}
		LIST_SEPARATOR ^^
        UPDATE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_RELEASE_CONFIGURE_COMMAND} -P ${WINST_BATDIR}/cmake/configure-openssl.cmake
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/openssl-library-names.patch
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND} -P ${WINST_BATDIR}/cmake/genasm-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -P ${WINST_BATDIR}/cmake/build-openssl.cmake
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND=${OPENSSL_INSTALL_COMMAND} -P ${WINST_BATDIR}/cmake/install-openssl.cmake
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( openssl-debug
        DEPENDS zlib perl patch nasm
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ${openssl_MD5}
		LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/openssl-library-names.patch
        UPDATE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_DEBUG_CONFIGURE_COMMAND} -P ${WINST_BATDIR}/cmake/configure-openssl.cmake
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND} -P ${WINST_BATDIR}/cmake/genasm-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -P ${WINST_BATDIR}/cmake/build-openssl.cmake
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND=${OPENSSL_INSTALL_COMMAND} -P ${WINST_BATDIR}/cmake/install-openssl.cmake
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
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ${openssl_MD5}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
		TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/openssl/
        )

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/mariadb)
    ExternalProject_Add( mariadb-fetch
        DEPENDS patch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${mariadb_URL}
        DOWNLOAD_NAME ${mariadb_NAME}
        URL_MD5 ${mariadb_MD5}
        LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/mariadb-native-client.patch
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
        DEPENDS mariadb-fetch zlib openssl
        SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS
          -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include
          -DCMAKE_BUILD_TYPE=Debug
	  -DCMAKE_MODULE_PATH:STRING=${WINST_MODULE_PATH}
          -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
          -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
	  -DSSL_PREFIX:STRING=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( mariadb-release
        DEPENDS mariadb-fetch zlib openssl
        SOURCE_DIR ${CMAKE_BINARY_DIR}/mariadb-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS
          -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include
          -DCMAKE_BUILD_TYPE=MinSizeRel
          -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
          -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
	  -DCMAKE_MODULE_PATH:STRING=${WINST_MODULE_PATH}
	  -DSSL_PREFIX:STRING=${WINST_PREFIX}
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


#    if( WIN32 AND NOT UNIX )
            # ExternalProject_Add( 7zip
            # DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            # URL ${7zip_URL}
            # URL_MD5 ${7zip_MD5}
            # CONFIGURE_COMMAND ""
            # BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/7za.exe ${WINST_PREFIX}/bin/
            # INSTALL_COMMAND ""
            # LOG_DOWNLOAD 1
            # LOG_UPDATE 1
            # LOG_CONFIGURE 1
            # LOG_BUILD 1
            # LOG_TEST 1
            # LOG_INSTALL 1
	    # )

#        ExternalProject_Add( git
#            DEPENDS 7zip
#            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
#            URL ${git_URL}
#            URL_MD5 ${git_MD5}
#            BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/git
#            INSTALL_COMMAND ""
#            LOG_DOWNLOAD 1
#            LOG_UPDATE 1
#            LOG_CONFIGURE 1
#            LOG_BUILD 1
#            LOG_TEST 1
#            LOG_INSTALL 1
#	    )
#        set( git_EXECUTABLE ${WINST_PREFIX}/git/bin/git.exe )
#    else( WIN32 AND NOT UNIX )
        
#    endif( WIN32 AND NOT UNIX )
    
    if( WIN32 AND NOT UNIX )
      ExternalProject_Add( postgresql
	    DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
	    URL ${postgresql_URL}
	    URL_MD5 ${postgresql_MD5}
	    CONFIGURE_COMMAND ""
	    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}
	    INSTALL_COMMAND ""
	    LOG_DOWNLOAD 1
	    LOG_UPDATE 1
	    LOG_CONFIGURE 1
	    LOG_BUILD 1
	    LOG_TEST 1
	    LOG_INSTALL 1
	    )
    else( WIN32 AND NOT UNIX )
        ExternalProject_Add( postgresql
	    DEPENDS perl openssl zlib
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${postgresql_URL}
            URL_MD5 ${postgresql_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX}  --without-readline
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( WIN32 AND NOT UNIX )

    # FastCGI - Only Unix, on Windows Wt builds the ISAPI connector
    if(NOT WIN32)
        ExternalProject_Add( fcgi
            DEPENDS patch
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${fcgi_URL}
            URL_MD5 ${fcgi_MD5}
            PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/fcgi-2.4.0-cstdiofix.patch
            CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX}
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif(NOT WIN32)

    if( UNIX )
		if(APPLE)
		  # http://stackoverflow.com/questions/3801011/ld-library-not-found-for-lcrt0-o-on-osx-10-6-with-gcc-clang-static-flag
		  set( PLATFORM_SPECIFIC_FLAGS -with-shared )
		endif(APPLE)
        ExternalProject_Add( ncurses
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
        URL ${ncurses_URL}
        URL_MD5 ${ncurses_MD5}
        CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX} ${PLATFORM_SPECIFIC_FLAGS} --with-shared --disable-rpath --without-progs --without-debug --without-ada
        BUILD_COMMAND ${CMAKE_BUILD_TOOL}
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
    endif(UNIX)
    
    if( UNIX )
        ExternalProject_Add( fakerootng
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${fakerootng_URL}
            URL_MD5 ${fakerootng_MD5}
            #PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BATDIR}/patches/fakerootng-0.18-fixBroken32Bit.patch
            CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )      
    endif( UNIX )

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/firebirdsql)
    if( WIN32 )
	# Download and extract firebird binaries. Or build it?
        ExternalProject_Add( firebirdsql
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
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
    else( WIN32 )
        #ExternalProject_Add( firebirdsql
	#    DEPENDS fakerootng
        #    DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
        #    URL ${firebirdsql_URL}
        #    URL_MD5 ${firebirdsql_MD5}
        #    CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX} --without-editline --enable-superserver --enable-shared
        #    BUILD_IN_SOURCE 1
        #    INSTALL_COMMAND ${WINST_PREFIX}/bin/fakeroot-ng ${CMAKE_BUILD_TOOL} -C gen install -f Makefile.install buildRoot && mv ./gen/buildRoot/* ${WINST_PREFIX}/
        #    LOG_DOWNLOAD 1
        #    LOG_UPDATE 1
        #    LOG_CONFIGURE 1
        #    LOG_BUILD 1
        #    LOG_TEST 1
        #    LOG_INSTALL 1
        #    )
    endif( WIN32 )

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/libharu)
    ExternalProject_Add( libharu-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        GIT_REPOSITORY ${libharu_URL}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
		TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/README ${WINST_PREFIX}/licenses/libharu/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
    )

    ExternalProject_Add( libharu-debug
        DEPENDS libharu-fetch zlib libpng patch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
	    -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libharu-release
        DEPENDS zlib libpng patch libharu-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libharu-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS 
	    -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_MODULE_PATH:PATH=${WINST_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
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

    # TODO GM seems impossible to build silently with Visual C++ :-/
    if( UNIX AND NOT WIN32 )
        ExternalProject_Add( graphicsmagick
            DEPENDS libpng zlib bzip2 libjpeg
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${graphicsmagick_URL}
            URL_MD5 ${graphicsmagick_MD5}
            CONFIGURE_COMMAND ./configure --enable-shared --prefix=${WINST_PREFIX}
            BUILD_COMMAND ${CMAKE_BUILD_TOOL}
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( UNIX AND NOT WIN32 )

	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/boost)
    if( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "bootstrap.bat" )
      set( boost_BJAM "bjam" )
      set( boost_LINKAGE link=static )
	  if(MSVC10)
		set( boost_TOOLSET toolset=msvc-10.0 )
	  elseif(MSVC11)
		set( boost_TOOLSET toolset=msvc-11.0 )
	  elseif(MSVC12)
		set( boost_TOOLSET toolset=msvc-12.0 )
	  endif()

	  if( _WT_ARCH STREQUAL "x64" ) # Win 64-bit
		set( boost_ADDRESS_MODEL address-model=64)
	  elseif( _WT_ARCH STREQUAL "x86" ) # Win 32-bit
		set( boost_ADDRESS_MODEL address-model=32)
      elseif( _WT_ARCH STREQUAL "ia64" )
		message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
	  endif( )
	  
    else( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "./bootstrap.sh" )
      set( boost_BJAM "./bjam" )
      set( boost_LINKAGE link=shared )
    endif( WIN32 AND NOT UNIX )
    set( boost_COMMAND ${boost_BJAM} --build-type=minimal ${boost_TOOLSET} ${boost_ADDRESS_MODEL} --variant=release --without-python ${boost_LINKAGE} threading=multi include=${WINST_PREFIX}/include linkflags=-L${WINST_PREFIX}/lib )
    ExternalProject_Add( boost
	DEPENDS zlib bzip2
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${boost_URL}
        URL_MD5 ${boost_MD5}
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
    
    if(WIN32)
	set( WT_WINDOWSONLY_DEPENDENCIES firebirdsql )
    endif(WIN32)

    if(UNIX)
        set( WT_UNIXONLY_DEPENDENCIES fcgi graphicsmagick )
    endif(UNIX)
    
    set( wt_CMAKE_ARGS
        -DSHARED_LIBS:BOOL=1
        -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX}
        -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules
        -DBoost_NO_SYSTEM_PATHS:BOOL=1
        -DBOOST_ROOT:PATH=${WINST_PREFIX}
        -DCONFIGDIR:PATH=${WINST_PREFIX}/etc/wt
        -DFCGI_PREFIX:PATH=${WINST_PREFIX}
        -DGM_PREFIX=${WINST_PREFIX}
        -DHARU_PREFIX=${WINST_PREFIX}
        -DPOSTGRES_PREFIX=${WINST_PREFIX}
        -DZLIB_PREFIX=${WINST_PREFIX}
        -DRUNDIR=${WINST_PREFIX}/var/run/wt
        -DSSL_PREFIX=${WINST_PREFIX}
        -DMYSQL_PREFIX=${WINST_PREFIX}
        -DMYSQL_LIBRARY=libmariadb
        -DEXAMPLES_DESTINATION=lib/Wt/examples
        )
		
	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/wt)
	file(MAKE_DIRECTORY ${WINST_PREFIX}/docs-to-install)
    IF(WIN32)
    set( wt_CMAKE_ARGS
        ${wt_CMAKE_ARGS}
        -DSSL_LIB_NAMES=ssleay32
        -DSSL_LIB_TOO_NAMES=libeay32
        -DENABLE_QT4:BOOL=0
       )
    ENDIF(WIN32)
    if( WTGIT )
        ExternalProject_Add( wt-fetch
            # git
            SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            GIT_REPOSITORY http://www.webtoolkit.eu/git/wt.git
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
			TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/wt/
        )
    else( WTGIT )
        ExternalProject_Add( wt-fetch
            SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            URL ${wt_URL}
            URL_MD5 ${wt_MD5}
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${WINST_PREFIX}/licenses/wt/
        )
    endif( WTGIT )

	ExternalProject_Get_Property( wt-fetch source_dir )
	
	file(MAKE_DIRECTORY ${WINST_PREFIX}/licenses/tinymce)
	file(MAKE_DIRECTORY ${source_dir}/resources/tiny_mce)
	ExternalProject_Add( tinymce
	DEPENDS wt-fetch
	DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
	URL ${tinymce_URL}
	URL_MD5 ${tinymce_MD5}
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/js/ ${source_dir}/resources/tiny_mce
	BUILD_COMMAND ${CMAKE_COMMAND} -E rename ${source_dir}/resources/tiny_mce/tinymce.min.js ${source_dir}/resources/tiny_mce/tiny_mce.js
	INSTALL_COMMAND ${CMAKE_COMMAND} -E remove ${source_dir}/resources/tiny_mce/license.txt
	TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/js/tinymce/license.txt ${WINST_PREFIX}/licenses/tinymce/
	LOG_DOWNLOAD 1
	LOG_UPDATE 1
	LOG_CONFIGURE 1
	LOG_BUILD 1
	LOG_TEST 1
	LOG_INSTALL 1
	)

    ExternalProject_Add( wt-debug
        DEPENDS tinymce wt-fetch
            zlib libpng libharu
            openssl boost
            ${WT_WINDOWSONLY_DEPENDENCIES} mariadb
            postgresql
            ${WT_UNIXONLY_DEPENDENCIES}
        SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=Debug ${wt_CMAKE_ARGS}            
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
    )
    ExternalProject_Add( wt-release
        DEPENDS tinymce wt-fetch
            zlib libpng libharu
            openssl boost
            ${WT_WINDOWSONLY_DEPENDENCIES} mariadb
            postgresql
            ${WT_UNIXONLY_DEPENDENCIES}
        SOURCE_DIR ${CMAKE_BINARY_DIR}/wt-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=MinSizeRel
            -DINSTALL_EXAMPLES:BOOL=1
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
		TEST_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/doc ${WINST_PREFIX}/docs-to-install
    )
	
#installation for windows
   INSTALL(DIRECTORY "${WINST_PREFIX}/licenses" DESTINATION "." COMPONENT binaries)
   INSTALL(DIRECTORY "${WINST_PREFIX}/include/Wt" DESTINATION "include" COMPONENT binaries)
   INSTALL(DIRECTORY "${WINST_PREFIX}/include/boost-1_53/boost" DESTINATION "include" COMPONENT binaries)
   INSTALL(DIRECTORY "${WINST_PREFIX}/docs-to-install/" DESTINATION "doc" COMPONENT documentation)
   FILE(GLOB boost_install_libs "${WINST_PREFIX}/lib/libboost*")
   INSTALL(FILES ${boost_install_libs} DESTINATION "lib" COMPONENT binaries)
   INSTALL(FILES "${WINST_PREFIX}/bin/zlibd.dll" "${WINST_PREFIX}/bin/zlib.dll" DESTINATION "bin" COMPONENT binaries)
   INSTALL(FILES "${WINST_PREFIX}/bin/ssleay32.dll" "${WINST_PREFIX}/bin/libeay32.dll" DESTINATION "bin" COMPONENT binaries)
   INSTALL(FILES "${WINST_PREFIX}/bin/ssleay32d.dll" "${WINST_PREFIX}/bin/libeay32d.dll" DESTINATION "bin" COMPONENT binaries)
   INSTALL(FILES "${WINST_PREFIX}/bin/libpng14.dll" "${WINST_PREFIX}/bin/libpng14d.dll" DESTINATION "bin" COMPONENT binaries)
#   INSTALL(FILES "${WINST_PREFIX}/bin/libpq.dll" "${WINST_PREFIX}/bin/libintl.dll" DESTINATION "bin" COMPONENT binaries)
   FILE(GLOB wt_install_libs "${WINST_PREFIX}/lib/wt*lib")
   INSTALL(FILES ${wt_install_libs} DESTINATION "lib" COMPONENT binaries)
   FILE(GLOB wt_install_dlls "${WINST_PREFIX}/bin/wt*dll")
   INSTALL(FILES ${wt_install_dlls} DESTINATION "bin" COMPONENT binaries)
   FILE(GLOB_RECURSE wt_install_examples "${WINST_PREFIX}/lib/Wt/*.exe")
   INSTALL(FILES ${wt_install_examples} DESTINATION "bin" COMPONENT examples)
   FILE(GLOB wt_all_bat "${WINST_PREFIX}/bin/*.bat")
   FOREACH(b ${wt_all_bat})
     FILE(READ ${b} bat_contents)
     IF(bat_contents MATCHES "This-is-a-wt-example")
       LIST(APPEND wt_install_examples_bat "${b}")
     ENDIF(bat_contents MATCHES "This-is-a-wt-example")
   ENDFOREACH(b ${wt_all_bat})
   INSTALL(FILES ${wt_install_examples_bat} DESTINATION "bin" COMPONENT examples)
   INSTALL(DIRECTORY "${WINST_PREFIX}/lib/Wt" DESTINATION "lib" COMPONENT binaries)
   INSTALL(DIRECTORY "${WINST_PREFIX}/share/Wt" DESTINATION "lib/share" COMPONENT binaries)


   # Compose a meaningful compiler string
   if(MSVC)
	set(_WT_COMPILER "msvc")
	if(MSVC10)
		set(_WT_COMPILER "${_WT_COMPILER}2010")
	elseif(MSVC11)
		set(_WT_COMPILER "${_WT_COMPILER}2012")
	elseif(MSVC12)
		set(_WT_COMPILER "${_WT_COMPILER}2013")
	else()
		set(_WT_COMPILER "${_WT_COMPILER}${MSVC_VERSION}")
	endif()
   elseif(CMAKE_COMPILER_IS_GNUCC)
		set(_WT_COMPILER "gcc") # TODO Use the specific mingw version, i. e. the output of uname
   endif()

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
   SET(CPACK_PACKAGE_VERSION_MAJOR "3")
   SET(CPACK_PACKAGE_VERSION_MINOR "3")
   SET(CPACK_PACKAGE_VERSION_PATCH "1")
   SET(CPACK_PACKAGE_INSTALL_DIRECTORY "Wt ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
   
   if(WIN32)
	SET(CPACK_GENERATOR "ZIP;NSIS")
   elseif(CMAKE_HOST_APPLE)
    SET(CPACK_GENERATOR "Bundle")
   else(WIN32)
    SET(CPACK_GENERATOR "TBZ2")
   endif(WIN32)
   
   set(CPACK_COMPONENTS_ALL binaries documentation examples)
   
   set(CPACK_COMPONENT_BINARIES_DISPLAY_NAME "Binaries")
   set(CPACK_COMPONENT_BINARIES_DESCRIPTION "Wt binaries and third party dependencies. Includes DLLs and import libraries.")
   set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
   set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Examples, ready to run. Source code is not included.")
   set(CPACK_COMPONENT_DOCUMENTATION_DISPLAY_NAME "Documentation")
   set(CPACK_COMPONENT_DOCUMENTATION_DESCRIPTION "Wt documentation in HTML format")
   
   set(CPACK_COMPONENT_BINARIES_REQUIRED TRUE)
   
   set(CPACK_COMPONENT_EXAMPLES_DEPENDS binaries)
   
   SET(CPACK_PACKAGE_FILE_NAME "Wt-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${_WT_COMPILER}-${CMAKE_SYSTEM_NAME}-${_WT_ARCH}-SDK")
   
   INCLUDE(CPack)
ENDIF( FETCH_ONLY )
