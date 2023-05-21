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
#                                               ABOUT
<!------------------------------------------------+------------------------------------------------>

- [MIT License](LICENSE).
- [Info about the authors](AUTHORS.md).
