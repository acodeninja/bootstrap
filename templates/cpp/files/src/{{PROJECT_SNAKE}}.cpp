// Its own header first, which is a convention with a purpose: if the header
// needs something it does not itself include, putting it before everything else
// makes that a compile error here rather than in the next file to include it.
#include "{{PROJECT_SNAKE}}.hpp"

#include <format>

namespace greeter {

// The definition, repeating the signature from the header -- the two have to
// agree, and nothing generates one from the other.
//
// std::format is C++20 and is the replacement for both printf and iostreams:
// type-safe, and the format string is checked at compile time, so {} with the
// wrong argument count does not build. {} is the placeholder and needs no
// specifier for a type it already knows.
std::string greet(std::string_view name) { return std::format("Hello, {}!", name); }

} // namespace greeter
