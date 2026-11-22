/* TAP_PLAN(n), then TAP_OK(condition, name) n times, then TAP_DONE().
 *
 * Twelve lines rather than a dependency, because no unit-test framework for
 * Objective-C is packaged anywhere. Macros rather than functions: -Werror
 * refuses a static function the including file does not call, and a test that
 * asserts nothing should still compile. */

#include <stdio.h>

static int tap_reported;
static int tap_failed;

#define TAP_PLAN(count) printf("1..%d\n", (count))

#define TAP_OK(condition, name)                                                                    \
  do {                                                                                             \
    int tap_passed = (condition) ? 1 : 0;                                                          \
    tap_reported++;                                                                                \
    tap_failed += 1 - tap_passed;                                                                  \
    printf("%sok %d - %s\n", tap_passed ? "" : "not ", tap_reported, (name));                      \
  } while (0)

#define TAP_DONE() return tap_failed == 0 ? 0 : 1
