project( winst )

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)

# TODO MinGW support
# TODO Cross-compilation support. I think I only need to build nasm and patch for the host platform.
# TODO bzip2 ?

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${PROJECT_SOURCE_DIR} )

# Files to download

set( zlib_URL http://prdownloads.sourceforge.net/libpng/zlib-1.2.5.tar.bz2 )
set( zlib_MD5 be1e89810e66150f5b0327984d8625a0 )
set( _PACKAGES ${_PACKAGES} zlib )

set( libpng_URL http://prdownloads.sourceforge.net/libpng/libpng-1.5.0.tar.gz )
set( libpng_MD5 32a9f9c8f7f020bf7867a453d81fcb51 )
set( _PACKAGES ${_PACKAGES} libpng )

set( libjpeg_URL http://www.ijg.org/files/jpegsrc.v8b.tar.gz )
set( libjpeg_MD5 e022acbc5b36cd2cb70785f5b575661e )
set( _PACKAGES ${_PACKAGES} libjpeg )

set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.3.12.tar.bz2 )
set( freetype_MD5 e974a82e5939be8e05ee65f07275d7c5 )
set( _PACKAGES ${_PACKAGES} freetype )

set( libgd2_URL http://www.libgd.org/releases/gd-2.0.36RC1.tar.bz2 )
set( libgd2_MD5 e876979ca3130623a4e7866d9579171a )
set( _PACKAGES ${_PACKAGES} libgd2 )

set( openssl_URL http://openssl.org/source/openssl-1.0.0c.tar.gz )
set( openssl_MD5 ff8fb85610aef328315a9decbb2712e4 )
set( _PACKAGES ${_PACKAGES} openssl )

set( libharu_URL http://libharu.org/files/libharu-2.2.1.tar.bz2 )
set( libharu_MD5 4febd7e677b1c5d54db59a608b84e79f )
set( _PACKAGES ${_PACKAGES} libharu )

set( boost_URL http://prdownloads.sourceforge.net/boost/boost_1_45_0.tar.bz2 )
set( boost_MD5 d405c606354789d0426bc07bea617e58 )
set( _PACKAGES ${_PACKAGES} boost )

set( wt_URL http://prdownloads.sourceforge.net/witty/wt-3.1.7a.tar.gz )
set( wt_MD5 5725e1f45ed64811c3153f1e0e283b7d )
set( _PACKAGES ${_PACKAGES} wt )

if( WIN32 AND NOT UNIX )

    set( patch_URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip )
    set( patch_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905)
    set( _PACKAGES ${_PACKAGES} patch )

    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10rc3/win32/nasm-2.10rc3-win32.zip )
    set( nasm_MD5 c20205076b91a338dc13a3f6e63ef153)
    set( _PACKAGES ${_PACKAGES} nasm )

    if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Win 64-bit
        if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
            set( perl_URL http://downloads.activestate.com/ActivePerl/releases/5.12.2.1203/ActivePerl-5.12.2.1203-MSWin32-x64-294165.zip )
            set( perl_MD5 4e6e4ece324da1a5d8073faa9c1c53cf)
            set( _PACKAGES ${_PACKAGES} perl )

            set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.0.2-1-windows_x64-binaries.zip )
            set( postgresql_MD5 63b1a4fc268fd2a719fa65fa668575e2 )
            set( _PACKAGES ${_PACKAGES} postgresql )

            set( mysql_URL http://artfiles.org/mysql/Downloads/MySQL-5.1/mysql-noinstall-5.1.54-winx64.zip )
            set( mysql_MD5 b7e23ff588ac235a47b440cfbeffabcc )
            set( _PACKAGES ${_PACKAGES} mysql )

        else( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
            message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
            
        endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        
    else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Win 32-bit
    
        set( perl_URL http://downloads.activestate.com/ActivePerl/releases/5.12.2.1203/ActivePerl-5.12.2.1203-MSWin32-x86-294165.zip )
        set( perl_MD5 2119e59745a86a0f003b34998db14ffe)
        set( _PACKAGES ${_PACKAGES} perl )

        set( postgresql_URL http://get.enterprisedb.com/postgresql/postgresql-9.0.2-1-windows-binaries.zip )
        set( postgresql_MD5 5557b14f1a7e3824f47eaf1427467d1a)
        set( _PACKAGES ${_PACKAGES} postgresql )
        
        set( mysql_URL http://artfiles.org/mysql/Downloads/MySQL-5.1/mysql-noinstall-5.1.54-win32.zip )
        set( mysql_MD5 0b0d5477303a0ddf18b6d9d66e74180b )
        set( _PACKAGES ${_PACKAGES} mysql )
             
    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

else( WIN32 AND NOT UNIX )

    set( patch_URL http://ftp.gnu.org/gnu/patch/patch-2.6.1.tar.bz2 )
    set( patch_MD5 0818d1763ae0c4281bcdc63cdac0b2c0 )
    set( _PACKAGES ${_PACKAGES} patch )

    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10rc3/nasm-2.10rc3.tar.bz2 )
    set( nasm_MD5 d5073fba836533a3f2bfa62f0fca98b2 )
    set( _PACKAGES ${_PACKAGES} nasm )

    set( perl_URL http://www.cpan.org/src/5.0/perl-5.12.2.tar.gz )
    set( perl_MD5 af2df531d46b77fdf0d97eecb03eddb2 )
    set( _PACKAGES ${_PACKAGES} perl )

#    set( readline_URL http://ftp.gnu.org/gnu/readline/readline-6.1.tar.gz )
#    set( readline_MD5 fc2f7e714fe792db1ce6ddc4c9fb4ef3 )
#    set( _PACKAGES ${_PACKAGES} readline )

    set( postgresql_URL http://wwwmaster.postgresql.org/download/mirrors-ftp/source/v9.0.2/postgresql-9.0.2.tar.bz2 )
    set( postgresql_MD5 fc79ef32b602f75f2ccd37647bc008e9 )
    set( _PACKAGES ${_PACKAGES} postgresql )

#    set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/GraphicsMagick-1.3.12.tar.bz2 )
#    set( graphicsmagick_MD5 55182f371f82d5f9367bce04e59bbf25 )
#    set( _PACKAGES ${_PACKAGES} graphicsmagick )
    set( graphicsmagick_URL ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/snapshots/GraphicsMagick-1.4.020110109.tar.bz2 )
    set( graphicsmagick_MD5 6a92d27d7b326b176ff0dcfca828aa24 )
    set( _PACKAGES ${_PACKAGES} graphicsmagick )

    set( fcgi_URL http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz )
    set( fcgi_MD5 d15060a813b91383a9f3c66faf84867e )
    set( _PACKAGES ${_PACKAGES} fcgi )

    # TODO Move to pdcurses? (it's buildable on Win32 with nmake and others, might need win32a - http://www.projectpluto.com/win32a.htm )
    set( ncurses_URL http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz )
    set( ncurses_MD5 cce05daf61a64501ef6cd8da1f727ec6 )
    set( _PACKAGES ${_PACKAGES} ncurses )
#    set( ncurses_URL http://prdownloads.sourceforge.net/pdcurses/PDCurses-3.4.tar.gz )
#    set( ncurses_MD5 4e04e4412d1b1392a7f9a489b95b331a )
#    set( _PACKAGES ${_PACKAGES} ncurses )

    # TODO Build MySQL on Unix - On Windows, too?
    set( mysql_URL http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/MySQL-5.5/mysql-5.5.8.tar.gz )
    set( mysql_MD5 42e866302b61f5e213afd33e04677017 )
    set( _PACKAGES ${_PACKAGES} mysql )

    # TODO Build on Windows using Bakefile ( http://bakefile.org )
    set( mysqlpp_URL http://tangentsoft.net/mysql++/releases/mysql++-3.1.0.tar.gz )
    set( mysqlpp_MD5 d92769cc579b87a60e58a77099cc4f0e )
    set( _PACKAGES ${_PACKAGES} mysqlpp )

endif( WIN32 AND NOT UNIX )

# If in fetch mode, only download and set a "fetch-only" indicator
if (FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
	message( STATUS "Downloading ${pkg}" )
        get_filename_component( fn ${${pkg}_URL} NAME )
        file( DOWNLOAD ${${pkg}_URL} ${PROJECT_SOURCE_DIR}/downloads/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)
    
    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )
    
ELSE ( FETCH_ONLY )

    # GNU patch
    if( WIN32 AND NOT UNIX )
        ExternalProject_Add( patch
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
            URL ${patch_URL}
            URL_MD5 ${patch_MD5}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
            INSTALL_COMMAND ""
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
        set( PATCH_EXECUTABLE ${PROJECT_SOURCE_DIR}\\bin\\patch.exe )
    else( WIN32 AND NOT UNIX )
        ExternalProject_Add( patch
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${patch_URL}
            URL_MD5 ${patch_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
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
	set( PATCH_EXECUTABLE ${PROJECT_SOURCE_DIR}/bin/patch )
    endif( WIN32 AND NOT UNIX )

    # Make sure autotools-based 3rd-parties use the bootstrapped libraries
    file( WRITE ${PROJECT_SOURCE_DIR}/share/config.site "CPPFLAGS='-I${PROJECT_SOURCE_DIR}/include'\nLDFLAGS='-L${PROJECT_SOURCE_DIR}/lib'" )

    # Netwide Assembler
    if( WIN32 AND NOT UNIX )
        ExternalProject_Add( nasm
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
            URL ${nasm_URL}
            URL_MD5 ${nasm_MD5}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/bin
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
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${nasm_URL}
            URL_MD5 ${nasm_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
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
                DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                URL ${perl_URL}
                URL_MD5 ${perl_MD5}
                CONFIGURE_COMMAND ""
                BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${PROJECT_SOURCE_DIR}/
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
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${perl_URL}
            URL_MD5 ${perl_MD5}
            CONFIGURE_COMMAND ./Configure -de -Dprefix=${PROJECT_SOURCE_DIR}
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
        set( PERL_EXECUTABLE ${PROJECT_SOURCE_DIR}/bin/perl )
    endif( WIN32 AND NOT UNIX )

    ExternalProject_Add( zlib
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${zlib_URL}
        URL_MD5 ${zlib_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libpng
        DEPENDS zlib
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${libpng_URL}
        URL_MD5 ${libpng_MD5}
#	LIST_SEPARATOR ^^
#	PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/libpng-export.patch
        CMAKE_ARGS 
	# -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
	-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libjpeg
        DEPENDS patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${libjpeg_URL}
        URL_MD5 ${libjpeg_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/jpeg8.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
    ExternalProject_Add( freetype
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${freetype_URL}
        URL_MD5 ${freetype_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/freetype-2.3.12.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libgd2
        DEPENDS libpng zlib libjpeg patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${libgd2_URL}
        URL_MD5 ${libgd2_MD5}
	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/gd.patch
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
                    set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN64A --prefix=${PROJECT_SOURCE_DIR}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                elseif( CMAKE_SYSTEM_PROCESSOR STREQUAL IA64 )
                    set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN64I --prefix=${PROJECT_SOURCE_DIR}" )
                    set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                    set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
                endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
            else(MSVC) # Watcom? Borland 64-bit (not sure it exists) ? - This configuration won't work, probably
                set( OPENSSL_CONFIGURE_COMMAND "./config shared --prefix=${PROJECT_SOURCE_DIR}" )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )

        else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # Windows 32-bit
        
            if( MSVC )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN32 --prefix=${PROJECT_SOURCE_DIR}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms/ntdll.mak install" )
            elseif( BORLAND )
                set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
                set( OPENSSL_CONFIGURE_COMMAND "perl Configure BC-32 no-asm --prefix=${PROJECT_SOURCE_DIR}" )
                set( OPENSSL_BUILD_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak" )
                set( OPENSSL_INSTALL_COMMAND "${CMAKE_BUILD_TOOL} -f ms\\\\\\\\bcb.mak install" )
            else(MSVC)
                set( OPENSSL_GENASM_COMMAND )
                set( OPENSSL_CONFIGURE_COMMAND ./config shared --prefix=${PROJECT_SOURCE_DIR} )
                set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
                set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install )
            endif( MSVC )
            
        endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    else( WIN32 AND NOT UNIX ) # Unix, Cygwin and MSYS
        set( OPENSSL_GENASM_COMMAND )
        set( OPENSSL_CONFIGURE_COMMAND ./config^^shared^^--prefix=${PROJECT_SOURCE_DIR} )
	set( OPENSSL_BUILD_COMMAND ${CMAKE_BUILD_TOOL} )
	set( OPENSSL_INSTALL_COMMAND ${CMAKE_BUILD_TOOL}^^install )
    endif( WIN32 AND NOT UNIX )

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${PROJECT_SOURCE_DIR}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )
    ExternalProject_Add( openssl
        DEPENDS zlib perl patch nasm
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ff8fb85610aef328315a9decbb2712e4
	LIST_SEPARATOR ^^
        UPDATE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR:PATH=${PROJECT_SOURCE_DIR} -DOPENSSL_SOURCE_DIR:PATH=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND:STRING=${OPENSSL_CONFIGURE_COMMAND} -P ${PROJECT_SOURCE_DIR}/configure-openssl.cmake
   #    PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/openssl-1.0.0c.patch
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${PROJECT_SOURCE_DIR} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND} -P ${PROJECT_SOURCE_DIR}/genasm-openssl.cmake
        BUILD_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${PROJECT_SOURCE_DIR} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -P ${PROJECT_SOURCE_DIR}/build-openssl.cmake
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${CMAKE_COMMAND} -DWINST_DIR=${PROJECT_SOURCE_DIR} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_INSTALL_COMMAND=${OPENSSL_INSTALL_COMMAND} -P ${PROJECT_SOURCE_DIR}/install-openssl.cmake
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

#     ExternalProject_Add( readline
# 	DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
# 	URL ${readline_URL}
# 	URL_MD5 ${readline_MD5}
# 	CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
# 	BUILD_COMMAND ${CMAKE_BUILD_TOOL}
# 	BUILD_IN_SOURCE 1
# 	INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
# 	LOG_DOWNLOAD 1
# 	LOG_UPDATE 1
# 	LOG_CONFIGURE 1
# 	LOG_BUILD 1
# 	LOG_TEST 1
# 	LOG_INSTALL 1
# 	)
                    
    # PostgreSQL
    if( WIN32 AND NOT UNIX )
      ExternalProject_Add( postgresql
	    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
	    URL ${postgresql_URL}
	    URL_MD5 ${postgresql_MD5}
	    CONFIGURE_COMMAND ""
	    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
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
#	    DEPENDS readline perl openssl zlib
	    DEPENDS perl openssl zlib
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${postgresql_URL}
            URL_MD5 ${postgresql_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}  --without-readline
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
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${fcgi_URL}
            URL_MD5 ${fcgi_MD5}
            PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/fcgi-2.4.0-cstdiofix.patch
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
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
        ExternalProject_Add( ncurses
    ##	DEPENDS patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
        URL ${ncurses_URL}
        URL_MD5 ${ncurses_MD5}
    ##	PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/fcgi-2.4.0-cstdiofix.patch
        CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
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
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
            URL ${mysql_URL}
            URL_MD5 ${mysql_MD5}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
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
#	    DEPENDS zlib openssl readline
#	    DEPENDS zlib openssl ncurses readline
	    DEPENDS zlib openssl ncurses
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${mysql_URL}
            URL_MD5 ${mysql_MD5}
	    LIST_SEPARATOR ^^
            CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCURSES_NCURSES_INCLUDE_PATH:PATH=${PROJECT_SOURCE_DIR}/include -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( WIN32 )

	# TODO On Windows, use Bakefile to build
        ExternalProject_Add( mysqlpp
	    DEPENDS mysql openssl
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${mysqlpp_URL}
            URL_MD5 ${mysqlpp_MD5}
	    PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/mysql++-3.1.0.patch
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
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

#
# Build step
#
        
    ExternalProject_Add( libharu
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${libharu_URL}
        URL_MD5 ${libharu_MD5}
#	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/libharu-2.2.1-cmake.patch
        CMAKE_ARGS 
#	-DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
	    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${graphicsmagick_URL}
            URL_MD5 ${graphicsmagick_MD5}
            CONFIGURE_COMMAND ./configure --enable-shared --prefix=${PROJECT_SOURCE_DIR}
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

    if( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "bootstrap.bat" )
      set( boost_BJAM "bjam" )
    else( WIN32 AND NOT UNIX )
      set( boost_BOOTSTRAP_COMMAND "./bootstrap.sh" )
      set( boost_BJAM "./bjam" )
    endif( WIN32 AND NOT UNIX )
    ExternalProject_Add( boost
	DEPENDS zlib
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${boost_URL}
        URL_MD5 ${boost_MD5}
        CONFIGURE_COMMAND ${boost_BOOTSTRAP_COMMAND}
        BUILD_COMMAND ${boost_BJAM} --prefix=${PROJECT_SOURCE_DIR} --build-type=minimal --variant=release link=static threading=multi
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${boost_BJAM} --prefix=${PROJECT_SOURCE_DIR} install
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
    ExternalProject_Add( wt
        DEPENDS zlib libpng libharu openssl boost libgd2 fcgi
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${wt_URL}
        URL_MD5 ${wt_MD5}
#	LIST_SEPARATOR ^^
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/wt-3.1.7a.patch
        CMAKE_ARGS 
#	-DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include 
	-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules -DBoost_NO_SYSTEM_PATHS:BOOL=1 -DBOOST_ROOT:PATH=${PROJECT_SOURCE_DIR} -DCONFIGDIR:PATH=${PROJECT_SOURCE_DIR}/etc/wt -DFCGI_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DGM_PREFIX=${PROJECT_SOURCE_DIR} -DHARU_PREFIX=${PROJECT_SOURCE_DIR} -DPOSTGRES_PREFIX=${PROJECT_SOURCE_DIR} -DZLIB_PREFIX=${PROJECT_SOURCE_DIR} -DRUNDIR=${PROJECT_SOURCE_DIR}/var/run/wt -DEXAMPLES_DESTINATION=lib/Wt/examples
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
# 	TEST_AFTER_INSTALL 1
# 	TEST_COMMAND ${CMAKE_BUILD_TOOL} test
        )
ENDIF( FETCH_ONLY )
