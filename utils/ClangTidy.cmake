####################################################################################################
##
##  CLANG-TIDY
##
##  Clang-tidy is a tool that analyzes C++ code to find and suggest potential errors, style
##  violations, and performance improvements based on a set of customizable rules.
##
##  Usage:
##  Simply include this script from your project's main CMakeLists.txt.
##  The default config values should work in most cases out of the box.
##
## To do:
## - Add support for cross-compilation: https://discourse.cmake.org/t/using-clang-tidy-with-cross-compilation/5435
## -
##
####################################################################################################

cmake_minimum_required(VERSION 3.8)

##==================================================================================================
## Configuration
##==================================================================================================
set(CLANG_TIDY_ENABLE                       ON  CACHE BOOL "Enable clang-tidy linter checks")
set(CLANG_TIDY_SCAN_HEADERS                 ON  CACHE BOOL "Process header files")
set(CLANG_TIDY_WARNINGS_AS_ERRORS           OFF CACHE BOOL "Escalate warnings to errors")
set(CLANG_TIDY_USE_COLOR                    ON  CACHE BOOL "Use colors in diagnostics")

set(CLANG_TIDY_CHECK_BUGPRONE               ON  CACHE BOOL "Checks that target bug-prone code constructs")
set(CLANG_TIDY_CHECK_CERT                   ON  CACHE BOOL "Checks related to CERT Secure Coding Guidelines")
set(CLANG_TIDY_CHECK_CLANG_ANALYZER         ON  CACHE BOOL "Clang Static Analyzer checks")
set(CLANG_TIDY_CHECK_CONCURRENCY            ON  CACHE BOOL "Checks related to concurrent programming (including threads, fibers, coroutines, etc.)")
set(CLANG_TIDY_CHECK_CPP_CORE_GUIDELINES    ON  CACHE BOOL "Checks related to C++ Core Guidelines")
set(CLANG_TIDY_CHECK_CPP_MISC               ON  CACHE BOOL "Checks that we didn't have a better category for")
set(CLANG_TIDY_CHECK_MODERNIZE              ON  CACHE BOOL "Checks that advocate usage of modern (currently “modern” means “C++11”) language constructs")
set(CLANG_TIDY_CHECK_OBJC                   ON  CACHE BOOL "Checks related to Objective-C coding conventions")
set(CLANG_TIDY_CHECK_PERFORMANCE            ON  CACHE BOOL "Checks that target performance-related issues")
set(CLANG_TIDY_CHECK_PORTABILITY            ON  CACHE BOOL "Checks that target portability-related issues that don’t relate to any particular coding style")
set(CLANG_TIDY_CHECK_READABILITY            ON  CACHE BOOL "Checks that target readability-related issues that don’t relate to any particular coding style")

##==================================================================================================
## Return if clang-tidy disabled
##==================================================================================================
if(NOT CLANG_TIDY_ENABLE)
    return()
endif()

##==================================================================================================
## Parse options
##==================================================================================================
set(CLANG_TIDY_OPTIONS "--quiet")

if(CLANG_TIDY_SCAN_HEADERS)
    set(CLANG_TIDY_OPTIONS "${CLANG_TIDY_OPTIONS};-header-filter=.*")
endif()

if(CLANG_TIDY_USE_COLOR )
    set(CLANG_TIDY_OPTIONS "${CLANG_TIDY_OPTIONS};--use-color")
endif()

if(CLANG_TIDY_WARNINGS_AS_ERRORS)
    set(CLANG_TIDY_OPTIONS "${CLANG_TIDY_OPTIONS};--warnings-as-errors=*")
endif()

##==================================================================================================
## Parse checks
##==================================================================================================
set(CLANG_TIDY_CHECKS "-checks=-*")

if(CLANG_TIDY_CHECK_BUGPRONE)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},bugprone-*")
endif()

if(CLANG_TIDY_CHECK_CERT)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},cert-*")
endif()

if(CLANG_TIDY_CHECK_CLANG_ANALYZER)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},clang-analyzer-*")
endif()

if(CLANG_TIDY_CHECK_CONCURRENCY)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},concurrency-*")
endif()

if(CLANG_TIDY_CHECK_CPP_CORE_GUIDELINES)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},cppcoreguidelines-*")
endif()

if(CLANG_TIDY_CHECK_CPP_MISC)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},misc-*")
endif()

if(CLANG_TIDY_CHECK_MODERNIZE)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},modernize-*")
endif()

if(CLANG_TIDY_CHECK_OBJC)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},objc-*")
endif()

if(CLANG_TIDY_CHECK_PERFORMANCE)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},performance-*")
endif()

if(CLANG_TIDY_CHECK_PORTABILITY)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},portability-*")
endif()

if(CLANG_TIDY_CHECK_READABILITY)
    set(CLANG_TIDY_CHECKS "${CLANG_TIDY_CHECKS},readability-*")
endif()

# Check if no config applied, the fall back to default
if(${CLANG_TIDY_CHECKS} STREQUAL "-checks=-*")
    set(CLANG_TIDY_CHECKS "-checks=cppcoreguidelines-*")
endif()

##==================================================================================================
## Enable clang-tidy
##==================================================================================================
set(CMAKE_CXX_CLANG_TIDY "clang-tidy;${CLANG_TIDY_OPTIONS};${CLANG_TIDY_CHECKS}")

##==================================================================================================
## Exclude dependencies from clang-tidy checks
##==================================================================================================
# file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/_deps/.clang-tidy"
#     "Checks: '-*'"
# )
# Does not work yet