#include "{{PROJECT_SNAKE}}.h"
#include "unity.h"

void test_a_greeting_addresses_the_name_it_is_given(void) {
  char greeting[32];

  greet("world", greeting, sizeof(greeting));

  TEST_ASSERT_EQUAL_STRING("Hello, world!", greeting);
}
