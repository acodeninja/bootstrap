#include "{{PROJECT_SNAKE}}.hpp"

#include <format>

namespace greeter {

std::string greet(std::string_view name) { return std::format("Hello, {}!", name); }

} // namespace greeter
