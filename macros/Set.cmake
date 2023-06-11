# Copyright 2023 Andres Gongora <https://github.com/andresgongora/cmake>
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

include_guard()

# ###################################################################################################
# #
# #  set_if(<variable> <condition>)
# #  If condition is TRUE, sets the variable to the string value of its own name, or to an empty
# #  string otherwise.
# #
# ###################################################################################################
macro(set_if VARIABLE_NAME CONDITION)
    if(${CONDITION})
        set(${VARIABLE_NAME} "${VARIABLE_NAME}")
    else()
        set(${VARIABLE_NAME})
    endif()
endmacro()

# ###################################################################################################
# #
# #  set_if_unset(<variable> <value>)
# #  Only sets the variable if it is not defined in the current scope.
# #
# ###################################################################################################
macro(set_if_unset VARIABLE_NAME)
    if(NOT DEFINED "${VARIABLE_NAME}")
        set("${VARIABLE_NAME}" ${ARGN})
    else()
        message(DEBUG "${VARIABLE_NAME} already set to '${${VARIABLE_NAME}}'")
    endif()
endmacro()

# ###################################################################################################
# #
# #  set
# #
# ###################################################################################################
