# Functions for {{PROJECT_NAME}}. A test file reaches these with
# `•Import "../src/{{PROJECT_SNAKE}}.bqn"`, and ⇐ is what makes a name visible
# to the importer -- a file is a namespace, and ← alone keeps a name private.
#
# A hash to end of line is the only comment form. The file is UTF-8 and most of
# the language is non-ASCII, so an editor that mangles encodings will mangle the
# program.

# The capital letter is not a style choice: in BQN a name beginning with a
# capital *is* a function, one beginning with a lower-case letter is a value, and
# the case is how the parser tells them apart. Rename this to `greet` and the
# line stops parsing.
#
# The braces make a block function. 𝕩 is its right argument and 𝕨 would be the
# left one, so the parameters are named by position rather than declared -- a
# function of one argument uses 𝕩 and a function of two uses both.
#
# ∾ joins. There is no interpolation, and no string type either: text is a list
# of characters, so ∾ is the same join that works on any two lists.
Greet ⇐ {"Hello, " ∾ 𝕩 ∾ "!"}
