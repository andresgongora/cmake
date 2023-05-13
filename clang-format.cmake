####################################################################################################
##
##  GIT VERSION
##
##  Generate a version string header using tag information from Git in the following format:
##      - `v1.2.3`: on a clean commit tagged `v.1.2.3`.
##      - `v1.2.3-11-g1234abc`: on commit `g1234abc`, 11 commits ahead of the last tag.
##      - `v1.2.3-11-g1234abc-dirty`: same as above but there are uncommited changes.
##
##  Usage: Simply include this script from your project's main CMakeLists.txt.
##
####################################################################################################

##==================================================================================================
## Configuration
##==================================================================================================

find_program(CLANG_FORMAT "clang-format")

file(GLOB_RECURSE SRCS  "*.cpp")
file(GLOB_RECURSE HDRS  "*.h" ".hpp")
add_custom_target("clang-format" "echo command: ${SRCS}")

find . -iname *.h -o -iname *.cpp | xargs clang-format -i

##==================================================================================================
## Determine version from git info
##==================================================================================================
