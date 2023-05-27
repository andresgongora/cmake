####################################################################################################
##
##  GetArgumentsFromList
##
##  A function to search for arguments in a list and get the provided valie, useful for functions
##  with optional arguments.
##
##  `get_argument_from_list(<KEYWORD> <OUTPUT_VARIABLE> <TYPE> <LIST_TO_SEARCH>)`
##
##
##  USAGE:
##      Include this script where you want the function to become available.
##      Then, given a list of arguments that have a preceding keyword, call the function on said
##      list like so:
##          ```
##          get_argument_from_list(ALL      ADD_TARGET_TO_ALL   CHECK_IF_PRESENT    ${ARGV})
##          get_argument_from_list(COMMAND  ARG_COMMAND         REQUIRED            ${ARGV})
##          get_argument_from_list(DEPENDS  ARG_DEPENDS         OPTIONAL            ${ARGV})
##          ```
##
##  OPTIONS:
##      - KEYWORD:
##          The keyword you want to search for in the list. If found, the function will return
##          the value that is stored inmediately next to said keyword.
##      - OUTPUT_VARIABLE:
##          Name of the output variable where the argument should be stored to. If not found,
##          this variable will be set to empty.
##      - TYPE:
##          - REQUIRED: CMake will fail with an error message if the argument was not found.
##          - OPTIONAL: If not found, the varuable will simply be set to empty
##          - CHECK_IF_PRESENT: Returns the keyword if it was found, and empty if not
##      - LIST_TO_SEARCH:
##          A CMake list to parse. Typically, this will be ARGV in most scripts since
##          get_argument_from_list was originally meant to deal with optional fuction arguments.
##
##
##  HOW IT WORKS:
##      The script should be self explainatory. The only special case is the call to
##      list(SUBLIST ARGV 3 -1 INPUT_LIST), which requires CMAKE 3.12 or above, and extracts
##      the INPUT_LIST from the input (because the list _will_ spill over the variable INPUT_LIST).
##
####################################################################################################

cmake_minimum_required(VERSION 3.12)

function(get_argument_from_list KEYWORD OUTPUT_VARIABLE ARGUMENT_TYPE INPUT_LIST)

    ## Prepare list of possible arguments
    list(SUBLIST ARGV 3 -1 INPUT_LIST)
    if(NOT INPUT_LIST)
        message(FATAL_ERROR "List may not be empty")
    endif()

    ## Check for type
    if(NOT ((${ARGUMENT_TYPE} STREQUAL "REQUIRED") OR (${ARGUMENT_TYPE} STREQUAL "OPTIONAL") OR (${ARGUMENT_TYPE} STREQUAL "CHECK_IF_PRESENT")))
        message(FATAL_ERROR "Argument type must be either 'REQUIRED', 'OPTIONAL' or 'CHECK_IF_PRESENT'. '${ARGUMENT_TYPE}' is not a valid option.")
    endif()

    ## Trace
    message(TRACE "Output variable: ${OUTPUT_VARIABLE}")
    message(TRACE "Searching for:\t ${KEYWORD}")
    message(TRACE "Argument type:\t ${ARGUMENT_TYPE}")
    message(TRACE "Input list:\t ${INPUT_LIST}")

    ## Get arguments
    list (FIND INPUT_LIST ${KEYWORD} _INDEX)
    if (${_INDEX} GREATER -1)
        ## Simply check if argument was given or not
        if(${ARGUMENT_TYPE} STREQUAL "CHECK_IF_PRESENT")
            list(GET       INPUT_LIST ${_INDEX} ARGUMENT)

        ## Actually get the argument
        else()
            list(REMOVE_AT INPUT_LIST ${_INDEX})
            list(GET       INPUT_LIST ${_INDEX} ARGUMENT)

        endif()
    endif()

    ## Write output to parent scope (i.e., return value)
    set(${OUTPUT_VARIABLE} ${ARGUMENT} PARENT_SCOPE)

endfunction()
