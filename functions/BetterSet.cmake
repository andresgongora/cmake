# Copyright 2023 Andres Gongora <https://github.com/andresgongora/cmake>
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

include_guard()

####################################################################################################
##
##  SET (BETTER_SET)
##
##  TO DO
##
##  ```
##  ```
##
##  USAGE:
##          ```
##          ```
##
##  DETAILS:
##
##
##  HOW IT WORKS:
##
##
##  MACRO ARGUMENTS:
##
## TODO: Use native include guard: include_guard() instead of my if command set.
##
####################################################################################################


if(COMMAND _set)
    message(DEBUG "[better_set] Command 'set' was already overloaded with 'better_set'")

else()
    macro(set2 VARIABLE)
        ##----------------------------------------------------------------------------------------------
        ## Get arguments
        ##
        cmake_parse_arguments(
            _BETTER_SET
            "OPTIONAL PARENT_SCOPE"         # Options
            ""                              # Single value
            "CACHE"                         # Multi value
            "${ARGN}")

        if(${ARGC} GREATER 1)
            _set(_BETTER_SET_VALUE ${_BETTER_SET_UNPARSED_ARGUMENTS})
        else()
            _set(_BETTER_SET_VALUE)
        endif()

        if(_BETTER_SET_PARENT_SCOPE)
            _set(_BETTER_SET_PARENT_SCOPE "PARENT_SCOPE")
        else()
            _set(_BETTER_SET_PARENT_SCOPE "")
        endif()

        if(_BETTER_SET_CACHE)
            _set(_BETTER_SET_CACHE_CACHE "CACHE")
            list(GET ${_BETTER_SET_CACHE} 0 _BETTER_SET_CACHE_TYPE)
            list(GET ${_BETTER_SET_CACHE} 1 _BETTER_SET_CACHE_COMMENT)
        else()
            _set(_BETTER_SET_CACHE_CACHE "")
            _set(_BETTER_SET_CACHE_TYPE "")
            _set(_BETTER_SET_CACHE_COMMENT "")
        endif()



        ##----------------------------------------------------------------------------------------------
        if(_BETTER_SET_OPTIONAL)
            ## Check number of arguments
            ## OPTIONAL variables should only be set in the parent scope, so no extra arguments beyond
            ## the 'OPTIONAL' keyword should be provided.
            if(NOT "${ARGC}" EQUAL "3")
                string(REPLACE ";" " " _BETTER_SET_INVALID_CALL "set(${ARGV})")
                message(FATAL_ERROR "[better_set] Too many arguments. OPTIONAL may not be used with arguments other than name and value: '${_BETTER_SET_INVALID_CALL}'")
            endif()

            ## Only set if not preoviously set (i.e., this set is optional)
            if(NOT DEFINED "${VARIABLE}" AND ${ARGV1} )
                _set("${VARIABLE}" ${VALUE})
            else()
                message(DEBUG "[better_set] ${VARIABLE} already set to '${${VARIABLE}}'")
            endif()

        ##----------------------------------------------------------------------------------------------
        else()
            message("${ARGV}")
            message("\t${VARIABLE}\n\tValue:\t${_BETTER_SET_VALUE}\n\tCache: ${_BETTER_SET_CACHE_CACHE} ${_BETTER_SET_CACHE_TYPE} ${_BETTER_SET_CACHE_COMMENT}\n\tParent: ${_BETTER_SET_PARENT_SCOPE}\n......")
            _set(
                ${VARIABLE}
                ${VALUE}
                ${_BETTER_SET_CACHE_CACHE} ${_BETTER_SET_CACHE_TYPE} ${_BETTER_SET_CACHE_COMMENT}
                ${_BETTER_SET_PARENT_SCOPE}
            )
        endif()

    endmacro()
endif()
