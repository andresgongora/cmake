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


<!------------------------------------------------+------------------------------------------------>
#                            Introduction to the CMake scripting language
<!------------------------------------------------+------------------------------------------------>

## Text format
CMakeLists are very torelant to the way you write them. You may use lower or upper case
interchangeably, but be consistent. `CONTINUE...`

## Commands
A CMake command is a directive with the syntax `command_name(ARGUMENTS)`.
Commands can be divided into the following categories
  - Scripting commands: these are always available.
  - Project commands: available within a CMake project.
  - CTest commands: available in CTest scripts.

        command( arguments go here )
        another_command( ) # this command has no arguments
        yet_another_command( these
        arguments are spread # comment
        over several lines )


## Variables
CMake variables can either be define by CMAke or can be defined in the CMake script.
  - `set(parameter value)` creates and/or sets the variable 'parameter' to the  given value.
  - `message(value)` prints the value to console.
  - `${varname}` substitutes a variable with its value

        set(X 1)              # X = "1"
        set(Y 5)              # Y = "5"
        message(XY)           # displays "XY"
        message(${X}${Y})     # displays "15"

A special case for variables are **boolean variables**.
All variables are text strings, yet these can be evaluated as boolean expressions
(eg when using `if()` or `while()` commands), where the values `"FALSE"`, `"OFF"`, `"NO"` and
anything ending in `"-NOTFOUND"` evaluates to false, and everything else to true.

Finally, there are **special variables** that are either created behind the scenes or have meaning
to CMake when set by project code. Many of these variables start with `CMAKE_` and are meant



<!------------------------------------------------+------------------------------------------------>
#                                        A minimal CMakeLists.txt
<!------------------------------------------------+------------------------------------------------>

A minimal CMakeLists.txt for your project looks like this:

        cmake_minimum_required(VERSION 3.11)
        project(MyProject)
        add_executable(myexecutable main.cpp)

Assuming there is a `main.cpp` you can easily build your project now with `cmake . && make`.

## cmake_minimum_required()
This command specifies that the  CMake file must be processed by CMake 3.11 or later.
This is meant to let whoever wrote CMake specify they features they need for CMake to work properly.
This is used to avoid any cryptic error messages due to the CMakeLists.txt assuming a later
version of CMake than the one installed on the current host.
Set to the oldest version you have _tested_ that has all the features your script needs,
and if you set it to a specific version because you require a feature it introduces,
document it (just like this very comment) to help with later maintenance.

## project()
This creates and sets the name of the project. You must pass at least the name of the project, which
will be stored in the variable `PROJECT_NAME`.
When called from the top-level CMakeLists.txt also stores the project name in the
variable `CMAKE_PROJECT_NAME`. Other variables that are set:
- `PROJECT_SOURCE_DIR`, `<PROJECT-NAME>_SOURCE_DIR`
   Abosolutepath to the source directory for the project.
- `PROJECT_BINARY_DIR`, `<PROJECT-NAME>_BINARY_DIR`
   Absolute path to the binary directory for the project.

It is also possible to specify a language, C / CXX (CPP) / Fortran, etc.
By default, CMake assumes a mixed project of CXX (C++) with C.
See https://cmake.org/cmake/help/v3.0/command/project.html for more information

A more advande project clause might look like this:

        project(MyProject
            VERSION         1.0
            DESCRIPTION     "A dope description"
            LANGUAGES       CXX
        )

## add_executable()
This is a _target_ that must be compiled. Typically you want `add_executable` to compile binaries
and `add_library` for libraries.

Add an executable to the project using the specified source files.

        add_executable(${BIN_NAME} main.cpp)

Optionally, you can combine the above. Instead of using PROJECT_NAME directly, we can create a
new variable, BIN_NAME, to set the name of the output binary. This gives us a bit more flexibility.
For instance, we can add ".exe" to the name. In the following example we just copy the project name.

        set(BIN_NAME ${PROJECT_NAME})



<!------------------------------------------------+------------------------------------------------>
#                                       Basic CMake commands
<!------------------------------------------------+------------------------------------------------>

