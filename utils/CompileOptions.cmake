####################################################################################################
##
##  COMPILE OPTIONS
##
##
####################################################################################################

cmake_minimum_required(VERSION 3.11)

##==================================================================================================
## Configuration
##==================================================================================================


##==================================================================================================
## Compile options
##==================================================================================================
set(CMAKE_CXX_STANDARD          11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS        OFF)

set(CMAKE_CXX_FLAGS "-Wall -Werror -O0 -g --pedantic -fdiagnostics-color=always")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)
