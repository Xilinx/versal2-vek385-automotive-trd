#----------------------------------------------------------------
# Generated CMake target import file for configuration "debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "tuning::t_database_ext" for configuration "debug"
set_property(TARGET tuning::t_database_ext APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(tuning::t_database_ext PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "pthread;tuning::t_database_c"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libt_database_ext.so.6.1.0"
  IMPORTED_SONAME_DEBUG "libt_database_ext.so.6"
  )

list(APPEND _IMPORT_CHECK_TARGETS tuning::t_database_ext )
list(APPEND _IMPORT_CHECK_FILES_FOR_tuning::t_database_ext "${_IMPORT_PREFIX}/lib/libt_database_ext.so.6.1.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
