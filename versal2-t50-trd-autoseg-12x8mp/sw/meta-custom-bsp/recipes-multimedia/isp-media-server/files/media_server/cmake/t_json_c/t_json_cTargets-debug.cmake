#----------------------------------------------------------------
# Generated CMake target import file for configuration "debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "tuning::t_json_c" for configuration "debug"
set_property(TARGET tuning::t_json_c APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(tuning::t_json_c PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "pthread;tuning::t_common_c;m"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libt_json_c.so.6.1.0"
  IMPORTED_SONAME_DEBUG "libt_json_c.so.6"
  )

list(APPEND _IMPORT_CHECK_TARGETS tuning::t_json_c )
list(APPEND _IMPORT_CHECK_FILES_FOR_tuning::t_json_c "${_IMPORT_PREFIX}/lib/libt_json_c.so.6.1.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
