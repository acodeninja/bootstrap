#include "{{PROJECT_SNAKE}}.hpp"

// doctest is a single header vendored under vendor/ rather than fetched, because
// C++ has no package manager this project is willing to depend on -- so the
// framework is source you can read when an assertion fails.
//
// The blank line above matters more than it looks. clang-format sorts a
// contiguous block of includes, so with no gap these two would be reordered for
// any project whose name sorts after "doctest" -- and `make fmt` would then
// rewrite a file that shipped formatted, which CI rejects.
#include "doctest.h"

// Nothing names this test. TEST_CASE expands to a type whose constructor
// registers it with doctest before main runs, and test/main.cpp is three lines
// asking doctest to supply that main -- so a test is found by existing and
// deleting a test file is safe. Run the suite with `make test`.
//
// The name is an ordinary string and can be a real sentence, which is what it
// should be: it is what a failure prints.
TEST_CASE("a greeting addresses the name it is given") {
  // No buffer and nothing to free. greet returns an owned std::string, and its
  // destructor runs when this scope ends -- which is the whole of RAII and the
  // reason C++ needs no `finally` and no explicit cleanup here.
  std::string greeting = greeter::greet("world");

  // CHECK records the failure and carries on; REQUIRE would stop this test
  // case. There is no expected-first convention because the macro sees the
  // expression it was handed and prints both sides of the comparison.
  CHECK(greeting == "Hello, world!");
}
