message( STATUS "*********** OPENSSL CONFIGURE STEP ****************" )
message( STATUS "WINST_DIR=${WINST_DIR}" )
message( STATUS "OPENSSL_SOURCE_DIR=${OPENSSL_SOURCE_DIR}" )
message( STATUS "OPENSSL_GENASM_COMMAND=${OPENSSL_GENASM_COMMAND}" )
message( STATUS "OPENSSL_CONFIGURE_COMMAND=${OPENSSL_CONFIGURE_COMMAND}" )
message( STATUS "OPENSSL_BUILD_COMMAND=${OPENSSL_BUILD_COMMAND}" )
message( STATUS "OPENSSL_INSTALL_COMMAND=${OPENSSL_INSTALL_COMMAND}" )
message( STATUS "****************************************************" )

set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${WINST_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

message( STATUS "* OpenSSL - Compiling..." )
message( STATUS "* OpenSSL build command = _${OPENSSL_BUILD_COMMAND}_" )
message( STATUS * OpenSSL build command (no quotes) = ${OPENSSL_BUILD_COMMAND} )
message( STATUS "* PATH = $ENV{PATH}" )

set( _OPENSSL_BUILD_COMMAND "${OPENSSL_BUILD_COMMAND}" )
separate_arguments( OPENSSL_BUILD_COMMAND )
execute_process( 
#                COMMAND ${OPENSSL_BUILD_COMMAND}
#                COMMAND nmake -f ms/ntdll.mak
                COMMAND ${OPENSSL_BUILD_COMMAND}
                WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
                OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-build2-out.txt
                ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-build2-err.txt
#                OUTPUT_QUIET
#                ERROR_QUIET
                )
