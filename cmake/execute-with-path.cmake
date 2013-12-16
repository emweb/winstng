set( _OLDPATH $ENV{PATH} )
set( _NEWPATH ${EXTRA_PATH} ${_OLDPATH} )
set( ENV{PATH} "${_NEWPATH}" )

message( STATUS "* postgres..." )

separate_arguments( COMMAND_WS UNIX_COMMAND "${THE_COMMAND}" )

execute_process( 
                #COMMAND ${COMMAND_WS}
                COMMAND ${THE_COMMAND}
                WORKING_DIRECTORY ${CWD}
                OUTPUT_FILE ${SOURCE_DIR}-stamp/skia-build2-out.txt
                ERROR_FILE ${SOURCE_DIR}-stamp/skia-build2-err.txt
                OUTPUT_QUIET
                ERROR_QUIET
                )
