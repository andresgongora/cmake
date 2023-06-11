# Copyright 2023 Andres Gongora <https://github.com/andresgongora/cmake>
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

include_guard()

####################################################################################################
##
##  Helper function! You can skip this function descrption
##
##  __deprecate_command <COMMAND> [COMMENT <message>] [PROHIBIT]
##
####################################################################################################
macro(__deprecate_command COMMAND)
    if(COMMAND "_${COMMAND}")
        message(WARNING "'${COMMAND}' is already overloaded and could NOT be flagged as deprecated!")

    else()
        ##------------------------------------------------------------------------------------------
        ## Get arguments
        ##
        cmake_parse_arguments(
            _DEPRECATE_ARGS
            "PROHIBIT"              # Options
            "COMMENT"               # Single value
            ""                      # Multi value
            "${ARGN}")

        ##------------------------------------------------------------------------------------------
        ## Create override macro
        ##
        if(${_DEPRECATE_ARGS_PROHIBIT})
            ## If prohibited: fatal error
            set(_DEPRECATE_COMMAND "message(FATAL_ERROR \"'${COMMAND}' is prohibited! ${_DEPRECATE_ARGS_COMMENT} (Flagged in ${CMAKE_CURRENT_LIST_FILE})\")")
        else()
            ## If not prohibited: deprecation warning + run original command
            set(_DEPRECATE_COMMAND "message(DEPRECATION \"'${COMMAND}' is deprecated! ${_DEPRECATE_ARGS_COMMENT} (Flagged in ${CMAKE_CURRENT_LIST_FILE})\")\n_${COMMAND}(\$\{ARGV\})")
        endif()

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/.cmake/deprecated_${command}_wrapper.cmake"
            "include_guard()\n"
            "if(NOT COMMAND \"_${COMMAND}\")\n"
            "    macro(${COMMAND})\n"
            "        ${_DEPRECATE_COMMAND}\n"
            "    endmacro()\n"
            "endif()")
        include("${CMAKE_CURRENT_BINARY_DIR}/.cmake/deprecated_${command}_wrapper.cmake")

        ##------------------------------------------------------------------------------------------
        ## Clear variables
        ##
        unset(_DEPRECATE_ARGS_PROHIBIT)
        unset(_DEPRECATE_ARGS_COMMENT)
        unset(_DEPRECATE_COMMAND)

    endif()
endmacro()

####################################################################################################
##
##  Helper function! You can skip this function descrption
##
##  __deprecate_variable <VARIABLE> [COMMENT <message>] [PROHIBIT]
##
####################################################################################################
macro(__deprecate_variable VARIABLE)

    if(${${VARIABLE}})

        ##------------------------------------------------------------------------------------------
        ## Get arguments
        ##
        cmake_parse_arguments(
            _DEPRECATE_ARGS
            "PROHIBIT"              # Options
            "COMMENT"               # Single value
            ""                      # Multi value
            "${ARGN}")

        ##------------------------------------------------------------------------------------------
        ## Add watch
        ##

        ## Watch command (create only if undefined in the current scope)
        if(NOT COMMAND "__deprecated_variable_${VARIABLE}_watch")

            if(${_DEPRECATE_ARGS_PROHIBIT})
                ## Prohibit
                function("__deprecated_variable_${VARIABLE}_watch" VARIABLE_TO_WATCH ACCESS)
                    if(ACCESS STREQUAL "READ_ACCESS")
                        message(FATAL_ERROR "The variable '${VARIABLE_TO_WATCH}' is deprecated! ${_DEPRECATE_ARGS_COMMENT} (Flagged in ${CMAKE_CURRENT_LIST_FILE})")
                    endif()
                endfunction()

            else()
                ## Warn about deprecation
                function("__deprecated_variable_${VARIABLE}_watch" VARIABLE_TO_WATCH ACCESS)
                    if(ACCESS STREQUAL "READ_ACCESS")
                        message(DEPRECATION "The variable '${VARIABLE_TO_WATCH}' is deprecated! ${_DEPRECATE_ARGS_COMMENT} (Flagged in ${CMAKE_CURRENT_LIST_FILE})")
                    endif()
                endfunction()
            endif()

        endif()

        ## Call above watch command on variable
        variable_watch(${VARIABLE} "__deprecated_variable_${VARIABLE}_watch")

        ##------------------------------------------------------------------------------------------
        ## Clear variables
        ##
        unset(_DEPRECATE_ARGS_PROHIBIT)
        unset(_DEPRECATE_ARGS_COMMENT)
        unset(_DEPRECATE_MESSAGE_TYPE)

    else()
        message(FATAL_ERROR "Can not add undefined variable '${VARIABLE}' to deprecation watchlist!")
    endif()
endmacro()

####################################################################################################
##
##  deprecate <VARIABLE_or_COMMAND> [COMMENT <message>] [PROHIBIT]
##
####################################################################################################
macro(deprecate WHAT)
    if(COMMAND ${WHAT})
        message(DEBUG "Flagging command '${WHAT}' as deprecated in ${CMAKE_CURRENT_LIST_FILE}")
        __deprecate_command(${WHAT} ${ARGN})

    elseif(DEFINED ${WHAT})
        message(DEBUG "Flagging variable '${WHAT}' as deprecated in ${CMAKE_CURRENT_LIST_FILE}")
        __deprecate_variable(${WHAT} ${ARGN})

    else()
        message(FATAL_ERROR "Can not deprecate '${WHAT}'")

    endif()
endmacro()