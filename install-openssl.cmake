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

message( STATUS "* OpenSSL - Installing..." )
#message( STATUS "OPENSSL_INSTALL_COMMAND = ${OPENSSL_INSTALL_COMMAND}")
separate_arguments( OPENSSL_INSTALL_COMMAND )
execute_process(
                COMMAND ${OPENSSL_INSTALL_COMMAND}
                WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
                OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-install2-out.txt
                ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-install2-err.txt
                OUTPUT_QUIET
                ERROR_QUIET
                )
