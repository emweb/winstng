set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${PROJECT_SOURCE_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

separate_arguments( OPENSSL_CONFIGURE_COMMAND )

message( STATUS "* OpenSSL - Configuring..." )

execute_process( 
                COMMAND ${OPENSSL_CONFIGURE_COMMAND}
                WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
                OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-configure2-out.txt
                ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-configure2-err.txt
                OUTPUT_QUIET
                ERROR_QUIET
                )
                