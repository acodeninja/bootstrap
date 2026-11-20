#include "{{PROJECT_SNAKE}}.hpp"

#include "doctest.h"

TEST_CASE("a greeting addresses the name it is given") {
  std::string greeting = greeter::greet("world");

  CHECK(greeting == "Hello, world!");
}
