// #pragma once instead of an include guard. It is not in the standard and every
// compiler that matters supports it, which is the trade this project takes --
// the guard form, three lines of #ifndef, is in the C template beside this one.
#pragma once

// A header includes what its own declarations need and nothing more: anything
// extra lands on every file that includes it, and in C++ that is measured in
// compile time.
#include <string>
#include <string_view>

// A namespace, which C has no equivalent of -- in C the only way to avoid a
// collision is a prefix on every name. Everything between the braces is
// greeter::something to a caller.
namespace greeter {

// The declaration. Visibility in C++ is the same deal as in C: a caller
// includes this to learn the signature, the linker finds the definition in the
// object file, and an anonymous namespace or `static` is the only way to hide
// one.
//
// Two string types, deliberately. string_view is a borrowed view of characters
// somebody else owns, so passing a literal copies nothing; std::string is owned
// text this function allocates and hands over. The signature says "lend me a
// name and I will give you a greeting of your own" -- which is also why nothing
// here needs a buffer argument the way the C version does.
std::string greet(std::string_view name);

} // namespace greeter
