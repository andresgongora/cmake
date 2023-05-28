# Copyright 2023 Andres Gongora <https://github.com/andresgongora/cmake>
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

####################################################################################################
##
##  GoogleTest
##
##  Add GoogleTest (aka GTest) to your project. GTest is mean as a small yet feature rich library
##  for unit testing.
##
##  Usage:
##      Simply include this script from your project's test CMakeLists.txt.
##      The default config values should work in most cases out of the box.
##      Then add GTest as a dependency to your targets. See the following example:
##          ```
##          include(../tools/cmake/utils/GoogleTest.cmake)
##          add_executable(test_main test_main.cpp)
##          target_link_libraries(test_main PRIVATE GTest::GTest)
##          ```
##
##  How it works:
##      1. Create config to choose version we want to download, etc.
##      2. Fetch GTest from github, it comes with its own CMake files.
##      3. Create our GTest::GTest library (it's essentialy empty)
##      4. Link our library with the actual GTest library (i.e., gtest_main)
##      5. Gtest::Gtest is now available to be linked
##
##  To do:
##      - Create a user-friendly function to add tests: https://hsf-training.github.io/hsf-training-cmake-webpage/11-functions/index.html
##
####################################################################################################

cmake_minimum_required(VERSION 3.11)

##==================================================================================================
## Configuration
##==================================================================================================
set(GOOGLE_TEST_GIT_TAG "release-1.11.0" CACHE STRING
    "Specify GoogleTest version to checkout")

set(GOOGLE_TEST_LIB_NAME "GTest::GTest" CACHE STRING
    "Name with which to make GTest available in your CMake project")

set(GOOGLE_TEST_GIT_REPOSITORY  "https://github.com/google/googletest.git")

##==================================================================================================
## Setup
##==================================================================================================
include(FetchContent)   # We need this to use 'FetchContent_Declare'
enable_testing()        # For convenience, we enable testing for the whole project

##==================================================================================================
## Fetch content and create library
##==================================================================================================

## Declare 'googletest' as a source for the repo; 'googletest' is just a hande here in CMake
FetchContent_Declare(
    googletest
    GIT_REPOSITORY  ${GOOGLE_TEST_GIT_REPOSITORY}
    GIT_TAG         ${GOOGLE_TEST_GIT_TAG}
)

## Fetch 'googletest', comes with its own CMakeLists files
FetchContent_MakeAvailable(googletest)

## Create the library (interface only) then link it with gtest_main.
## gtest_main takes care of everything for us, but we can write our own if we need to
## see https://google.github.io/googletest/primer.html#writing-the-main-function
## We could link our test project with gtest_main directly, if we wanted to.
add_library(${GOOGLE_TEST_LIB_NAME} INTERFACE IMPORTED )
target_link_libraries(${GOOGLE_TEST_LIB_NAME} INTERFACE gtest_main)

##==================================================================================================
## Verbose
##==================================================================================================
message(STATUS "[GoogleTest.cmake] GTest added to your project. CMake targets may link to \"${GOOGLE_TEST_LIB_NAME}\".")

#todo: EXCLUDE_FROM_ALL
