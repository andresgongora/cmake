# Copyright 2023 Andres Gongora <https://github.com/andresgongora/cmake>
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

include_guard()
cmake_minimum_required(VERSION 3.13)
find_package(Python COMPONENTS Interpreter REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/AddTargetCommandPair.cmake")

####################################################################################################
##
##  RUN PYTHON COMMAND
##
##  Run python with a given argument (e.g., a python command, or invoke it with a script),
##  with the ability to specify a requirements file that should be installed with pip.
##
##  ```
##  run_python_command(
##      <TARGET_NAME>
##      PYTHON          <PYTHON_COMMAND>
##      [COMMENT        <COMMENT_TO_PRINT_DURING_EXECUTION>]
##      [REQUIREMENTS   <PATH_TO_REQUIREMENTS_FILE_FOR_PIP_TO_INSTALL>]
##      [DEPENDS        <DEPENDENCY> <DEPENDENCY> <DEPENDENCY>...]
##  )
##  ```
##
####################################################################################################
function(run_python_command TARGET_NAME)

    ##----------------------------------------------------------------------------------------------
    ## Function arguments
    ##
    set(ARG_OPTIONS)
    set(ARG_SINGLE_VALUE    PYTHON COMMENT REQUIREMENTS)
    set(ARG_MULTI_VALUE     DEPENDS)

    cmake_parse_arguments(
        RUN_PYTHON "${ARG_OPTIONS}" "${ARG_SINGLE_VALUE}" "${ARG_MULTI_VALUE}" ${ARGN} )

    if(NOT RUN_PYTHON_PYTHON)
        message(FATAL_ERROR "Must provide an argument for python in argument 'PYTHON'")
    endif()

    ##----------------------------------------------------------------------------------------------
    ## Add target to run command during compilation
    ##
    message(DEBUG "Adding target to run '${Python_EXECUTABLE} ${RUN_PYTHON_COMMAND}'")

    add_target_command_pair(
        ${TARGET_NAME}
        ALL
        COMMAND "${Python_EXECUTABLE} ${RUN_PYTHON_PYTHON}"
        DEPENDS ${RUN_PYTHON_DEPENDS}
        COMMENT ${RUN_PYTHON_COMMENT}
    )

    ##----------------------------------------------------------------------------------------------
    ## Install requirements (if any)
    ## Use pip to install all requirements from a requirements file (typ. requirements.txt)
    ##
    if(RUN_PYTHON_REQUIREMENTS)

        set(REQUIREMENTS_TARGET "${TARGET_NAME}_requirements_pip_install")

        ## Check that Pip is installed and runs as espextec
        execute_process(
            COMMAND ${Python_EXECUTABLE} -m pip -V
            RESULT_VARIABLE EXIT_CODE
            OUTPUT_QUIET
        )

        if(NOT ${EXIT_CODE} EQUAL 0)
            message(FATAL_ERROR "Python pip not found, pip is required")
        endif()

        ## Check that the provided requirements file exists
        if(NOT EXISTS ${RUN_PYTHON_REQUIREMENTS})
            message(SEND_ERROR "Provided requirements file not found: ${RUN_PYTHON_REQUIREMENTS}")
        endif()

        ## Install requirements (during compilation)
        add_target_command_pair(
            ${REQUIREMENTS_TARGET}
            COMMAND "${Python_EXECUTABLE} -m pip install -r ${RUN_PYTHON_REQUIREMENTS} --upgrade -t ${CMAKE_CURRENT_BINARY_DIR}/pip-dependencies/"
            COMMENT "Python pip installing ${REQUIREMENTS_FILE}"
            DEPENDS ${RUN_PYTHON_REQUIREMENTS}
        )

        ## Add requirements target as a dependency of the above python command target
        add_dependencies(${TARGET_NAME} ${REQUIREMENTS_TARGET})

    endif()

endfunction()