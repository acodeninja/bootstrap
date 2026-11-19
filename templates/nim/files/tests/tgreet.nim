import std/unittest
import ../src/{{PROJECT_SNAKE}}

test "a greeting addresses the name it is given":
  check greet("world") == "Hello, world!"
