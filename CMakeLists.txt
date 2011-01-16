project( winst )

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)
set(CMAKE_PREFIX_PATH ${PROJECT_SOURCE_DIR} )

# Set path. OpenSSL needs to find Perl in path
set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${PROJECT_SOURCE_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

#
# Download step
#

if( WIN32 )

    # There are not 64-bit binaries for GNU patch and nasm, use the 32-bit binaries on both cases

    if( FETCH_ONLY )
        set( patch_BUILD_COMMAND "" )
    else( FETCH_ONLY )
        set( patch_BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/ )
    endif( FETCH_ONLY )
    ExternalProject_Add( patch
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
            URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip
            URL_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905
            CONFIGURE_COMMAND ""
#                        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
            BUILD_COMMAND ${${patch_BUILD_COMMAND}}
            INSTALL_COMMAND ""
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )

    if( FETCH_ONLY )
        set( nasm_BUILD_COMMAND "" )
    else( FETCH_ONLY )
        set( nasm_BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/bin )
    endif( FETCH_ONLY )
    ExternalProject_Add( nasm
            DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
            URL http://www.nasm.us/pub/nasm/releasebuilds/2.10rc3/win32/nasm-2.10rc3-win32.zip
            URL_MD5 c20205076b91a338dc13a3f6e63ef153
            CONFIGURE_COMMAND ""
#            BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/bin
            BUILD_COMMAND ${${nasm_BUILD_COMMAND}}
            INSTALL_COMMAND ""
            LOG_DOWNLOAD 1
            LOG_UPDATE 1
            LOG_CONFIGURE 1
            LOG_BUILD 1
            LOG_TEST 1
            LOG_INSTALL 1
            )
            

    if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 64-bit
            if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )

                if( FETCH_ONLY )
                    set( perl_BUILD_COMMAND "" )
                else( FETCH_ONLY )
                    set( perl_BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${PROJECT_SOURCE_DIR}/ )
                endif( FETCH_ONLY )
                ExternalProject_Add( perl
                        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        URL http://downloads.activestate.com/ActivePerl/releases/5.12.2.1203/ActivePerl-5.12.2.1203-MSWin32-x64-294165.zip
                        URL_MD5 4e6e4ece324da1a5d8073faa9c1c53cf
                        CONFIGURE_COMMAND ""
#                        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${PROJECT_SOURCE_DIR}/
                        BUILD_COMMAND ${${perl_BUILD_COMMAND}}
                        INSTALL_COMMAND ""
                        LOG_DOWNLOAD 1
                        LOG_UPDATE 1
                        LOG_CONFIGURE 1
                        LOG_BUILD 1
                        LOG_TEST 1
                        LOG_INSTALL 1
                        )
                        
                if( FETCH_ONLY )
                    set( postgresql_BUILD_COMMAND "" )
                else( FETCH_ONLY )
                    set( postgresql_BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/ )
                endif( FETCH_ONLY )
                ExternalProject_Add( postgresql
                        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        URL http://get.enterprisedb.com/postgresql/postgresql-9.0.2-1-windows_x64-binaries.zip
                        URL_MD5 63b1a4fc268fd2a719fa65fa668575e2
                        CONFIGURE_COMMAND ""
#                        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
                        BUILD_COMMAND ${${postgresql_BUILD_COMMAND}}
                        INSTALL_COMMAND ""
                        LOG_DOWNLOAD 1
                        LOG_UPDATE 1
                        LOG_CONFIGURE 1
                        LOG_BUILD 1
                        LOG_TEST 1
                        LOG_INSTALL 1
                        )
                
            else( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
            
                message( ERROR "${CMAKE_SYSTEM_PROCESSOR} architecture is not supported by the Wt bootstrapper, please build manually." )
                
            endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )

    else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 32-bit

                # ExternalProject_Add( patch
                        # DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        # URL http://prdownloads.sourceforge.net/gnuwin32/patch-2.5.9-7-bin.zip
                        # URL_MD5 b9c8b31d62f4b2e4f1887bbb63e8a905
                        # CONFIGURE_COMMAND ""
                        # BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
                        # INSTALL_COMMAND ""
                        # LOG_DOWNLOAD 1
                        # LOG_UPDATE 1
                        # LOG_CONFIGURE 1
                        # LOG_BUILD 1
                        # LOG_TEST 1
                        # LOG_INSTALL 1
                        # )

                # ExternalProject_Add( nasm
                        # DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        # URL http://www.nasm.us/pub/nasm/releasebuilds/2.10rc3/win32/nasm-2.10rc3-win32.zip
                        # URL_MD5 c20205076b91a338dc13a3f6e63ef153
                        # CONFIGURE_COMMAND ""
                        # BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/bin
                        # INSTALL_COMMAND ""
                        # LOG_DOWNLOAD 1
                        # LOG_UPDATE 1
                        # LOG_CONFIGURE 1
                        # LOG_BUILD 1
                        # LOG_TEST 1
                        # LOG_INSTALL 1
                        # )

                if( FETCH_ONLY )
                    set( perl_BUILD_COMMAND "" )
                else( FETCH_ONLY )
                    set( perl_BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${PROJECT_SOURCE_DIR}/ )
                endif( FETCH_ONLY )
                ExternalProject_Add( perl
                        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        URL http://downloads.activestate.com/ActivePerl/releases/5.12.2.1203/ActivePerl-5.12.2.1203-MSWin32-x86-294165.zip
                        URL_MD5 2119e59745a86a0f003b34998db14ffe
                        CONFIGURE_COMMAND ""
#                        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/perl ${PROJECT_SOURCE_DIR}/
                        BUILD_COMMAND ${${perl_BUILD_COMMAND}}
                        INSTALL_COMMAND ""
                        LOG_DOWNLOAD 1
                        LOG_UPDATE 1
                        LOG_CONFIGURE 1
                        LOG_BUILD 1
                        LOG_TEST 1
                        LOG_INSTALL 1
                        )

                if( FETCH_ONLY )
                    set( _BUILD_COMMAND "" )
                else( FETCH_ONLY )
                    set( _BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/ )
                endif( FETCH_ONLY )
                ExternalProject_Add( postgresql
                        DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
                        URL http://get.enterprisedb.com/postgresql/postgresql-9.0.2-1-windows-binaries.zip
                        URL_MD5 5557b14f1a7e3824f47eaf1427467d1a
                        CONFIGURE_COMMAND ""
#                        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> ${PROJECT_SOURCE_DIR}/
                        BUILD_COMMAND ${${postgresql_BUILD_COMMAND}}
                        INSTALL_COMMAND ""
                        LOG_DOWNLOAD 1
                        LOG_UPDATE 1
                        LOG_CONFIGURE 1
                        LOG_BUILD 1
                        LOG_TEST 1
                        LOG_INSTALL 1
                        )
                            
    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
