# The kitchen sink suite

Every generated project ships a single `kitchen-sink` test file: fifteen executable,
all-passing assertions that together are a cheatsheet for the language's toolbox. One
page, read top to bottom in under a minute.

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

This extends to the vocabulary the assertions are written in. The javascript template
first shipped its error example as a `parseRoll` refusing more than ten pins, which is
Bowling with the serial numbers filed off — close enough to hand over the domain model
before the reader has started. Name the variables after nothing: `items`, `counts`,
`record`, `values`. The example exists to show the language, so a domain is pure risk.

## Not koans

Koans are fill-in-the-blank exercises that start red and go green as you work through
them. This suite is the opposite: **every assertion is filled in and passing on the
first run.** It is reference material that happens to be executable, which is what keeps
it from rotting — CI runs it on every supported platform, so a wrong claim about the
language fails the build.

A red suite on a fresh bootstrap would also contradict the whole promise of the tool.

## Fifteen assertions, allocated once

One file. **Fifteen assertions, and that is a ceiling rather than a target.** Sections in
the order below, the same sections in every language, so templates stay comparable side
by side.

The budget is divided by how many of the twelve katas need each thing. That count is in
[the traceability table](#coverage-is-traceable-to-the-katas) below, and it is the whole
argument for these numbers rather than any others.

| Section | Slots | Covers |
| ------- | ----- | ------ |
| collections | 3 | list, map, set — append, lookup, missing key, length, slice, membership |
| strings | 3 | split, join, slice, character access, repeat, trim, interpolation |
| types and branching | 3 | record or struct, a fixed set of named states, a branch that yields a value |
| iteration | 2 | loop with the index, and walking a sequence with lookahead |
| functions | 2 | passing a function to a function, and folding a list to one value |
| errors | 1 | the language's native failure idiom, and how a test asserts it |
| gotchas | 1 | the single quirk most likely to cost an hour |

This supersedes the ten numbered files the design started with. Ten files at five to
eight assertions each is fifty to eighty assertions, which cannot coexist with a budget
of fifteen: either eight files hold one test apiece, or the kata filter gets abandoned to
pad them out. The budget is the constraint carrying the value, so the files went.

The javascript template shipped the old shape first, and what it cost is worth recording.
Three files of five assertions, each locally reasonable, added up to a suite that spent
every slot on themes at most one kata needs — and had nothing at all for types,
collections or strings. A file per theme hides that. One page with one budget cannot.

There is no separate smoke test. The first assertion proves the toolchain runs; a test
asserting `1 + 1 == 2` earns nothing.

What is *not* here is as deliberate as what is. Equality, operators and the primitive
types get a passing mention inside another section at most. Fifteen slots do not stretch
to a language tour, and a reader who wants one has the language's own documentation.

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

The same test applies to **every individual assertion**, not just to themes, and it is the
one that keeps these files short. Name the kata that needs this line. If you cannot, cut
it — however true or interesting it is. Reference material nobody reaches for is not
reference material.

## Failure is expressed natively

The rule that makes the errors slot worth spending: **do not port the JavaScript version
into every language.** Each template represents failure the way its community does.

One slot, so it carries both halves at once: the idiom, and how a test asserts it. The
second half is the one people reach for, because asserting a refusal is the red step of
the TDD loop for every invalid input a kata has.

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
| Fortran                 | a status argument (`iostat=`, `stat=`); no exceptions exist       |

## Gotchas are deliberately not uniform

Gotchas is the one section that differs completely between templates. It carries the
thing most likely to bite someone arriving from another language.

**It is one slot now, down from a file of four to six.** That is the sharpest cut the
fifteen-assertion budget makes, and it deserves saying plainly: most of a language's
quirks no longer ship. The table below is candidates, not a checklist. Pick the one that
would cost a newcomer the most time and leave the rest to folklore. For javascript that
is lexicographic `sort()`, which quietly produces a wrong answer instead of an error.

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

The bar is the same everywhere: a surprise, not a syntax reminder. If an assertion would
not surprise anyone, it belongs in another section or nowhere.

## When a section doesn't fit the language

Every template has every section. Where the language genuinely lacks a construct, **the
section asserts what the language does instead, and says so.** The absence is the lesson.

- **C types** — no sum types, no generics, no namespaces, no methods. Assert `struct`,
  `enum` as plain integer constants, and a tagged union built by hand from a `struct`
  with a discriminant. The amount of machinery this takes *is* the point.
- **C collections** — no map and no set in the standard library. Assert the array, and
  that this absence is why a kata solution in C is longer than the same one elsewhere.
- **C errors** — no exceptions and no `Result`. Assert the return-code convention and
  `errno`, including the part everyone forgets: `errno` is only meaningful after a call
  that actually failed.
- **Prolog iteration** — no loops. Assert recursion, `between/3`, `forall/2` and
  `findall/3`.
- **Prolog functions** — predicates, not functions. Assert arity, multiple solutions,
  and `call/N`.
- **Go types** — no sum types and no exhaustive match. Assert interface dispatch and a
  type switch, and note that the compiler will not check you covered every case.
- **JavaScript types** — the same absence. A lookup table makes the cases obvious, and
  the fallback is the reader's to remember.
- **Elm errors** — no exceptions and no `try`. `Result` and `Maybe` are the whole story.
- **Gleam, Elm, Haskell iteration** — no `while` or `until`. Assert recursion and folds
  in their place.

Do not skip a section and do not leave one near-empty. A reader comparing Go to Gleam
should be able to find the types section in both and see exactly what changed.

## It is meant to be deleted

The suite is one file and no *source* file depends on it. When you start real work:

```console
$ rm kitchen-sink.test.js
$ make test
```

still builds and passes.

**One concession, and it is Zig's.** Where the language's build system has no test
discovery, the build script has to name the suite, and deleting the file means deleting
that declaration with it. `templates/zig` is the first case: `build.zig` carries a
five-line block with a comment saying to remove it. The rule that survives is the one
that matters — nothing you write depends on the suite, and no target points at it — but
"one file" is now "one file, and the lines that name it". Do not extend this to a
language whose runner can find its own tests; see
[template-contract.md](template-contract.md#the-makefile-targets).

There is no companion `KITCHEN-SINK.md`. An earlier design had one, to keep the
explanation out of the generated `README.md` — the README is about the project you are
building, not the scaffolding you were handed, and it must survive the deletion
unchanged. That constraint still holds; the orientation just moved somewhere that leaves
no file behind at all. `bootstrap.sh` prints it as the last thing it does, naming the
file and linking the kata list.

## Test conventions

Applied in every template, adapted to the language's runner:

- **Arrange-Act-Assert**, visually distinct.
- **A name is a complete sentence, readable on its own.** It describes the behaviour in
  plain language rather than naming the syntax, and states a fact rather than giving
  advice. The body shows how the thing is spelled; the name says what happens.

  | Instead of | Write |
  | ---------- | ----- |
  | `is the only value not equal to itself` | `not-a-number does not equal itself` |
  | `reports object, which is a bug old enough to be permanent` | `null reports its type as object` |
  | `compare within a tolerance instead` | `adding two tenths does not give three tenths` |
  | `undefined is absence the runtime produced` | `a property that was never set reads as empty` |

  The first column is not invented: it is what the javascript template shipped with
  before this rule existed. The faults are a fragment that needs its parent, an opinion
  in place of a behaviour, advice in place of a fact, and prose in place of a result.
- **Parametrise over a table** rather than copy-pasting near-identical bodies — `t.Run`
  loops in Go, `@pytest.mark.parametrize`, `forAll`, or a plain loop over a list of cases
  inside one test. But a table must not spend the file's whole budget: a nine-row
  `typeof` table is nine of the eight assertions you are allowed. Assert the rows that
  surprise and drop the rest.
- **One assertion, one idea.** These files are read far more often than they are run. A
  quirk and the spelling that avoids it are one idea, so they share a body.
- **Flat, with no grouping block.** Sections are plain comments, never nested blocks. A
  `describe` wrapper invites a name that only parses next to its parent, which is exactly
  the fragment the rule above bans — and the leaf is what CI output, `grep` and failure
  reports show.
- The file lives wherever the language's runner discovers it **without a declaration
  anywhere**: the project root in JavaScript, beside the source in Zig, `tests/` in Rust
  and Python, `test/` in Erlang and Gleam. It is one file wherever that is. Discovery
  outranks convention here — Rust's suite would be `src/`-adjacent by habit, but a
  `#[cfg(test)] mod` needs a `mod kitchen_sink;` line in the crate root, and naming the
  suite is the one thing the contract forbids.
