<!------------------------------------------------+------------------------------------------------>
#                                               CMake
<!------------------------------------------------+------------------------------------------------>

This is a small repository of CMake utils that are meant to be reusable for different projects
as well as a gentle introduction to CMake itself.

- **Introduction to CMake**: if you find CMake a bit confusing, then you probably want to
  [read this changelogs](doc/CMakePrimer.md).

- **CMake helper scripts**: see below for a small collection of helper scipts and CMake utilities.



<!------------------------------------------------+------------------------------------------------>
#                                               Utils
<!------------------------------------------------+------------------------------------------------>

**TL;DR**: Add `include(cmake/utils/<SCRIPT>.cmake)` to your projects `CMakeLists.txt`.

The following utils are meant to be as simple as possible for the end user. Usually, all you need
to do is include the script in your `CMakeLists.txt`, typically somewhere below your `project()`
declaration. For details, refer to each individual `.cmake` file for details and usage instructions.

- **ClangTidy**
  Configure clang-tidy for your project. Project rules can be tweaked with `cmake-gui`.

- **CompileOptions**
  TO DO.

- **GoogleTest**
  Add GoogleTest (it creates the library `GTest::GTest`) to your project to run unit-tests.

- **Version.cmake**
  Generate an automatic project version header using tag information from Git, e.g., `v1.2`.



<!------------------------------------------------+------------------------------------------------>
#                                              Functions
<!------------------------------------------------+------------------------------------------------>

**TL;DR**: Add `include(cmake/functions/<FUNCTION>.cmake)` to your projects `CMakeLists.txt`.

The following functions are really meant to be used by the above utils, but you may include them
in your own scripts if you require the functionalities they provide.

- **AddTargetCommandPair**
  Adds a chained custom target and custom command to run any command once during the compilation
  phase, yet avoids running it unnecessarily during subsequent compilations. It uses a syntax that
  is very similar to both `add_custom_target` and `add_custom_command`.

- **GetArgumentsFromList**
  Useful when writing functions with optional arguments. This function will search for named
  arguments and return their values. Among other options, arguments can be set to `REQUIRED` or
  `OPTIONAL`. **Note**: For most cases,
  [cmake_parse_arguments](https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html)
  is a better solution.

- **RunPythonCommand**
  Run python with a given argument (e.g., a python command, or invoke it with a script),
  with the ability to specify a requirements file that should be installed with pip, and using
  syntax analogous to CMake's _custom_targets_ and _custom_commands_.



<!------------------------------------------------+------------------------------------------------>
#                                              Macros
<!------------------------------------------------+------------------------------------------------>

**TL;DR**: Add `include(cmake/macros/<MACRO>.cmake)` to your projects `CMakeLists.txt`.

Macros are similar to function, but instead of acting in the conventional sense of a
_function call_, they operate on the principle of direct _text substitution_ or _transclusion_
how compiler macros work. This means that they run directly in the caller scope.

- **Set**
  Provides small macros related to the `set()` operation.

    - `set_if(<variable> <condition>)`
       If condition is TRUE, sets the variable to the string value of its own name, or to an empty
       string otherwise.

    - `set_if_unset(<variable> <value>)`
       Only sets the variable if it is not defined in the current scope.



<!------------------------------------------------+------------------------------------------------>
#                                               ABOUT
<!------------------------------------------------+------------------------------------------------>

- [MIT License](LICENSE).
- [Info about the authors](AUTHORS.md).
