####################################################################################################
##
##  AddTargetCommandPair
##
##  Create a named custom target and pair it with a custom target that will only run when strictly
##  needed during compilation.
##
##  ```
##  add_target_command_pair(
##      <TARGET_NAME>
##      (ALL)
##      COMMAND  <COMMAND_TO_RUN>
##      (DEPENDS <DEPENDENCY_FOR_COMMAND>)
##      (COMMENT <COMMAND_COMMENT>)
##  )
##  ```
##
##  USAGE:
##          ```
##          include(cmake/functions/AddTargetCommandPair.cmake)
##
##          add_target_command_pair(
##              "MyCustomTargetName"
##              ALL
##              "COMMAND" "echo Hello world && echo Print me on the second line"
##          )
##          ```
##
##  DETAILS:
##      By defaults, custom_targets are always considered out of date and must be run, whereas
##      custom_commands only run if their OUTPUT is missing or they have a DEPENDENCY. Now, many
##      custom_commands might not produce a simple OUTPUT that can be checked to determine if it
##      was previosuly executed or not, yet we might not want to run it with every compilation.
##      For example, assume you have a Python script you need to run the very first time you want
##      to compile that somehow prepares your compilation environment. This script produces no
##      output, so you don't want to insert it in CMake with `add_custom_command`, but it also
##      does not need to run every time you recompile, so adding it with `add_custom_target` might
##      lead to an annoying behaviour. That is, we have a command we want to run once and only once.
##
##      A very simple solution is to run said command during the CMake configuration phase.
##      However, imagine you do not want that; you want it to run once and only once, but during
##      the compilation phase. Common practice in this cases is to add a target and link it
##      to a command, such that the command only runs when a _witness_ or _run testimony_ file is
##      not present, and create it after the first exectuin. This function takes care of exactly
##      that.
##
##
##  HOW IT WORKS:
##      1. Get arguments with helper function.
##      2. Set path to witness file.
##      3. Convert user COMMAND from STRING to LIST (required by CMake, see code comments).
##      4. Add custom command that creates the witness file _only_ if it runs sucessfuly, make it
##         run the COMMAND requested by the user.
##          4.1 Optionally, add a dependecy for the command. Otherwise it will only run once
##              during compilation.
##      5. Add custom target that depends on the above command.
##
##
##  FUNCTION ARGUMENTS:
##      - TARGET_NAME:              Name for the custom target.
##      - ALL:                      Optionally, specify if the custom target should be added to ALL.
##      - COMMAND <COMMAND_TO_RUN>: Provide a command to run.
##      - DEPENDENTS <DEPENDENCY>:  Specify a single dependency
##      - COMMENT <COMMAND_COMMENT>:Message to be displayed during command execution
##
##
##  TO DO:
##      - Allow for more than once dependency
##
####################################################################################################

cmake_minimum_required(VERSION 3.11)

include("${CMAKE_CURRENT_LIST_DIR}/GetArgumentFromList.cmake")

function(add_target_command_pair TARGET_NAME)
    message(STATUS "Adding ${TARGET_NAME} target-command pair")

    ##----------------------------------------------------------------------------------------------
    ## Prepare
    ##

    ## Get arguments
    get_argument_from_list(ALL      ADD_TARGET_TO_ALL   CHECK_IF_PRESENT    ${ARGV})
    get_argument_from_list(COMMAND  ARG_COMMAND         REQUIRED            ${ARGV})
    get_argument_from_list(DEPENDS  ARG_DEPENDS         OPTIONAL            ${ARGV})
    get_argument_from_list(COMMENT  ARG_CMD_COMMENT     OPTIONAL            ${ARGV})

    ## Aux variables
    set(WITNESS_FILE "${CMAKE_BINARY_DIR}/CMakeFiles/${TARGET_NAME}.done")

    if(NOT ARG_DEPENDS)
         set(ARG_DEPENDS ${WITNESS_FILE})
    endif()

    if(NOT ARG_CMD_COMMENT)
        set(ARG_CMD_COMMENT "${TARGET_NAME}: running CMake command")
    endif()

    ## Prepare command argument
    ## The user has to provide a STRING to this function, example "echo hello world"
    ## However, COMMAND in add_custom_command expects a LIST instead of a single string
    separate_arguments(ARG_COMMAND)

    ## Trace
    message(TRACE "ADD_TARGET_TO_ALL:\t${ADD_TARGET_TO_ALL}")
    message(TRACE "COMMAND:\t\t${ARG_COMMAND}")
    message(TRACE "WITNESS:\t\t${WITNESS_FILE}")
    message(TRACE "DEPENDS:\t\t${ARG_DEPENDS}")

    ##----------------------------------------------------------------------------------------------
    ## Add command + target pair
    ##

    add_custom_command(
        OUTPUT  ${WITNESS_FILE}                             ## By creating a witness file, the TARGET can DEPEND on the COMMAND
        COMMENT ${ARG_CMD_COMMENT}
        COMMAND ${CMAKE_COMMAND} -E remove ${WITNESS_FILE}  ## Remove witness (it may not exist for the first run)
        COMMAND ${ARG_COMMAND}                              ## Run actual command
        COMMAND ${CMAKE_COMMAND} -E touch  ${WITNESS_FILE}  ## If command successful, restore witness
        DEPENDS ${ARG_DEPENDS}
    )

    add_custom_target(
        "${TARGET_NAME}"
        ${ADD_TARGET_TO_ALL}
        DEPENDS ${WITNESS_FILE}
        COMMENT "${TARGET_NAME}"
    )

endfunction()
