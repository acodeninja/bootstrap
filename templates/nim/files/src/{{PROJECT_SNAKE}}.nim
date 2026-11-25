## A module is a file and its name is the filename, so this one is the project.
## Two hashes make a documentation comment, which is part of the syntax tree
## rather than a comment the parser throws away -- which means it is only legal
## in certain positions, such as here at the top of a module or immediately
## after a declaration. One hash is an ordinary comment and goes anywhere.

# `proc` declares a procedure, and the asterisk after the name is the export
# marker: `greet*` is visible to a module that imports this one, `greet` is not.
# That one character is the whole of Nim's visibility.
#
# The parameter type comes after a colon and the return type after the
# parentheses, also after a colon.
proc greet*(name: string): string =
  # No `return`. The last expression in a procedure is its value -- and so is
  # the implicit `result` variable, which starts at the type default and is
  # returned however the procedure falls out. That is worth knowing early: a
  # procedure where no branch sets anything hands back an empty string rather
  # than failing in any visible way.
  #
  # & concatenates strings. It is not + : that is addition, and asking for it
  # here would not compile.
  "Hello, " & name & "!"
