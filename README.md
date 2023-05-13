<!------------------------------------------------+------------------------------------------------>
#                                               CMake
<!------------------------------------------------+------------------------------------------------>

This is a small repository of CMake utils that are meant to be reusable for different projects
as well as a gentle introduction to CMake itself.



<!------------------------------------------------+------------------------------------------------>
#                                                Utils
<!------------------------------------------------+------------------------------------------------>

Refer to each individual `.cmake` file for details and usage instructions.



## Summary

- **version.cmake**
  Generate an automatic project version header using tag information from Git, e.g., `v1.2`.



<!------------------------------------------------+------------------------------------------------>
#                                            CMake primer
<!------------------------------------------------+------------------------------------------------>

CMake is a build system generator that helps software developers manage the build process of their
projects. It relies on a simple scripting language that is platform-independent yet able to describe
all nuances related to building a project. CMake then takes this script and converts it to yet
another intermediate build file, such as Makefiles on Linux systems or VS projects on Windows that
can then be built on the target system. However, the advantage of CMake over the later goes well
beyond making a project plantofrm independent, since CMake includes a plethora of tools and
modules that simplify the complete development process.

All that is needed for CMake to work is a `CMakeLists.txt` files inside your project. This file
describes, dependencies that must be met, how the compilation process should run, and other commands
that should run before or after the compilation itself (e.g., linters, profilers, etc.).
`CMakeLists.txt` can be relatively simlpe with only a few lines, or quite complex and spread-out
over multiple files that include each other. Nonetheless, the CMake scripting language they use is
relatively simple as described next.



## Introduction to the CMake scripting language

### Text format

CMakeLists are very torelant to the way you write them. You may use lower or upper case
interchangeably, but be consistent. `CONTINUE...`

### Commands

A CMake command is a directive with the syntax `command_name(ARGUMENTS)`.
Commands can be divided into the following categories
  - Scripting commands: these are always available.
  - Project commands: available within a CMake project.
  - CTest commands: available in CTest scripts.

```
command( arguments go here )
another_command( ) # this command has no arguments
yet_another_command( these
arguments are spread # comment
over several lines )
```

### Variables
CMake variables can either be define by CMAke or can be defined in the CMake script.
  - `set(parameter value)` creates and/or sets the variable 'parameter' to the  given value.
  - `message(value)` prints the value to console.
  - `${varname}` substitutes a variable with its value

```
set( X 3 )              # x = "3"
set( Y 1 )              # y = "1"
message( XY )           # displays "xy"
message( ${X}${Y} )     # displays "31"
```

A special case for variables are **boolean variables**.
All variables are text strings, yet these can be evaluated as boolean expressions
(eg when using `if()` or `while()` commands), where the values `"FALSE"`, `"OFF"`, `"NO"` and anything ending in `"-NOTFOUND"` evaluates to false, and everything else to true.

Finally, there are **special variables** that are either created behind the scenes or have meaning
to CMake when set by project code. Many of these variables start with `CMAKE_` and are meant




##=================================================================================================
#    CHAOS ONWARDS
##=================================================================================================


## Essential elements of a CMakeLists file

> Meter aquí lo básico, que deberían ser solo 4 líneas. Empezar con una pequeña intro y una lsita numebrada de los 4 elementos que hacn falta, luego crear una subsubseccion para cada uno de estos elementso reutilizando el código de abajo






# -------------------------------------------------------------------------


Esto abajo en seccion dedicada

Furthermore, some variables can be exposed as **compile options** that the user can tweak. These
variables can be controlled externally and they are persistent through all compilation runs.
To expose a variable externally, define it with
`set(<VARIABLE_NAME> <default_value> CACHE <type> <docstring>)`,
where `type` can be any of the following:
  - `FILEPATH`: file chooser dialog.
  - `PATH`: directory chooser dialog.
  - `STRING`: arbitrary string.
  - `BOOL`: on/off.
  - `INTERNAL` = No GUI entry, persistent across runs.

