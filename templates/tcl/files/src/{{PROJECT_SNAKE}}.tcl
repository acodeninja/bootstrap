# Procedures for {{PROJECT_NAME}}. A test file reaches these by sourcing the
# file -- Tcl's package machinery wants a generated pkgIndex.tcl, and a
# namespace plus source is the whole module system without one.

namespace eval {{PROJECT_SNAKE}} {
    namespace export greet
}

proc {{PROJECT_SNAKE}}::greet {name} {
    return "Hello, $name!"
}
