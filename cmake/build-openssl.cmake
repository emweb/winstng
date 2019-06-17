set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${WINST_DIR}\\bin ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

message( STATUS "* OpenSSL - Compiling..." )

separate_arguments( OPENSSL_BUILD_COMMAND_WS UNIX_COMMAND "${OPENSSL_BUILD_COMMAND}" )

execute_process(
    COMMAND ${OPENSSL_BUILD_COMMAND_WS}
    WORKING_DIRECTORY ${OPENSSL_SOURCE_DIR}
    OUTPUT_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-build2-out.txt
    ERROR_FILE ${OPENSSL_SOURCE_DIR}-stamp/openssl-build2-err.txt
    OUTPUT_QUIET
    ERROR_QUIET
)
