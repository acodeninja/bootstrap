module {{PROJECT_SLUG}}-test

// lib/tap is this project's own TAP vocabulary, under test/lib: Koka ships no
// test framework, so `suite` and `ok` are twenty lines of source you can read.
import lib/tap
import {{PROJECT_SLUG}}

// Nothing names this file. `make test` compiles and runs every test/*.kk and
// reads the TAP it prints, so a test file is found by existing and deleting one
// is safe. Run the suite with `make test`.
//
// A test file is a program, so it needs a `main` -- and look at its effect row:
// <console,exn>. Printing is an effect and so is failing, so a function that
// does both says so in its type. The greeter under src/ has an empty row for
// exactly the same reason, and that contrast is the whole lesson of this
// template.
pub fun main() : <console,exn> ()
  // `with` is Koka doing something no other row here does: it takes the rest of
  // this function as a block and hands it to `suite`, so the argument is the
  // remainder of the body rather than something in parentheses. That is how a
  // test harness gets to print a plan before and a summary after without any
  // nesting on your side.
  //
  // The 1 is the number of assertions about to be made. Add one and this has to
  // change with it: nothing counts for you, and a plan that disagrees with the
  // ok lines is a failure of its own.
  with suite(1)
  // ok takes a boolean and a name, so the comparison is yours to write. The
  // name is what a failure prints, so write it to read on its own.
  ok(greet("world") == "Hello, world!", "greet wraps a name in a greeting")
