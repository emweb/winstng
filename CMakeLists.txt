project( winst )

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${PROJECT_SOURCE_DIR} )

# Files to download

#set( zlib_URL http://prdownloads.sourceforge.net/libpng/zlib125.zip )
#set( zlib_MD5 d6f1eef40a2dd3f17c63d24d8ca402c8 )
set( zlib_URL http://prdownloads.sourceforge.net/libpng/zlib-1.2.5.tar.bz2 )
set( zlib_MD5 be1e89810e66150f5b0327984d8625a0 )
set( _PACKAGES ${_PACKAGES} zlib )

#set( libpng_URL http://prdownloads.sourceforge.net/libpng/lpng150.zip )
#set( libpng_MD5 ee737ab0064e68b9b214ff96daa0d747 )
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

if( NOT MSVC )
    set( graphicsmagick_URL http://prdownloads.sourceforge.net/graphicsmagick/GraphicsMagick-1.3.12.tar.bz2 )
    set( graphicsmagick_MD5 55182f371f82d5f9367bce04e59bbf25 )
    set( _PACKAGES ${_PACKAGES} graphicsmagick )
endif( NOT MSVC )

if( WIN32 )

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
             
    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )

else( WIN32 )

    # Unix
    set( nasm_URL http://www.nasm.us/pub/nasm/releasebuilds/2.10rc3/nasm-2.10rc3.tar.bz2 )
    set( nasm_MD5 d5073fba836533a3f2bfa62f0fca98b2 )
    set( _PACKAGES ${_PACKAGES} nasm )

endif( WIN32 )

# If in fetch mode, only download and set a "fetch-only" indicator
if (FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
        get_filename_component( fn ${${pkg}_URL} NAME )
        file( DOWNLOAD ${${pkg}_URL} ${PROJECT_SOURCE_DIR}/downloads/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)
    
    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )
    
ELSE ( FETCH_ONLY )

    if( WIN32 )

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
                    
    else( APPLE )

        find_program( PATCH_EXECUTABLE patch )
        if( NOT PATCH_EXECUTABLE )
            message( ERROR "GNU patch is required" )
        endif( NOT PATCH_EXECUTABLE )

        find_program( PERL_FOUND perl )
        if( NOT PERL_FOUND )
            message( ERROR "Perl is required" )
        endif( NOT PERL_FOUND )
        
        ExternalProjectAdd( nasm
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${nasm_URL}
            URL_MD5 ${nasm_MD5}
            CONFIGURE_COMMAND ./configure --prefix=${PROJECT_SOURCE_DIR}
            BUILD_COMMAND make
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND make install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
            
        # TODO PostgreSQL
#        message( ERROR "Mac support to come, please build manually" )

    else( UNIX )

 #       message( ERROR "Unix support to come, please build manually" )
        
    endif( WIN32 )

#
# Build step
#
    ExternalProject_Add( zlib
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${zlib_URL}
        URL_MD5 ${zlib_MD5}
        PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/jpeg8.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/freetype-2.3.12.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
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
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/gd.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    # OpenSSL requires some extra effort
    if( WIN32 )
        if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 64-bit
        
            set( OPENSSL_GENASM_COMMAND "ms\\\\\\\\do_win64a.bat" )
            if( MSVC )
                if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
                    set( OPENSSL_CONFIGURE_COMMAND perl Configure VC-WIN64A --prefix=${PROJECT_SOURCE_DIR} )
                    set( OPENSSL_BUILD_COMMAND nmake -f ms/ntdll.mak )
                elseif( CMAKE_SYSTEM_PROCESSOR STREQUAL IA64 )
                    set( OPENSSL_CONFIGURE_COMMAND perl Configure VC-WIN64I --prefix=${PROJECT_SOURCE_DIR} )
                    set( OPENSSL_BUILD_COMMAND nmake -f ms/ntdll.mak )
                endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
            else(MSVC) # Cygwin and MinGW, there is no Borland 64-bit support in OpenSSL :-?
                set( OPENSSL_CONFIGURE_COMMAND ./config --prefix=${PROJECT_SOURCE_DIR} )
                set( OPENSSL_BUILD_COMMAND make )
            endif( MSVC )

        else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 32-bit
        
            if( MSVC )
                set( OPENSSL_GENASM_COMMAND ms\\\\\\\\do_nasm.bat )
                set( OPENSSL_CONFIGURE_COMMAND "perl Configure VC-WIN32 --prefix=${PROJECT_SOURCE_DIR}" )
                set( OPENSSL_BUILD_COMMAND nmake -f ms/ntdll.mak )
            elseif( BORLAND )
                set( OPENSSL_GENASM_COMMAND ms\\\\\\\\do_nasm.bat )
                set( OPENSSL_CONFIGURE_COMMAND perl Configure BC-32 no-asm --prefix=${PROJECT_SOURCE_DIR} )
                set( OPENSSL_BUILD_COMMAND make -f ms\\\\\\\\bcb.mak )
            else(MSVC) #Cygwin and MinGW
                set( OPENSSL_GENASM_COMMAND )
                set( OPENSSL_CONFIGURE_COMMAND ./config --prefix=${PROJECT_SOURCE_DIR} )
                set( OPENSSL_BUILD_COMMAND make )
            endif( MSVC )
            
        endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    else( WIN32 )
        set( OPENSSL_GENASM_COMMAND )
        set( OPENSSL_CONFIGURE_COMMAND ./config --prefix=${PROJECT_SOURCE_DIR} )
    endif( WIN32 )

    set( _OLDPATH $ENV{PATH} )
#    FILE( TO_NATIVE_PATH ${PROJECT_SOURCE_DIR}/bin LOCALBINDIR )
#    set( _NEWPATH ${LOCALBINDIR} ${_OLDPATH} )
    set( _NEWPATH ${PROJECT_SOURCE_DIR}/bin ${_OLDPATH})
    set( ENV{PATH} "${_NEWPATH}" )
    #message( STATUS "PATH = $ENV{PATH}" )
    ExternalProject_Add( openssl
        DEPENDS zlib perl patch nasm
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${openssl_URL}
        URL_MD5 ff8fb85610aef328315a9decbb2712e4
        #UPDATE_COMMAND ${OPENSSL_CONFIGURE_COMMAND}
        UPDATE_COMMAND ${CMAKE_COMMAND} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_CONFIGURE_COMMAND=${OPENSSL_CONFIGURE_COMMAND} -P ${PROJECT_SOURCE_DIR}/configure-openssl.cmake
   #    PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/openssl-1.0.0c.patch
   #     CONFIGURE_COMMAND ${OPENSSL_GENASM_COMMAND}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND} -P ${PROJECT_SOURCE_DIR}/genasm-openssl.cmake
        #BUILD_COMMAND ${OPENSSL_BUILD_COMMAND}
        BUILD_COMMAND ${CMAKE_COMMAND} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -P ${PROJECT_SOURCE_DIR}/build-openssl.cmake
        BUILD_IN_SOURCE 1
        #INSTALL_COMMAND ${OPENSSL_BUILD_COMMAND} install
        INSTALL_COMMAND ${CMAKE_COMMAND} -DOPENSSL_SOURCE_DIR=<SOURCE_DIR> -DOPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND} -DOPENSSL_INSTALL_COMMAND=${OPENSSL_BUILD_COMMAND} install -P ${PROJECT_SOURCE_DIR}/install-openssl.cmake
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
    ExternalProject_Add( libharu
        DEPENDS zlib libpng patch
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${libharu_URL}
        URL_MD5 ${libharu_MD5}
        PATCH_COMMAND ${PATCH_EXECUTABLE} -p1 < ${PROJECT_SOURCE_DIR}/libharu-2.2.1-cmake.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    # TODO GM seems impossible to build silently with Visual C++ :-/
    if( NOT MSVC )
        ExternalProject_Add( graphicsmagick
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads
            URL ${graphicsmagick_URL}
            URL_MD5 ${graphicsmagick_MD5}
            CONFIGURE_COMMAND ./configure
            BUILD_COMMAND make
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND make install
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
    endif( NOT MSVC )

    ExternalProject_Add( boost
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${boost_URL}
        URL_MD5 ${boost_MD5}
        CONFIGURE_COMMAND bootstrap.bat
        BUILD_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} --build-type=minimal --variant=release link=static threading=multi
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} install
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
        
    ExternalProject_Add( wt
        DEPENDS zlib libpng libharu openssl boost libgd2
        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
        URL ${wt_URL}
        URL_MD5 ${wt_MD5}
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
ENDIF( FETCH_ONLY )
