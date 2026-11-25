// tap.h is this project's own twenty-line test vocabulary, under tests/. There
// is no framework: GNUstep ships none, and nothing packaged is worth depending
// on, so the macros below are source you can read.
#import "tap.h"

// The blank line above is load-bearing. clang-format sorts a contiguous block of
// imports, so without the gap these two would be swapped for any project whose
// name sorts after "tap" -- and `make fmt` would then rewrite a file that
// shipped formatted, which CI rejects. Do not close the gap with a comment.
#import "{{PROJECT_SNAKE}}.h"

// Each test file is its own program with its own main, and `make test` runs each
// one and reads the TAP it prints. So a test file is found by existing, and
// deleting one is safe. Run them with `make test`.
int main(void) {
  // No ARC in this template, so memory is managed by hand. An autorelease pool
  // is what gives the autoreleased objects below somewhere to be released at,
  // and draining it is the [pool release] at the foot of this function. Without
  // one, every autoreleased object leaks and Foundation says so on stderr.
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  // TAP opens with the number of assertions about to be made, and the runner
  // checks that count against the ok lines it saw. Add an assertion and this
  // has to change with it: nothing counts for you.
  TAP_PLAN(1);

  // A message send to the class, which is what the leading + on the method
  // declaration bought. @"world" is an NSString literal.
  NSString *greeting = [Greeter greet:@"world"];

  // The macro takes a condition and a name, so the comparison is yours to
  // write -- and it has to be isEqualToString: rather than ==, because == on
  // two objects compares the pointers and these are two different objects with
  // the same characters. The name is what a failure prints.
  TAP_OK([greeting isEqualToString:@"Hello, world!"], "a greeting addresses the name it is given");

  [pool release];
  TAP_DONE();
}
