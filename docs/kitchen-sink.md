# The kitchen sink suite

Every generated project ships a `kitchen-sink/` test suite: a small set of executable,
all-passing assertions that together are a cheatsheet for the language's toolbox.

The framing is **"here are the tools you'll need to solve any of these katas"** —
the [Made Tech kata list](https://learn.madetech.com/technology/katas/). The coverage is
derived by working backwards from what those katas actually require.

## Why not ship a kata

An earlier version of this design shipped a solved Roman numerals module and a pending
Bowling kata stub. Both are wrong:

- **It spoils the katas.** Roman numerals and Bowling are two of the twelve on that list.
  Handing someone the solution to an exercise they were about to do is a bad trade.
- **It teaches a domain, not a language.** Knowing how somebody scored a bowling game in
  Gleam does not tell you how to write a `while` loop in Gleam. The kata is the thing you
  bring; the language is the thing you need handed to you.

## Not koans

Koans are fill-in-the-blank exercises that start red and go green as you work through
them. This suite is the opposite: **every assertion is filled in and passing on the
first run.** It is reference material that happens to be executable, which is what keeps
it from rotting — CI runs it on every supported platform, so a wrong claim about the
language fails the build.

A red suite on a fresh bootstrap would also contradict the whole promise of the tool.

## The ten themes

Ten files, five to eight assertions each, same numbering and same concepts in every
language so the templates are comparable side by side.

| File              | Covers                                                                                                                                                |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `01_values`       | declaration, mutable vs immutable binding, inference vs annotation, the primitive types, absence, shadowing                                           |
| `02_operators`    | arithmetic, integer vs float division, modulo with negative operands, precedence, overflow behaviour                                                  |
| `03_equality`     | value vs reference equality, structural equality of collections, float comparison tolerance, comparing absence, coercion                              |
| `04_control_flow` | if/else, conditional expression, switch/match and exhaustiveness, truthiness, for over a range, for with index, while, until/do-while, break/continue |
| `05_collections`  | list, map, set, tuple — append, lookup, missing key, length, slice, sort, iteration order guarantees                                                  |
| `06_strings`      | interpolation, split, join, repeat, slice, character access, case, trim, length vs unicode                                                            |
| `07_functions`    | definition, multiple returns, default and optional parameters, closures over state, map/filter/fold, recursion                                        |
| `08_types`        | record/struct, enum/sum type, exhaustive match on it, interface or protocol dispatch                                                                  |
| `09_errors`       | the language's native failure idiom — raising, returning, handling                                                                                    |
| `10_gotchas`      | four to six quirks specific to this language                                                                                                          |

There is no separate smoke test. The first assertion in `01_values` proves the toolchain
runs; a second file asserting `1 + 1 == 2` earns nothing.

## Coverage is traceable to the katas

This table is the argument that the scope is right, and the check that stops the suite
growing into a full language tour.

| Kata               | Themes it draws on                                                 |
| ------------------ | ------------------------------------------------------------------ |
| Bowling            | `02` arithmetic · `04` loop with index · `05` slice and lookahead  |
| Wordle             | `05` set and map · `06` character compare · `08` enum result       |
| Number to LCD      | `06` repeat, chunk, join · `05` list building                      |
| Roman numerals     | `02` arithmetic · `05` ordered table · `06` string building        |
| Snake              | `01` mutable state · `05` deque · `08` record and direction enum   |
| Tennis             | `04` match · `08` enum                                             |
| Tennis Refactoring | `07` extraction · `08` types                                       |
| Turnstile          | `04` and `08` exhaustive match on a state enum                     |
| Word Wrap          | `06` split and slice · `07` recursion                              |
| Test Framework     | `07` closures and higher-order functions · `09` catching failure   |
| Video Store        | `08` sum type or interface · `05` collections · `06` formatting    |
| Mars Rover         | `02` modulo · `06` parsing a command string · `08` enum and record |

Anything no kata needs — concurrency, generics, modules, I/O, reflection — stays out.
If you are tempted to add a theme, name the kata that needs it first.

## Failure is expressed natively

The rule that makes `09_errors` worth shipping: **do not port the JavaScript version
into twenty-six languages.** Each template represents failure the way its community
does.

| Language                | Failure idiom                                                     |
| ----------------------- | ----------------------------------------------------------------- |
| JavaScript / TypeScript | `throw`, asserted with `assert.throws`                            |
| Go                      | `(T, error)` with sentinel errors, `errors.Is`                    |
| Rust                    | `Result<T, E>`, enum + `Display`, no error crate                  |
| Zig                     | error union `Error!T`, `try`, `expectError`                       |
| C                       | return code plus `errno` — there are no exceptions                |
| C++                     | `throw` a `std::runtime_error` subclass, RAII cleanup             |
| Python                  | `raise` a `ValueError` subclass, `pytest.raises`                  |
| Ruby                    | `raise` a `StandardError` subclass, minitest `assert_raises`      |
| Java                    | checked exceptions — the signature declares what can fail         |
| C#                      | `throw`, with `TryParse`-style `bool` + `out` as the counterpoint |
| PHP                     | typed exceptions extending `Throwable`                            |
| Swift                   | `throws` + `do`/`catch`, and `Result` where a value is wanted     |
| Dart                    | `throw` any object, `on` clauses to catch by type                 |
| Elixir                  | `{:ok, v}` \| `{:error, r}`, with a `!` variant that raises       |
| Haskell                 | `Either Error a`                                                  |
| OCaml                   | `('a, error) result`                                              |
| F#                      | `Result<'T, Error>`                                               |
| Elm                     | `Result Error a` — the language has no exceptions at all          |
| Gleam                   | `Result(a, Error)`                                                |
| Erlang                  | `{ok, V}` \| `{error, Reason}`                                    |
| Clojure                 | `ex-info` carrying `{:type ::invalid}`                            |
| Kotlin                  | sealed error class + `Result<T>`                                  |
| Nim                     | `raise newException(ValueError, ...)`                             |
| Lua                     | `nil, "message"` multiple return                                  |
| Prolog                  | the predicate simply fails                                        |

## Gotchas are deliberately not uniform

`10_gotchas` is the one file that differs completely between templates. It carries the
four to six things that actually bite someone arriving from another language.

| Language   | The sort of thing that belongs here                                                            |
| ---------- | ---------------------------------------------------------------------------------------------- |
| JavaScript | `0.1 + 0.2 !== 0.3`, `typeof null === 'object'`, `[] == false`, `sort()` is lexicographic      |
| Go         | nil interface is not a nil pointer, `append` aliasing, zero values, loop variable capture      |
| Python     | mutable default arguments, `is` vs `==`, late-binding closures                                 |
| Ruby       | `0` is truthy, `nil` vs `false`, `and` vs `&&` precedence                                      |
| Lua        | 1-based indexing, `#` on a sparse table, assigning `nil` removes the key                       |
| Erlang     | strings are lists of integers, `=` is pattern match not assignment, atoms are never collected  |
| Prolog     | `=` is unification not assignment, `is/2` evaluates and `=` does not, cut changes solutions    |
| Haskell    | laziness and space leaks, `String` vs `Text`, `head` is partial                                |
| C          | array decay to pointers, `sizeof` on a parameter, integer promotion, `strncpy` not terminating |
| Java       | `==` on boxed `Integer`, autoboxing a `null`, `String` interning, erased generics              |
| PHP        | `==` vs `===`, string-to-number comparison rules, arrays being list and map at once            |

The remaining templates follow the same bar: a surprise, not a syntax reminder. If an
assertion would not surprise anyone, it belongs in one of the other nine files.

## When a theme doesn't fit the language

Every template has all ten files. Where the language genuinely lacks a construct, **the
file asserts what the language does instead, and says so.** The absence is the lesson.

- **C `01_values`** — manual memory is the lesson the other 25 templates cannot teach.
  Assert stack versus heap, `malloc`/`free`, and what a pointer actually holds.
- **C `08_types`** — no sum types, no generics, no namespaces, no methods. Assert
  `struct`, `enum` as plain integer constants, and a tagged union built by hand out of a
  `struct` with a discriminant. The amount of machinery this takes *is* the point.
- **C `09_errors`** — no exceptions and no `Result`. Assert the return-code convention
  and `errno`, including the part everyone forgets: `errno` is only meaningful after a
  call that actually failed.
- **Prolog `01_values`** — no mutable variables. Assert unification, singleton warnings,
  and `assertz`/`retract` as the escape hatch for state.
- **Prolog `04_control_flow`** — no loops. Assert recursion, `between/3`, `forall/2`,
  `findall/3`, and what cut does to backtracking.
- **Prolog `07_functions`** — predicates, not functions. Assert arity, multiple
  solutions, and `call/N`.
- **Go `08_types`** — no sum types and no exhaustive match. Assert interface dispatch and
  a type switch, and note that the compiler will not check you covered every case.
- **Elm `09_errors`** — no exceptions and no `try`. `Result` and `Maybe` are the whole
  story, and that is worth one assertion of its own.
- **Gleam, Elm, Haskell `04_control_flow`** — no `while` or `until`. Assert recursion and
  folds in their place.

Do not skip a file, and do not leave it near-empty. A reader comparing Go to Gleam
should be able to open `08_types` in both and see exactly what changed.

## It is meant to be deleted

The suite lives in `kitchen-sink/` alongside `KITCHEN-SINK.md`, and nothing else in the
project depends on it. When you start real work:

```console
$ rm -r kitchen-sink KITCHEN-SINK.md
$ make test
```

still builds and passes. That is why the explanation lives in `KITCHEN-SINK.md` and not
in the generated `README.md` — the README is about the project you are building, not the
scaffolding you were handed, and it should survive the deletion unchanged.

## Test conventions

Applied in every template, adapted to the language's runner:

- **Arrange-Act-Assert**, visually distinct.
- **Names describe scenario and outcome.** `modulo_of_negative_follows_dividend_sign`,
  not `test_3`. A failure should be legible without opening the file.
- **Parametrise over a table** rather than copy-pasting near-identical bodies — `t.Run`
  loops in Go, `@pytest.mark.parametrize`, `describe.each`, `forAll`.
- **One assertion, one idea.** These files are read far more often than they are run.
- Tests live where the language puts them: beside the source in Rust and Zig, in `test/`
  in Erlang and Gleam, in `tests/` in Python.
