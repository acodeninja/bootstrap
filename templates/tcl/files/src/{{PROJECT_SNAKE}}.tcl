# Procedures for {{PROJECT_NAME}}. A test file reaches these by sourcing the
# file -- Tcl's package machinery wants a generated pkgIndex.tcl, and a
# namespace plus source is the whole module system without one.
#
# A hash is a comment only where a command could begin. After code on the same
# line it is an argument unless preceded by a semicolon, and inside a braced
# argument list -- a `switch` body, an `expr` -- it is not a comment at all.
# That catches everybody once.

# `namespace eval` runs its body in a namespace, creating it if it does not
# exist. Note what this is: not a declaration, but a command taking a script as
# an argument -- which is true of everything in Tcl, including `if` and `proc`.
namespace eval {{PROJECT_SNAKE}} {
    # The export list, which affects `namespace import` and nothing else: a
    # procedure is always reachable by its fully qualified name, so this is a
    # convenience rather than a wall.
    namespace export greet
}

# `proc` takes three arguments -- a name, a list of parameter names, and a body
# -- and all three are just strings. The qualified name puts the procedure in
# the namespace above.
proc {{PROJECT_SNAKE}}::greet {name} {
    # `return` is needed here. A Tcl procedure answers the value of its last
    # command, and `return` is how you say which, but unlike Ruby or Lisp the
    # result of a bare expression is easy to lose -- being explicit is the
    # convention.
    #
    # Double quotes interpolate, braces do not. $name interpolates a variable
    # and [command] interpolates the result of running something.
    return "Hello, $name!"
}
