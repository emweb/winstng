set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${WINST_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

message( STATUS "* OpenSSL - Generating assembly code..." )
message( STATUS "* OpenSSL - ${OPENSSL_SOURCE_DIR}" )
message( STATUS "* OpenSSL - ${OPENSSL_GENASM_COMMAND}" )

if( OPENSSL_GENASM_COMMAND )
    execute_process( 
                    COMMAND ${OPENSSL_GENASM_COMMAND}
                    WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
                    OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-genasm-out.txt
                    ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-genasm-err.txt
#                    OUTPUT_QUIET
#                    ERROR_QUIET
                    )
endif( OPENSSL_GENASM_COMMAND )
