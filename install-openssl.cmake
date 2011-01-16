set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${WINST_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

message( STATUS "* OpenSSL - Installing..." )

separate_arguments( OPENSSL_INSTALL_COMMAND )

execute_process(
                COMMAND ${OPENSSL_INSTALL_COMMAND}
                WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
                OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-install2-out.txt
                ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-install2-err.txt
                OUTPUT_QUIET
                ERROR_QUIET
                )
