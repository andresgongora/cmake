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

**TL;DR**: Just `include(cmake/utils/<SCRIPT>.cmake)` from your projects `CMakeLists.txt`.

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

**TL;DR**: Just `include(cmake/functions/<SCRIPT>.cmake)` from your projects `CMakeLists.txt`.

The following functions are really meant to be used by the above utils, but you may include them
in your own scripts if you require the functionalities they provide.

- **GetArgumentsFromList**
  Useful when writing functions with optional arguments. This function will search for named
  arguments and return their values. Among other options, arguments can be set to `REQUIRED` or
  `OPTIONAL`.

- **AddTargetCommandPair**
  Adds a chained custom target and custom command to run any command once during the compilation
  phase, yet avoids running it unnecessarily during subsequent compilations. It uses a syntax that
  is very similar to both `add_custom_target` and `add_custom_command`.



<!------------------------------------------------+------------------------------------------------>
#                                               ABOUT
<!------------------------------------------------+------------------------------------------------>

- [MIT License](LICENSE).
- [Info about the authors](AUTHORS.md).