## User-configurable variables and CMakeCache.txt
Aside from creating local variables, `set()` can also be used to expose variables as
**compile options** that the user can tweak. These variables can be controlled externally and they
are persistent through all compilation runs.To expose a variable externally, define it with

        set(<VARIABLE_NAME> <default_value> CACHE <type> <docstring>)`

where `type` can be any of the following:
  - `FILEPATH`: file chooser dialog.
  - `PATH`: directory chooser dialog.
  - `STRING`: arbitrary string.
  - `BOOL`: on/off.
  - `INTERNAL` = No GUI entry, persistent across runs.

During configuration (for example with a GUI) the user gets prompted with the exposed options and
their choise will be saved for subsequent runs in a 'CMakeCache.txt' file.

        set(ENABLE_HELLO true CACHE BOOL "If true write hello")
        set(OTHER_MSG "Hi" CACHE STRING "Not hello value")
        if (${ENABLE_HELLO})
            message("Hello")
        else (${ENABLE_HELLO})
            message(${OTHER_MSG})
        endif (${ENABLE_HELLO})

### Option

When it comes to `CACHE` variables, bool variables are the most common. So common in fact that
there is a _shortcut_ to declare them using `option(<variable> "<help_text>" [value])`
(defaults to `OFF`) like so:

        option(MY_FLAG "This option can be set to ON or OFF" ON)
        option(ENABLE_TURBO_MODE "This option defaults to OFF")

## Finding and adding files to your target

        file(GLOB_RECURSE SRCS  "*.cpp")            # Store *.cpp in ${SRCS}
        file(GLOB_RECURSE HDRS  "*.h" ".hpp")       # Store headers in ${HDRS}
        add_executable(${BIN_NAME} ${SRCS} ${HDRS}) # Use the above variables

As for headers, you might want to include those as well to the executable. This helps with IDEs.
To make it easier, we can let CMake search for all files automatically using "file":
- `GLOB` will generate a list of all files that match the globbing expressions and store it into
  the variable. Globbing expressions are similar to regular expressions, but much simpler.
- `GLOB_RECURSE`: sabe as `GLOB` but recursive.
  Subdirectories that are symlinks are only traversed if FOLLOW_SYMLINKS is given.
We do not recommend using GLOB to collect a list of source files from your source tree. If no
CMakeLists.txt file changes when a source is added or removed then the generated build system
cannot know when to ask CMake to regenerate.

## C++ version & Compiler profiles
The C++ version can be set with these commands:

        set(CMAKE_CXX_STANDARD          11)
        set(CMAKE_CXX_STANDARD_REQUIRED ON)
        set(CMAKE_CXX_EXTENSIONS        OFF)  # Optional

`CMAKE_CXX_EXTENSIONS` is optional and controls whether compiler specific flags should be added,
such as those intended to control compiler extensions (such as inline assembly) or other options.
For more portable code, set this value to `OFF`. Defaults to `ON`.

Extra compiler flags can be set with the following. Usually, you only need `CMAKE_CXX_FLAGS`,
but other options may be specified for debug and release cases as well:

        set(CMAKE_CXX_FLAGS "-Wall -Werror -O3") # common
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} -g") # debug
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} -O3 -pedantic") #release

You can then invoke cmake for debug and release with the following command:

        $ cmake -DCMAKE_BUILD_TYPE=Release ../
        $ cmake -DCMAKE_BUILD_TYPE=Debug ../

## Output directory

        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/bin)
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY     ${PROJECT_BINARY_DIR}/lib)

## Installation rules

Specify rules for a target that will be run in order during instalallation, typically with something
allong the lines of `make install`.

        install(
            TARGETS         ${BIN_NAME}     # Specify the targets, typ one from `add_executable`
            DESTINATION     bin             # Where to copy the output files of the target
        )

It is also possible to make a more advanced use fo the `install` command, for example by specifying
multiple configurations with which to compile the targets.

        install(TARGETS target
                CONFIGURATIONS      Debug
                RUNTIME DESTINATION Debug/bin)
        install(TARGETS target
                CONFIGURATIONS      Release
                RUNTIME DESTINATION Release/bin)

See https://cmake.org/cmake/help/latest/command/install.html for more information



<!------------------------------------------------+------------------------------------------------>
#                                  CMake commands for modular projects
<!------------------------------------------------+------------------------------------------------>

## Recursive CMake

        add_subdirectory(···)

Essentially, this command searches for a `CMakeLists.txt` file in a sepcified subdirectory.
See https://cmake.org/cmake/help/latest/command/add_subdirectory.html

## Exposing library APIs with `include_directories(...)`

        target_include_directories(target_name {PUBLIC|PRIVATE|INTERFACE} directories...)

This command can specify for (a previously declared) target where to look for header files.

- `PUBLIC`: other targets that depend on `target_name` will also see the included directories.
- `PRIVATE`: only `target_name` sees the included directories.
- `INTERFACE`: only other targets that depend on `target_name` see the directories, but not
  `target_name` itself.

        cmake_minimum_required(VERSION 3.11)
        project(MyProject)

        add_executable(myexecutable main.cpp)
        target_include_directories(myexecutable
          PRIVATE
            first_dir/
            second_dir/)

## Creating library instead of executables with `add_library`

        add_library(libraryName
            [STATIC|SHARED|MODULE]
            [EXCLUDE_FROM_ALL]
            source1 source2 ....)

- `STATIC`: produce a static library.
- `SHARED`: produce a shared library.
- `MODULE`: libraries that can be loaded during runtime, _a la_ "plugin".

`EXCLUDE_FROM_ALL`: do not compile library by default when running `cmake --build` unless its a
  depedency for another tharget that does get built.

Unless you have reason to specify it, do not specify a tipe for you libraries and let the end user
can choose.

See https://cmake.org/cmake/help/latest/command/add_library.html

## Linking libraries

        target_link_libraries(target_name
            [PUBLIC|PRIVATE|INTERFACE]
            library1 library2 ....)
