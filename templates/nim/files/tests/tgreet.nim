# Nothing names this file. `nimble test` compiles and runs every file under
# tests/ whose name starts with `t`, which is the convention the tool is built
# around -- so a test is found by that prefix, and deleting one is safe. Run the
# suite with `make test`.
import std/unittest

# The import path is a string literal, and that is deliberate. A bare
# `import ../src/name` goes through the identifier rules, so a project named
# after a Nim keyword -- `out`, for instance -- would not compile; quoting the
# path skips the check at no cost in readability.
import "../src/{{PROJECT_SNAKE}}"

# `test` is a template, which is Nim's lightweight macro: the name is an
# ordinary string and can be a real sentence, and the block after the colon is
# its body. It is what a failure prints, so write it to read on its own.
#
# There is no `suite` wrapper here on purpose. unittest allows a bare `test`,
# and a suite block would put a second name in front of this one in the output.
test "a greeting addresses the name it is given":
  # `check` is also a template rather than a function, so it can see the
  # expression it was handed -- a failure prints each side and its value, which
  # is why there is no checkEqual to learn and no expected-first order to
  # remember. `doAssert` is the plainer alternative and reports less.
  check greet("world") == "Hello, world!"