During configuration (for example with a GUI) the user gets prompted with the exposed options and
their choise will be saved for subsequent runs in a 'CMakeCache.txt' file.
```
set( ENABLE_HELLO true CACHE BOOL "If true write hello" )
set( OTHER_MSG "Hi" CACHE STRING "Not hello value" )
if (${ENABLE_HELLO})
    message("Hello")
else (${ENABLE_HELLO})
    message(${OTHER_MSG})
endif (${ENABLE_HELLO})
```



## CMake Version -----------------------------------------------------------------------------------
#
#  Sets the minimum required version of cmake for a project.
#  This is used to avoid any cryptic error messages due to the CMakeLists.txt assuming a later
#  version of CMake than the one installed on the current host.
#  Set to the oldest version you have _tested_ that has all the features your script needs,
#  and if you set it to a specific version because you require a feature it introduces,
#  document it (just like this very comment) to help with later maintenance.
#
cmake_minimum_required(VERSION 3.10)


## PROJECT -----------------------------------------------------------------------------------------
#
#  Sets the name of the project, and stores it in the variable 'PROJECT_NAME'.
#  When called from the top-level CMakeLists.txt also stores the project name in the variable
#  'CMAKE_PROJECT_NAME'.
#
#  Also sets the variables:
#  - 'PROJECT_SOURCE_DIR', '<PROJECT-NAME>_SOURCE_DIR'
#     Abosolutepath to the source directory for the project.
#  - 'PROJECT_BINARY_DIR', '<PROJECT-NAME>_BINARY_DIR'
#    Absolute path to the binary directory for the project.
#
# @code
project(MyProjectName)
# @endcode
#
# It is also possible to specify a language, C / CXX (CPP) / Fortran, etc.
# See https://cmake.org/cmake/help/v3.0/command/project.html
#
project(MyProjectName CXX)
#



## C++ VERSION -------------------------------------------------------------------------------------
#
#  The C++ version can be set with these commands:
# @code
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)
set(CMAKE_CXX_EXTENSIONS false) # Optional: whether compiler specific flags should be added, such as -std=gnu++11 instead of -std=c++11. Default to ON
# @endcode
#
#
#  Extra compiler flags can be set with the following. Usually, you only need 'CMAKE_CXX_FLAGS',
#  but other options may be specified for debug and release cases as well
# @code
set(CMAKE_CXX_FLAGS "-Wall -Werror -O3") # common
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} -g") # debug
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} -O3 -pedantic") #release
# @endcode
#
#  You can then invoke cmake for debug and release with the following command:
$ cmake -DCMAKE_BUILD_TYPE=Release ../
$ cmake -DCMAKE_BUILD_TYPE=Debug ../
#


## EXECUTABLE --------------------------------------------------------------------------------------
#
# Optional:
# Instead of using PROJECT_NAME directly, we can create a new variable, BIN_NAME, to set the name
# of the output binary. This gives us a bit more flexibility. For instance, we can add ".exe" to
# the name. In the following example we just copy the project name.
set(BIN_NAME ${PROJECT_NAME})
#
# Add an executable to the project using the specified source files.
add_executable(${BIN_NAME} main.cpp)
#
# As for headers, you might want to include those as well to the executable. This helps with IDEs.
# To make it easier, we can let CMake search for all files automatically using "file":
# - GLOB will generate a list of all files that match the globbing expressions and store it into
#   the variable. Globbing expressions are similar to regular expressions, but much simpler.
# - GLOB_RECURSE: sabe as GLOB but recursive.
#   Subdirectories that are symlinks are only traversed if FOLLOW_SYMLINKS is given.
#
# IMPORTANT:
# We do not recommend using GLOB to collect a list of source files from your source tree. If no
# CMakeLists.txt file changes when a source is added or removed then the generated build system
# cannot know when to ask CMake to regenerate.
#
file(GLOB_RECURSE SRCS  "*.cpp")
file(GLOB_RECURSE HDRS  "*.h" ".hpp")
add_executable(${BIN_NAME} ${SRCS} ${HDRS})

## OUTPUT DIR --------------------------------------------------------------------------------------
#
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)
#



##=================================================================================================

## TARGETS --------------------------------------------------------------------------------------






##==================================================================================================

install(TARGETS ${BIN_NAME} DESTINATION bin)
