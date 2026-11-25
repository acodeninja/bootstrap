// The header for the code under test.
#include "{{PROJECT_SNAKE}}.h"

// Unity is vendored into this project under vendor/ rather than fetched, because
// C has no package manager worth adding one through -- so the framework is
// source you can read when an assertion fails.
//
// The blank line above matters more than it looks. clang-format sorts a
// contiguous block of includes, so with no gap these two would be reordered for
// any project whose name sorts after "unity" -- and `make fmt` would then
// rewrite a file that shipped formatted, which CI rejects.
#include "unity.h"

// Unity has no discovery: its own idiom is a main() that names every test by
// hand. This project generates that main instead, from a script in the image
// that scans test/*.c for exactly this signature -- a line starting at column 0,
// `void`, a name beginning with test_, and `(void)`.
//
// So a test is found by being shaped like one, and deleting a test file is safe.
// Keep the signature on one line and at the left margin; a comment above it is
// fine. Run the suite with `make test`.
//
// The function name is the test name, because there is no string anywhere to put
// one in. It is what a failure prints.
void test_a_greeting_addresses_the_name_it_is_given(void) {
  // The buffer the greeting goes into, sized by us and living on the stack --
  // which is why nothing here frees anything.
  char greeting[32];

  // sizeof on an array gives its size in bytes. Note it only works because
  // `greeting` is an array here: pass it to a function and it decays to a
  // pointer, where sizeof would give the size of the pointer instead. That is
  // the reason greet() has to be told the size rather than working it out.
  greet("world", greeting, sizeof(greeting));

  // EQUAL_STRING, not EQUAL: the plain macro would compare the two pointers,
  // which are never equal, and the test would fail for a reason that has
  // nothing to do with the characters. Expected first, actual second.
  TEST_ASSERT_EQUAL_STRING("Hello, world!", greeting);
}
