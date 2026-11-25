# Settings lookup

A setting has a value, or the user has not set one, or the whole settings file is missing.
Write the lookup that walks those three possibilities and hands back a value with a default
applied — and write it with no run-time check for absence anywhere in your code.

Then try to use a possibly-absent value as though it were present, and read the error.

## What it teaches

That absence is a type rather than a value, and that the compiler will not let you forget
it. The chain is the exercise: each step may come back empty, and the language gives you
the operators that thread the emptiness through without a single `if` — optional chaining,
the null-coalescing default, and the one place you *do* unwrap, which should be exactly
once and at the edge.

Three languages that each decided this separately, and the spellings differ more than the
idea does: Kotlin has `?.`, `?:` and `!!`, Swift has `if let`, `guard let` and `??`, Dart
has `?.`, `??` and `!`. The lesson is the same and the ergonomics are not.

## Where it sits

Step 3 on `kotlin`, `swift` and `dart`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

`rust`, `haskell`, `gleam`, `ocaml`, `elm`, `scala` and `fsharp` have `Option` or `Maybe`
and no sugar for chaining it, which costs more keystrokes for the same guarantee.
`java`, `csharp`, `javascript`, `python`, `go` and `lua` let a null through, which is the
bug this feature was built to delete.

## Source

Written for this repo. Documented at
[Kotlin](https://kotlinlang.org/docs/null-safety.html),
[Swift](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/theBasics/#Optionals)
and [Dart](https://dart.dev/null-safety).
