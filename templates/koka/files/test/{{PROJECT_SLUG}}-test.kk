module {{PROJECT_SLUG}}-test

import lib/tap
import {{PROJECT_SLUG}}

pub fun main() : <console,exn> ()
  with suite(1)
  ok(greet("world") == "Hello, world!", "greet wraps a name in a greeting")
