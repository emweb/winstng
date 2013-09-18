# We define:
# - SSL_INCLUDE_DIRS
# - SSL_LIBRARIES
# - SSL_FOUND
# Taking into account:
# - SSL_PREFIX
#
# Remark for Win32 users: This file searches for both debug and release
# versions of the OpenSSL library. We assume that debug libs are compiled
# with /MDd, and release with /MD. Apparently that is what CMake uses for
# these modes; it is currently unclear to me if cmake ever uses /MT variants.

FIND_PATH(SSL_INCLUDE_DIRS openssl/ssl.h
  ${SSL_PREFIX}/include
)

IF(WIN32)
  FIND_LIBRARY(SSL_LIB_RELEASE
    NAMES
      ssleay32
    PATHS
      ${SSL_PREFIX}/lib
  )

  FIND_LIBRARY(SSL_LIB_DEBUG
    NAMES
    ssleay32d
    PATHS
      ${SSL_PREFIX}/lib
  )

  FIND_LIBRARY(SSL_TOO_LIB_RELEASE
    NAMES
      libeay32
    PATHS
      ${SSL_PREFIX}/lib
  )

  FIND_LIBRARY(SSL_TOO_LIB_DEBUG
    NAMES
      libeay32d
    PATHS
      ${SSL_PREFIX}/lib
  )

# We require both release and debug versions of the SSL libs. People who
# really know what they are doing, may edit this file to relax this requirement.
  IF(SSL_INCLUDE_DIRS
      AND SSL_LIB_RELEASE
      AND SSL_LIB_DEBUG
      AND SSL_TOO_LIB_RELEASE
      AND SSL_TOO_LIB_DEBUG)
      SET(SSL_FOUND true)
      SET(SSL_LIBRARIES
          optimized ${SSL_LIB_RELEASE} debug ${SSL_LIB_DEBUG}
          optimized ${SSL_TOO_LIB_RELEASE} debug ${SSL_TOO_LIB_DEBUG})
  ELSE(SSL_INCLUDE_DIRS
      AND SSL_LIB_RELEASE
      AND SSL_LIB_DEBUG
      AND SSL_TOO_LIB_RELEASE
      AND SSL_TOO_LIB_DEBUG)
      SET(SSL_FOUND false)
  ENDIF(SSL_INCLUDE_DIRS
      AND SSL_LIB_RELEASE
      AND SSL_LIB_DEBUG
      AND SSL_TOO_LIB_RELEASE
      AND SSL_TOO_LIB_DEBUG)
ELSE (WIN32)
  FIND_LIBRARY(SSL_LIB
    NAMES
      ssl
    PATHS
      /usr/lib
      /usr/local/lib
      ${SSL_PREFIX}/lib
  )
ENDIF (WIN32)

IF(SSL_LIB
    AND SSL_INCLUDE_DIRS)
  IF(WIN32)
    IF(SSL_TOO_LIB)
      SET(SSL_FOUND true)
      SET(SSL_LIBRARIES ${SSL_LIB} ${SSL_TOO_LIB})
    ELSE(SSL_TOO_LIB)
      SET(SSL_FOUND false)
    ENDIF(SSL_TOO_LIB)
  ELSE(WIN32)
    SET(SSL_FOUND true)
    SET(SSL_LIBRARIES ${SSL_LIB} -lcrypto)
  ENDIF(WIN32)
ENDIF(SSL_LIB
    AND SSL_INCLUDE_DIRS)

IF(SSL_FOUND)
  MESSAGE(STATUS "OpenSSL found: ${SSL_LIB} ${SSL_TOO_LIB}")
ELSE(SSL_FOUND)
  MESSAGE(STATUS "OpenSSL not found")
ENDIF(SSL_FOUND)


