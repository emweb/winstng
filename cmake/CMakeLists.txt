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

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${WINST_PREFIX} )

# Files to download

set( zlib_URL http://prdownloads.sourceforge.net/libpng/zlib-1.2.7.tar.gz )
set( zlib_MD5 60df6a37c56e7c1366cca812414f7b85 )
set( _PACKAGES ${_PACKAGES} zlib )

set( bzip2_URL http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz )
set( bzip2_MD5 00b516f4704d4a7cb50a1d97e6e8e15b )
set( _PACKAGES ${_PACKAGES} bzip2 )

set( libpng_URL http://sourceforge.net/projects/libpng/files/libpng14/older-releases/1.4.3/libpng-1.4.3.tar.gz ) 
set( libpng_MD5 df3521f61a1b8b69489d297c0ca8c1f8 )
set( _PACKAGES ${_PACKAGES} libpng )

set( libjpeg_URL http://www.ijg.org/files/jpegsrc.v8b.tar.gz )
set( libjpeg_MD5 e022acbc5b36cd2cb70785f5b575661e )
set( _PACKAGES ${_PACKAGES} libjpeg )

set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.4.11.tar.bz2 )
set( freetype_MD5 b93435488942486c8d0ca22e8f768034 )
set( _PACKAGES ${_PACKAGES} freetype )

set( openssl_URL http://openssl.org/source/openssl-1.0.1e.tar.gz )
set( openssl_MD5 66bf6f10f060d561929de96f9dfe5b8c )
set( _PACKAGES ${_PACKAGES} openssl )

set( libharu_URL http://libharu.org/files/libhpdf-2.3.0RC2.tar.bz2 )
set( libharu_MD5 504afd61fc26b65279a2179a2b0aa948 )
set( _PACKAGES ${_PACKAGES} libharu )

set( boost_URL http://prdownloads.sourceforge.net/boost/boost_1_53_0.tar.bz2 )
set( boost_MD5  )
set( _PACKAGES ${_PACKAGES} boost )

set( wt_URL http://prdownloads.sourceforge.net/witty/wt-3.3.0.tar.gz )
set( wt_MD5 b2331942ad01c4fda376abf30c6a503a )
set( _PACKAGES ${_PACKAGES} wt )

if( WIN32 AND NOT UNIX )

    set( patch_URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip )
    set( patch_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905)
    set( _PACKAGES ${_PACKAGES} patch )

    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10.07/win32/nasm-2.10.07-win32.zip )
    set( nasm_MD5 1dafe433d8c83854188934617eec3032 )
    set( _PACKAGES ${_PACKAGES} nasm )

#    if( FETCH_ONLY OR WTGIT )
        # set( 7zip_URL http://prdownloads.sourceforge.net/sevenzip/7za920.zip )
        # set( 7zip_MD5 2fac454a90ae96021f4ffc607d4c00f8 )
        # set( _PACKAGES ${_PACKAGES} 7zip )
        
        #set( git_ZIPFILE PortableGit-1.7.3.1-preview20101002.7z )
#        set( git_URL http://msysgit.googlecode.com/files/${git_ZIPFILE} )
#        SET( git_MD5 36c26ebc6b6e58d995efd994b8dd85f2 )
#        set( _PACKAGES ${_PACKAGES} git )
#    endif( FETCH_ONLY OR WTGIT )

    if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Win 64-bit
        if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
            set( perl_URL http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit-portable.zip )
            set( perl_MD5 2f00e848a678c425b9affb593c664537 )
            set( _PACKAGES ${_PACKAGES} perl )

            set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.2.4-1-windows-x64-binaries.zip )
            set( postgresql_MD5 a0388908fdce75f9c642454c7435e898 )
            set( _PACKAGES ${_PACKAGES} postgresql )

	    set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/graphicsmagick-binaries/1.3.18/GraphicsMagick-1.3.18-Q8-win64-dll.exe )
	    set( graphicsmagick_MD5 bd25adb9e8218aabcd68a034116396e6 )
	    set( _PACKAGES ${_PACKAGES} graphicsmagick )

            set( mysql_URL http://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.6/mysql-5.6.11-winx64.zip )
            set( mysql_MD5 53f1eb50c241b54eb03b0560068663ba )
            set( _PACKAGES ${_PACKAGES} mysql )

	    set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.2.26540-0_Win32.zip )
	    set( firebirdsql_MD5 ae81c884896c9c93ca7a55a4f5d86369 )
	    set( _PACKAGE ${_PACKAGES} firebirdsql )

        else( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
            message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
            
        endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
    else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Win 32-bit
    
        set( perl_URL http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-32bit-portable.zip )
        set (perl_MD5 8f3ef667e9a2b7fc402610da29bb8074 )
        set( _PACKAGES ${_PACKAGES} perl )

        set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.2.4-1-windows-binaries.zip )
        set( postgesql_MD5 516ce6950a74646c80665435f74ae757 )
        set( _PACKAGES ${_PACKAGES} postgresql )

# GraphicsMagick-1.3.18-Q8-win32-dll.exe /VERYSILENT /NORESTART /DIR="c:\graphicsmagick" /NOICONS /SP-

	set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/graphicsmagick-binaries/1.3.18/GraphicsMagick-1.3.18-Q8-win32-dll.exe )
	set( graphicsmagick_MD5 9ea52d767dff3628c3918c5ee5774be1 )
	set( _PACKAGES ${_PACKAGES} graphicsmagick )
        
        set( mysql_URL http://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.6/mysql-5.6.11-win32.zip )
        set( mysql_MD5 55b368e4e139ed151cf4e16563ff451a )
        set( _PACKAGES ${_PACKAGES} mysql )


	set( firebirdsql_URL http://prdownloads.sourceforge.net/firebird/Firebird-2.5.2.26540-0_x64.zip )
	set( firebirdsql_MD5 069743c3ed3e8f62179dde3d93bb2333 )
	set( _PACKAGE ${_PACKAGES} firebirdsql )
             
    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

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

    set( postgresql_URL http://ftp3.de.postgresql.org/pub/Mirrors/ftp.postgresql.org/source/v9.2.4/postgresql-9.2.4.tar.bz2 )
    set( postgresql_MD5 6ee5bb53b97da7c6ad9cb0825d3300dd )
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

    # TODO Build MySQL on Unix - On Windows, too?
    set( mysql_URL http://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.6/mysql-5.6.11.tar.gz )
    set( mysql_MD5 9241be729964ab4594de11baa30aec48 )
    set( _PACKAGES ${_PACKAGES} mysql )

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
            INSTALL_COMMAND ""
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

    ExternalProject_Add( zlib
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${zlib_URL}
        URL_MD5 ${zlib_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

	    ExternalProject_Add( bzip2
            DEPENDS patch
	        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
	        URL ${bzip2_URL}
	        URL_MD5 ${bzip2_MD5}
		LIST_SEPARATOR ^^
	        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/bzip2.patch
	        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
	        LOG_DOWNLOAD 1
	        LOG_UPDATE 1
	        LOG_CONFIGURE 1
	        LOG_BUILD 1
	        LOG_TEST 1
	        LOG_INSTALL 1
	        )

    ExternalProject_Add( libpng
        DEPENDS zlib
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${libpng_URL}
        URL_MD5 ${libpng_MD5}
#	LIST_SEPARATOR ^^
#	PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/libpng-export.patch
        CMAKE_ARGS 
	# -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
	-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libjpeg
        DEPENDS patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${libjpeg_URL}
        URL_MD5 ${libjpeg_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/jpeg8.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
    ExternalProject_Add( freetype
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${freetype_URL}
        URL_MD5 ${freetype_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/freetype-2.3.12.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX} 
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    # OpenSSL requires some extra effort
    if( WIN32 AND NOT UNIX ) # Windows compilers but Cygwin
        if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Windows 64-bit
        
            set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_win64a.bat" )
            if( MSVC ) # Visual C++
                if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
                    set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN64A --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                elseif( CMAKE_SYSTEM_PROCESSOR STREQUAL IA64 )
                    set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN64I --prefix=${WINST_PREFIX}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
            else(MSVC) # Watcom? Borland 64-bit (not sure it exists) ? - This configuration won't work, probably
                set( OPENSSL_CONFIGURE_COMMAND "./config shared --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )

        else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Windows 32-bit
        
            if( MSVC )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN32 --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
            elseif( BORLAND )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_CONFIGURE_COMMAND "perl Configure BC-32 no-asm --prefix=${WINST_PREFIX}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak install" )
            else(MSVC)
                set( OPENSSL_GENASM_COMMAND )
                set( OPENSSL_CONFIGURE_COMMAND ./config shared --prefix=${WINST_PREFIX} )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )
            
        endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    else( WIN32 AND NOT UNIX ) # Unix, Cygwin and MSYS
        set( OPENSSL_GENASM_COMMAND )

        if( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Mac OS X 64-bit
          set( OPENSSL_CONFIGURE_COMMAND ./Configure^^shared^^darwin64-x86_64-cc^^--prefix=${WINST_PREFIX} )
        else( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Mac OS X 32-bit and all other Unix platforms
          set( OPENSSL_CONFIGURE_COMMAND ./config^^shared^^--prefix=${WINST_PREFIX} )
        endif( APPLE AND CMAKE_SIZEOF_VOID_P EQUAL 8 )

	set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
	set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL}^^install )
    endif( WIN32 AND NOT UNIX )

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${WINST_PREFIX}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )
    ExternalProject_Add( openssl
        DEPENDS zlib perl patch nasm
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ${openssl_MD5}
	LIST_SEPARATOR ^^
        UPDATE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_CONFIGURE_COMMAND} -P ${WINST_BASEDIR}/cmake/configure-openssl.cmake
   #    PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/openssl-1.0.1e.patch
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND} -P ${WINST_BASEDIR}/cmake/genasm-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -P ${WINST_BASEDIR}/cmake/build-openssl.cmake
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${WINST_PREFIX} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND=${OPENSSL_INSTALL_COMMAND} -P ${WINST_BASEDIR}/cmake/install-openssl.cmake
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
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
	    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${WINST_PREFIX}/
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
            PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/fcgi-2.4.0-cstdiofix.patch
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
    
    if( WIN32 )
	# Download and extract MySQL binaries. Or build it?
        ExternalProject_Add( mysql
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            URL ${mysql_URL}
            URL_MD5 ${mysql_MD5}
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
    else( WIN32 )
        ExternalProject_Add( mysql
	    DEPENDS zlib openssl ncurses
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${mysql_URL}
            URL_MD5 ${mysql_MD5}
	    LIST_SEPARATOR ^^
            CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCURSES_INCLUDE_PATH:PATH=${WINST_PREFIX}/include -DCURSES_CURSES_H_PATH:PATH=${WINST_PREFIX}/include -DCURSES_NCURSES_INCLUDE_PATH:PATH=${WINST_PREFIX}/include/ncurses -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( WIN32 )

    if( WIN32 )
	# Download and extract MySQL binaries. Or build it?
        ExternalProject_Add( firebirdsql
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            URL ${firebirdsql_URL}
            URL_MD5 ${firebirdsql_MD5}
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
    else( WIN32 )
        ExternalProject_Add( firebirdsql
	    DEPENDS 
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads
            URL ${firebirdsql_URL}
            URL_MD5 ${firebirdsql_MD5}
	    CONFIGURE_COMMAND ./configure --prefix=${WINST_PREFIX} --enable-superserver --enable-shared
	    BUILD_IN_SOURCE 1
	    INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( WIN32 )

    ExternalProject_Add( libharu
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${libharu_URL}
        URL_MD5 ${libharu_MD5}
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/libharu-2.3.0RC2.patch
        CMAKE_ARGS 
	    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
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
    else( UNIX AND NOT WIN32 )
      ExternalProject_Add( graphicsmagick
	    DOWNLOAD_NAME graphicsmagick.exe
	    DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
	    URL ${graphicsmagick_URL}
	    URL_MD5 ${graphicsmagick_MD5}
	    CONFIGURE_COMMAND ""
	    BUILD_COMMAND "<DOWNLOAD_DIR>graphicsmagick.exe /VERYSILENT /NORESTART /DIR=\"${WINST_PREFIX}\\bin\" /NOICONS /SP-"
	    INSTALL_COMMAND ""
	    LOG_DOWNLOAD 1
	    LOG_UPDATE 1
	    LOG_CONFIGURE 1
	    LOG_BUILD 1
	    LOG_TEST 1
	    LOG_INSTALL 1
	    )
    endif( UNIX AND NOT WIN32 )

    if( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "bootstrap.bat" )
      set( boost_BJAM "bjam" )
      set( boost_LINKAGE link=static )
    else( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "./bootstrap.sh" )
      set( boost_BJAM "./bjam" )
      set( boost_LINKAGE link=shared )
    endif( WIN32 AND NOT UNIX )
    set( boost_COMMAND ${boost_BJAM} --prefix=${WINST_PREFIX} --build-type=minimal --variant=release --without-python ${boost_LINKAGE} threading=multi include=${WINST_PREFIX}/include linkflags=-L${WINST_PREFIX}/lib )
    ExternalProject_Add( boost
	DEPENDS zlib bzip2
        DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
        URL ${boost_URL}
        URL_MD5 ${boost_MD5}
        CONFIGURE_COMMAND ${boost_BOOTSTRAP_COMMAND}
        BUILD_COMMAND ${boost_COMMAND}
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${boost_COMMAND} install
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
    
    if(UNIX)
        set( WT_UNIXONLY_DEPENDENCIES fcgi )
    endif(UNIX)
    
    set( wt_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${WINST_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${WINST_PREFIX} -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules -DBoost_NO_SYSTEM_PATHS:BOOL=1 -DBOOST_ROOT:PATH=${WINST_PREFIX} -DCONFIGDIR:PATH=${WINST_PREFIX}/etc/wt -DFCGI_PREFIX:PATH=${WINST_PREFIX} -DGM_PREFIX=${WINST_PREFIX} -DHARU_PREFIX=${WINST_PREFIX} -DPOSTGRES_PREFIX=${WINST_PREFIX} -DZLIB_PREFIX=${WINST_PREFIX} -DRUNDIR=${WINST_PREFIX}/var/run/wt -DINSTALL_EXAMPLES:BOOL=1 -DSSL_PREFIX=${WINST_PREFIX} -DEXAMPLES_DESTINATION=lib/Wt/examples )

    if( WTGIT )
        ExternalProject_Add( wtgit
            DEPENDS zlib libpng libharu openssl boost firebirdsql mysql ${WT_UNIXONLY_DEPENDENCIES}
            # git
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            GIT_REPOSITORY http://www.webtoolkit.eu/git/wt.git
            PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/wt-3.3.0.patch
            CMAKE_ARGS ${wt_CMAKE_ARGS}            
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
        )
    else( WTGIT )
        ExternalProject_Add( wt
            DEPENDS zlib libpng libharu openssl boost firebirdsql mysql ${WT_UNIXONLY_DEPENDENCIES}
            DOWNLOAD_DIR ${WINST_BASEDIR}/downloads 
            URL ${wt_URL}
            URL_MD5 ${wt_MD5}
            PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${WINST_BASEDIR}/patches/wt-3.3.0.patch
            CMAKE_ARGS ${wt_CMAKE_ARGS}            
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
        )
    endif( WTGIT )
    
ENDIF( FETCH_ONLY )
