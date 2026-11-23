# Functions for {{PROJECT_NAME}}. A test file reaches these by sourcing the file --
# bash has no module system, and a file of function definitions plus a `.` is
# the whole of one.
#
# The directive is not decoration: a sourced file has no shebang to infer a
# dialect from, so without it shellcheck refuses to check the file at all.
# shellcheck shell=bash

greet() {
  printf 'Hello, %s!\n' "$1"
}
