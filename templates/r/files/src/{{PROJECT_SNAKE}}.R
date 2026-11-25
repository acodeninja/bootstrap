# A hash to end of line is the only comment form R has. There is no block
# comment, and a hash followed by an apostrophe is roxygen documentation by
# convention rather than by the language.  Keep a comment under eighty
# characters and keep it prose: lintr runs with its defaults here, and one of
# those defaults fails the build on any comment whose text would parse as R
# code. A worked example in a comment is a lint error.

# A function is a value, assigned to a name like anything else. The arrow is
# the assignment operator and the idiomatic one; equals also assigns and is
# reserved by convention for named arguments.  Nothing is exported and there is
# no module: the test runner reads every file under src and this name is then
# simply available. A package would use a NAMESPACE file, and this project is
# not one.
greet <- function(name) {
  # paste0 joins its arguments with no separator; paste joins them with a space
  # unless told otherwise, which is the wrong default about half the time.
  # sprintf is the other option and is worth it once there is formatting to do.
  # There is no return statement here. The value of the last expression is the
  # value of the function, and an explicit return is legal and usually reserved
  # for leaving early.
  paste0("Hello, ", name, "!")
}
