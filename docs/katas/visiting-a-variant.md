# Cell

A spreadsheet cell holds one of three things: a number, a piece of text, or an error. Write
the type, write a function that describes whatever a cell holds, and write a second that
adds two cells and throws when either is not a number.

## What it teaches

`std::variant` as the sum type the language does have, and `std::visit` as the one place
C++ will tell you a case is missing — a visitor without an overload for every alternative
does not compile, where a `switch` over an `enum class` merely warns. That asymmetry is
worth meeting deliberately.

The throwing half teaches RAII under unwinding: a destructor still runs as the stack comes
apart, which is the whole reason C++ needs no `finally`.

## Where it sits

Step 3 on `cpp`. It assumes FizzBuzz.

## Not available in

`c` has the same problem and no variant, so it builds
[the tagged union by hand](tagged-unions-by-hand.md). Doing both, in that order, is the
best twenty minutes either template offers.

## Source

Written for this repo. Documented at
[cppreference: std::visit](https://en.cppreference.com/w/cpp/utility/variant/visit).
