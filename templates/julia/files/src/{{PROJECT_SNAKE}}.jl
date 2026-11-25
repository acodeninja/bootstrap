# A module, and the name has to match what the test says `using` on -- this one
# carries the project name. Comments are a hash to end of line; #= =# is the
# block form and it nests, and a """triple-quoted string""" placed immediately
# above a definition is a docstring rather than a comment, which means it ships
# in the module and reaches the help system.
module {{PROJECT_SNAKE}}

# The whole of visibility, and it is softer than it looks: `export` decides what
# `using` brings into scope unqualified, but an unexported name is still
# reachable as ModuleName.name. Nothing is actually private.
export greet

# The short form of a function definition: name, arguments, equals, body. The
# long form opens with `function` and closes with `end`, and is what you use once
# the body is more than an expression.
#
# No type annotations, and that is idiomatic rather than lazy -- a Julia function
# is generic until you constrain it, and constraining it is how you choose which
# method gets called rather than how you document anything. Annotating `name`
# here would stop the function working for a symbol or a number.
#
# $(name) interpolates inside a string, and $name works too; the parentheses are
# needed as soon as the expression is anything more than a bare variable, so
# writing them always is the safer habit.
greet(name) = "Hello, $(name)!"

end