else( APPLE )

    message( ERROR "Mac support to come, please build manually" )

else( UNIX )

    message( ERROR "Unix support to come, please build manually" )
    
endif( WIN32 )

#
# Build step
#

if( FETCH_ONLY )
    set( zlib_PATCH_COMMAND "" )
    set( zlib_CMAKE_ARGS "" )
    set( zlib_BUILD_COMMAND )
else( FETCH_ONLY )
    set( zlib_PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h )
    set( zlib_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
    set( zlib_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( zlib
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://prdownloads.sourceforge.net/libpng/zlib125.zip
    URL_MD5 d6f1eef40a2dd3f17c63d24d8ca402c8
#    PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
    PATCH_COMMAND ${zlib_PATCH_COMMAND}
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${zlib_CMAKE_ARGS}}
    ${zlib_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )

if( FETCH_ONLY )
    set( libpng_BUILD_COMMAND "" )
    set( libpng_CMAKE_ARGS "" )
else( FETCH_ONLY )
    set( lib_BUILD_COMMAND )
    set( libpng_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
endif( FETCH_ONLY )
ExternalProject_Add( libpng
    DEPENDS zlib
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://prdownloads.sourceforge.net/libpng/lpng150.zip
    URL_MD5 ee737ab0064e68b9b214ff96daa0d747
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${libpng_CMAKE_ARGS}}
    ${libpng_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )

if( FETCH_ONLY )
    set( libjpeg_PATCH_COMMAND "" )
    set( libjpeg_CMAKE_ARGS "" )
    set( libjpeg_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( libjpeg_PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/jpeg8.patch )
    set( libjpeg_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
    set( libjpeg_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( libjpeg
    DEPENDS patch
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://www.ijg.org/files/jpegsrc.v8b.tar.gz
    URL_MD5 e022acbc5b36cd2cb70785f5b575661e
#    PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/jpeg8.patch
    PATCH_COMMAND ${${libjpeg_PATCH_COMMAND}}
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${libjpeg_CMAKE_ARGS}}
    ${libjpeg_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )
 
#TODO Update to 2.4.4
if( FETCH_ONLY )
    set( freetype_PATCH_COMMAND "" )
    set( freetype_CMAKE_ARGS "" )
    set( freetype_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( freetype_PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/freetype-2.3.12.patch )
    set( freetype_BUILD_COMMAND -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
    set( freetype_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( freetype
    DEPENDS zlib libpng patch
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://download.savannah.gnu.org/releases/freetype/freetype-2.3.12.tar.bz2
    URL_MD5 e974a82e5939be8e05ee65f07275d7c5
#    PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/freetype-2.3.12.patch
    PATCH_COMMAND ${${freetype_PATCH_COMMAND}}
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${freetype_CMAKE_ARGS}}
    ${freetype_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )

if( FETCH_ONLY )
    set( gd_PATCH_COMMAND "" )
    set( gd_CMAKE_ARGS "" )
    set( gd_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( gd_PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/gd.patch )
    set( gd_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
    set( gd_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( gd
    DEPENDS libpng zlib libjpeg patch
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://www.libgd.org/releases/gd-2.0.36RC1.tar.bz2
    URL_MD5 e876979ca3130623a4e7866d9579171a
#    PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/gd.patch
    PATCH_COMMAND ${${gd_PATCH_COMMAND}}
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${gd_CMAKE_ARGS}}
    ${gd_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )

#OpenSSL requires some extra effort
set( openssl_PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/openssl-1.0.0c.patch )
if( WIN32 )
    if( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 64-bit
    
        set( _OPENSSL_openssl_COMMAND "ms\\\\\\\\do_win64a.bat" )
        if( MSVC )
            if( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
                set( _openssl_CONFIGURE_COMMAND "perl Configure VC-WIN64A --prefix=${PROJECT_SOURCE_DIR}" )
                set( _openssl_BUILD_COMMAND nmake -f ms/ntdll.mak )
            elseif( CMAKE_SYSTEM_PROCESSOR STREQUAL IA64 )
                set( _openssl_CONFIGURE_COMMAND "perl Configure VC-WIN64I --prefix=${PROJECT_SOURCE_DIR}" )
                set( _openssl_BUILD_COMMAND nmake -f ms/ntdll.mak )
            endif( CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64 )
        else(MSVC) # Cygwin and MinGW, there is no Borland 64-bit support in OpenSSL :-?
            set( _openssl_CONFIGURE_COMMAND "./config --prefix=${PROJECT_SOURCE_DIR}" )
            set( _openssl_BUILD_COMMAND make )
        endif( MSVC )

    else( CMAKE_SIZEOF_VOID_P EQUAL 8 ) # 32-bit
    
        if( MSVC )
            set( _openssl_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
            set( _openssl_CONFIGURE_COMMAND perl Configure VC-WIN32 --prefix=${PROJECT_SOURCE_DIR} )
            set( _openssl_BUILD_COMMAND nmake -f ms/ntdll.mak )
        elseif( BORLAND )
            set( _openssl_GENASM_COMMAND "ms\\\\\\\\do_nasm.bat" )
            set( _openssl_CONFIGURE_COMMAND "perl Configure BC-32 no-asm --prefix=${PROJECT_SOURCE_DIR}" )
            set( _openssl_BUILD_COMMAND make -f ms\\\\\\\\bcb.mak )
        else(MSVC) #Cygwin and MinGW
            set( _openssl_GENASM_COMMAND )
            set( _openssl_CONFIGURE_COMMAND "./config --prefix=${PROJECT_SOURCE_DIR}" )
            set( _openssl_BUILD_COMMAND make )
        endif( MSVC )
        
    endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
else( WIN32 )
    set( _openssl_GENASM_COMMAND )
    set( _openssl_CONFIGURE_COMMAND "./config --prefix=${PROJECT_SOURCE_DIR}" )
endif( WIN32 )

if( FETCH_ONLY )
    set( openssl_GENASM_COMMAND "" )
    set( openssl_CONFIGURE_COMMAND "" )
    set( openssl_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( openssl_GENASM_COMMAND ${_openssl_GENASM_COMMAND} )
    set( openssl_CONFIGURE_COMMAND ${_openssl_CONFIGURE_COMMAND} )
    set( openssl_BUILD_COMMAND ${_openssl_BUILD_COMMAND} )
endif( FETCH_ONLY )
ExternalProject_Add( openssl
    DEPENDS zlib perl patch nasm
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://openssl.org/source/openssl-1.0.0c.tar.gz
    URL_MD5 ff8fb85610aef328315a9decbb2712e4
#    UPDATE_COMMAND ${_openssl_CONFIGURE_COMMAND}
    UPDATE_COMMAND ${openssl_CONFIGURE_COMMAND}
##    PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/openssl-1.0.0c.patch
#    PATCH_COMMAND ${openssl_PATCH_COMMAND}
#    CONFIGURE_COMMAND ${_openssl_GENASM_COMMAND}
    CONFIGURE_COMMAND ${openssl_GENASM_COMMAND}
    BUILD_COMMAND ${OPENSSL_BUILD_COMMAND}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ${OPENSSL_BUILD_COMMAND} install
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )
    
if( FETCH_ONLY )
    set( libharu_PATCH_COMMAND "" )
    set( libharu_CMAKE_ARGS "" )
    set( libharu_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( libharu_PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/libharu-2.2.1-cmake.patch )
    set( libharu_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} )
    set( libharu_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( libharu
    DEPENDS zlib libpng patch
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://libharu.org/files/libharu-2.2.1.tar.bz2
    URL_MD5 4febd7e677b1c5d54db59a608b84e79f
#    PATCH_COMMAND ${PROJECT_SOURCE_DIR}/bin/patch.exe -p1 < ${PROJECT_SOURCE_DIR}/libharu-2.2.1-cmake.patch
    PATCH_COMMAND ${${libharu_PATCH_COMMAND}}
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}
    CMAKE_ARGS ${${libharu_CMAKE_ARGS}}
    ${libharu_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )

# TODO GraphicsMagick
# GM seems impossible to build silently with Visual C++ :-/


if( FETCH_ONLY )
    set( boost_CONFIGURE_COMMAND "" )
    set( boost_BUILD_COMMAND "" )
    set( boost_INSTALL_COMMAND "" )
else( FETCH_ONLY )
    set( boost_CONFIGURE_COMMAND bootstrap.bat )
    set( boost_BUILD_COMMAND BUILD_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} --build-type=minimal --variant=release link=static threading=multi )
    set( boost_INSTALL_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} install )
endif( FETCH_ONLY )
ExternalProject_Add( boost
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://prdownloads.sourceforge.net/boost/boost_1_45_0.tar.bz2
    URL_MD5 d405c606354789d0426bc07bea617e58
#    CONFIGURE_COMMAND bootstrap.bat
    CONFIGURE_COMMAND ${boost_CONFIGURE_COMMAND}
#    BUILD_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} --build-type=minimal --variant=release link=static threading=multi
    ${boost_BUILD_COMMAND}
    BUILD_IN_SOURCE 1
#    INSTALL_COMMAND bjam --prefix=${PROJECT_SOURCE_DIR} install
    INSTALL_COMMAND ${${boost_INSTALL_COMMAND}}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )
    
if( FETCH_ONLY )
    set( wt_CMAKE_ARGS "" )
    set( wt_BUILD_COMMAND "" )
else( FETCH_ONLY )
    set( wt_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules )
    set( wt_BUILD_COMMAND )
endif( FETCH_ONLY )
ExternalProject_Add( wt
    DEPENDS zlib libpng libharu openssl boost gd
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}/downloads 
    URL http://prdownloads.sourceforge.net/witty/wt-3.1.7a.tar.gz
    URL_MD5 5725e1f45ed64811c3153f1e0e283b7d
#    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_SOURCE_DIR} -DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR} -DWT_CMAKE_FINDER_INSTALL_DIR:PATH=/share/cmake-2.8/Modules
    CMAKE_ARGS ${${CMAKE_ARGS}}
    ${wt_BUILD_COMMAND}
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
    )
