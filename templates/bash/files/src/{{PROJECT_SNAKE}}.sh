# Functions for {{PROJECT_NAME}}. A test file reaches these by sourcing the file --
# bash has no module system, and a file of function definitions plus a `.` is
# the whole of one.
#
# The directive is not decoration: a sourced file has no shebang to infer a
# dialect from, so without it shellcheck refuses to check the file at all.
# shellcheck shell=bash

# Declaring a function: a name, empty parentheses, and a body in braces. The
# parentheses never hold parameters -- arguments arrive positionally as $1, $2
# and so on, exactly as they do for the script itself, and there is no way to
# name them in the signature.
#
# Nothing is exported and nothing is private. Sourcing this file defines the
# function in the caller, and every variable it touches is the caller's too
# unless declared `local`.
greet() {
  # printf rather than echo, always: echo differs between shells and
  # implementations over backslashes and over -n, where printf is specified.
  #
  # The quotes around "$1" are load-bearing. Unquoted, the value would be split
  # on whitespace and any * in it expanded against the filesystem -- so `greet
  # 'a b'` would pass two arguments and `greet '*'` would pass your filenames.
  # Quote every expansion; it is almost never wrong.
  #
  # Note this prints rather than returns. A bash function has no return value
  # but its exit status, which is a number -- so output is the channel for an
  # answer, and the test below captures it rather than comparing a result.
  printf 'Hello, %s!\n' "$1"
}
