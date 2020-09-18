

cmake_minimum_required(VERSION 2.8)

project(Bits)

set(SF_MODPATH "${CMAKE_SOURCE_DIR}/cmakemodules/")

add_subdirectory(cif2cry)
add_subdirectory(convplat)
add_subdirectory(Diffractometers)
add_subdirectory(shelxs)
add_subdirectory(shelx2cry)
if ( ( NOT Fortran_COMPILER_NAME MATCHES "gfortran") AND ( NOT APPLE ) AND ( useGUI ) )
  add_subdirectory(sir92)
endif()


