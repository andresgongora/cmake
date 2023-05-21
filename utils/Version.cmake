####################################################################################################
##
##  VERSION
##
##  Generate a version string header with a user-specified string or, alternatively,
##  information from Git in the following format:
##      - `v1.2.3`: on a clean commit tagged `v.1.2.3`.
##      - `v1.2.3-11-g1234abc`: on commit `g1234abc`, 11 commits ahead of the last tag.
##      - `v1.2.3-11-g1234abc-dirty`: same as above but there are uncommited changes.
##
##  Usage:
##  Simply include this script from your project's main CMakeLists.txt.
##  The default config values should work in most cases out of the box.
##
##  How it works:
##      1. Create configuration, some of which is available to the user.
##      2. Create a header tempalte file inside the build directory. This file contains a
##         @version@ clause that will be eventually replaced by the actual version string
##         when creating the file version output file (typically a header file).
##      3. Select the source from which to determine the project version.
##      4. Depending on the source, create a small auxiliary CMake script in the build folder.
##         This script will be invoked with every compilation to update the version header file
##         from step 2 by probing, for instance, git. This auxiliary script is needed because
##         we want it to run with EVERY new build, not only when we run CMake on the whole project.
##      5. Add a custom "version" target that will be a dependency of ALL other targets.
##         This script calls ${CMAKE_COMMAND} -P, where '-P' means that we want to run a script
##         file, specifying the script generated in step 4.
##
##  Notes:
##  - We want the script to run on every make because we have no simple way to check whether
##    there have been changes to Git (added a tag, a commit, the project becomes dirty, etc.).
##    We could create a custom command that depends on the .git directory, but I've found it
##    to be unreliable. If you read this, feel free to improve of this aspect of this script
##    and PR your suggestion :)
##
####################################################################################################

cmake_minimum_required(VERSION 3.11)

##==================================================================================================
## Configuration
##==================================================================================================
set(VERSION "git" CACHE STRING
    "Specify a version value or select an automatic source {git}")

set(VERSION_OUTPUT_FILE "${PROJECT_SOURCE_DIR}/version.h" CACHE FILEPATH
    "Path to output header file containing version string")

set(VERSION_CXX_FORMAT      "const char[]") # Type to store version string as
set(VERSION_CXX_VAR_NAME    "VERSION")      # Variable name to store version string in
set(GIT_IGNORE_FILE         ".gitignore")   # Path to gitignore file
set(GIT_IGNORE_APPEND       ON)             # If ON, adds $VERSION_OUTPUT_FILE to gitignore

##==================================================================================================
## Create version header file template
##==================================================================================================
set(VERSION_OUTPUT_FILE_TEMPLATE "${CMAKE_CURRENT_BINARY_DIR}${VERSION_OUTPUT_FILE}.in")

file(WRITE ${VERSION_OUTPUT_FILE_TEMPLATE}
    "#ifndef CMAKE_PROJECT_AUTO_VERSION_HEADER_\n"
    "#define CMAKE_PROJECT_AUTO_VERSION_HEADER_\n"
    "\n"
    "//------------------------------------------------------------------------------\n"
    "// DO NOT EDIT THIS FILE!\n"
    "//\n"
    "// This file was created by CMake and will be updated every time you configure\n"
    "// your project or (when the version is determined automatically) recompile.\n"
    "//\n"
    "// If the version string does not update correctly, make sure that your\n"
    "// CMakeLists.txt includes 'Version.cmake' and that your cached variables\n"
    "// in CMakeCache.txt are set correctly (consider using cmake-gui for this).\n"
    "//------------------------------------------------------------------------------\n"
    "\n"
    "${VERSION_CXX_FORMAT} ${VERSION_CXX_VAR_NAME} = \"@VERSION@\";\n"
    "\n"
    "#endif CMAKE_PROJECT_AUTO_VERSION_HEADER_\n"
)

##==================================================================================================
## Select source for version
##==================================================================================================
if(VERSION STREQUAL "git")
    set(VERSION_SOURCE "GIT")
else()
    ## If none of the above, assume VERSION contains a user-set version string
    set(VERSION_SOURCE "USER")
endif()

##==================================================================================================
## Create cmake script
##==================================================================================================
set(VERSION_UPDATER_SCRIPT_FILE "${CMAKE_CURRENT_BINARY_DIR}/VersionUpdater.cmake")

## Version set by user: just copy our current VERSION into the script
if(VERSION_SOURCE STREQUAL "USER")
    file(WRITE ${VERSION_UPDATER_SCRIPT_FILE}
        "
        cmake_minimum_required(VERSION 3.11)
        set(VERSION ${VERSION})
        configure_file(${VERSION_OUTPUT_FILE_TEMPLATE} ${VERSION_OUTPUT_FILE} @ONLY)
        message(\"-- Project version set to \\\"\${VERSION}\\\"\")
        "
    )

## Version will be determined from git: small script that invokes git
elseif(VERSION_SOURCE STREQUAL "GIT")
    file(WRITE ${VERSION_UPDATER_SCRIPT_FILE}
        "
        cmake_minimum_required(VERSION 3.11)

        find_package(Git)
        if(GIT_FOUND)
            ## Set <GIT_VERSION>
            execute_process(
                COMMAND \${GIT_EXECUTABLE} describe --tags --dirty --match \"v*\"
                OUTPUT_VARIABLE GIT_VERSION
                RESULT_VARIABLE GIT_VERSION_ERROR_CODE
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )

            ## Check for errors -> Determine cause of error -> overwrite <GIT_VERSION> accordingly
            if(GIT_VERSION_ERROR_CODE)
                ## Check if in a git repo
                execute_process(
                    COMMAND \${GIT_EXECUTABLE} git rev-parse --is-inside-work-tree
                    RESULT_VARIABLE GIT_REPO_ERROR_CODE
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                )

                ## Not in a git repo
                if(GIT_REPO_ERROR_CODE)
                    message(WARNING \"\${GIT_VERSION_ERROR_CODE}\")
                    set(GIT_VERSION \"v0.0-NOT-A-GIT-REPO\")

                ## Tag is likely invalid
                else()
                    message(WARNING \"git tag appears to be invalid: \${GIT_VERSION_ERROR_CODE}\")
                    set(GIT_VERSION \"v0.0-INVALID-GIT-TAG\")
                endif()
            endif()

        else()
            message(WARNING \"Git not found, unable to determine project version with Git\" )
            set(GIT_VERSION \"v0.0-GIT-NOT-FOUND\")

        endif()

        set(VERSION \${GIT_VERSION})
        configure_file(${VERSION_OUTPUT_FILE_TEMPLATE} ${VERSION_OUTPUT_FILE} @ONLY)
        message(\"-- Project version set to \\\"\${VERSION}\\\"\")
        "
    )

## Invalid version source. Really, the script should never reach this point
else()
    message(SEND_ERROR "Invalid project version source: ${VERSION_SOURCE}")
endif()

##==================================================================================================
## Add target to invoke auxiliary script during build
##==================================================================================================
add_custom_target("version"
    ALL
    COMMAND ${CMAKE_COMMAND} -P ${VERSION_UPDATER_SCRIPT_FILE}
    COMMENT "[Version.cmake] Update project version using ${VERSION_SOURCE} information"
)