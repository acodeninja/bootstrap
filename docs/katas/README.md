# Katas

A kata is a programming exercise you work through to learn something other than the
answer. This directory holds two things: **a course for each of the 64 templates**, and an
index of every kata the sources below carry, so a course is a path through a catalogue
rather than a list somebody had to invent.

Seventy-five katas have a brief here. The rest are in [the catalogue](#the-catalogue) with
their sources, which is all a kata needs — a brief exists where a course sends somebody.

Briefs restate the problem and say what it teaches. **None of them contains a solution or
a hint past that**, for the reason
[kitchen-sink.md](../kitchen-sink.md#why-not-ship-a-kata) already gives for not shipping a
solved kata: handing over the answer to an exercise somebody was about to do is a bad
trade.

## How a course is built

Four rules, and they are what make 64 courses read as one system.

1. **Step 1 is always [Hello, World](hello-world.md)**, and it is the one step that ships
   solved. Every project carries a `greet` function and a test for it, commented for
   exactly this purpose — see [greeter.md](../greeter.md). The reader reads the answer,
   runs it, breaks it, then writes their own. It tests the toolchain, not the reader.
2. **Step 2 is a starter kata**, and it is [FizzBuzz](fizzbuzz.md) on fifty-eight rows:
   the first loop, branch, division and string output, and the first test the reader
   writes rather than reads. Six rows take [leap years](leap-years.md) instead, because
   they have no usable string or no division operator and FizzBuzz there is a sitting's
   work rather than ten minutes — `arm32`, `asp`, `befunge`, `intercal`, `lolcode` and
   `qsharp`.
3. **Step 3 is a feature kata**: a small problem chosen so that the thing this language is
   *for* is the thing that solves it. Fifty-four of them, listed in
   [the feature katas](#the-feature-katas) below, and they are the step that stops a Rust
   course being a Java course with different punctuation.
4. **Then the follow-ons**, three katas from the language's track, which is where the
   course used to end. They are suggestions rather than steps: the group picks up
   whichever it fancies, and the catalogue is right behind them.

Three steps, because that is an evening each and a week in total. The old five-step course
is still here — its last three entries are the follow-ons.

A course stops where the language stops. No step needs a primitive the language lacks,
which is why some rows have two follow-ons and `befunge` has one. The reason is in each
brief, under *Not available in*.

## The courses

Every course starts [Hello, World](hello-world.md). This table is what comes after, and it
is the source the CI check reads: each template's `README.md` repeats its own row, and
nothing but CI can keep two hand-written copies of one list in step.

| id | track | starter | feature kata | then |
| -- | ----- | ------- | ------------ | ---- |
| `ada` | Systems | [fizzbuzz](fizzbuzz.md) | [subtypes-and-contracts](subtypes-and-contracts.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `arm32` | Constrained | [leap-years](leap-years.md) | [the-register-contract](the-register-contract.md) | [roman-numerals](roman-numerals.md) |
| `asp` | Declarative | [leap-years](leap-years.md) | [choice-rules](choice-rules.md) | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `ats` | Proof and effects | [fizzbuzz](fizzbuzz.md) | [linear-types](linear-types.md) | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `bash` | Text processing | [fizzbuzz](fizzbuzz.md) | [exit-status-and-the-subshell](exit-status-and-the-subshell.md) | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) |
| `basic` | Constrained | [fizzbuzz](fizzbuzz.md) | [computed-gosub](computed-gosub.md) | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) → [bowling](bowling.md) |
| `befunge` | Playfield | [leap-years](leap-years.md) | [the-playfield-is-the-program](the-playfield-is-the-program.md) | [langtons-ant](langtons-ant.md) |
| `bqn` | Array and numeric | [fizzbuzz](fizzbuzz.md) | [tacit-programming](tacit-programming.md) | [bowling](bowling.md) → [game-of-life](game-of-life.md) |
| `c` | Systems | [fizzbuzz](fizzbuzz.md) | [tagged-unions-by-hand](tagged-unions-by-hand.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `clojure` | Lisp | [fizzbuzz](fizzbuzz.md) | [persistent-data-structures](persistent-data-structures.md) | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `cobol` | Constrained | [fizzbuzz](fizzbuzz.md) | [condition-names](condition-names.md) | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) → [bowling](bowling.md) |
| `commonlisp` | Lisp | [fizzbuzz](fizzbuzz.md) | [syntactic-macros](syntactic-macros.md) | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `cpp` | Systems | [fizzbuzz](fizzbuzz.md) | [visiting-a-variant](visiting-a-variant.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `csharp` | Mainstream | [fizzbuzz](fizzbuzz.md) | [query-over-a-sequence](query-over-a-sequence.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `d` | Systems | [fizzbuzz](fizzbuzz.md) | [code-that-runs-at-compile-time](code-that-runs-at-compile-time.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `dart` | Mainstream | [fizzbuzz](fizzbuzz.md) | [absence-in-the-type](absence-in-the-type.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `elixir` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [pattern-matched-function-heads](pattern-matched-function-heads.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `elm` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [illegal-states-unrepresentable](illegal-states-unrepresentable.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `erlang` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [actors-and-mailboxes](actors-and-mailboxes.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `flix` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [datalog-in-an-expression](datalog-in-an-expression.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `forth` | Constrained | [fizzbuzz](fizzbuzz.md) | [defining-words](defining-words.md) | [leap-years](leap-years.md) → [rpn-calculator](rpn-calculator.md) |
| `fortran` | Array and numeric | [fizzbuzz](fizzbuzz.md) | [whole-array-operations](whole-array-operations.md) | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `fsharp` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [units-of-measure](units-of-measure.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `gleam` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [no-loops-only-recursion](no-loops-only-recursion.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `go` | Mainstream | [fizzbuzz](fizzbuzz.md) | [channels-and-select](channels-and-select.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `groovy` | Mainstream | [fizzbuzz](fizzbuzz.md) | [closures-that-remember](closures-that-remember.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `haskell` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [laziness](laziness.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `haxe` | Mainstream | [fizzbuzz](fizzbuzz.md) | [abstract-types](abstract-types.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `intercal` | Playfield | [leap-years](leap-years.md) | [come-from](come-from.md) | [roman-numerals](roman-numerals.md) |
| `java` | Mainstream | [fizzbuzz](fizzbuzz.md) | [records-and-pattern-switch](records-and-pattern-switch.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `javascript` | Mainstream | [fizzbuzz](fizzbuzz.md) | [closures-that-remember](closures-that-remember.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `julia` | Array and numeric | [fizzbuzz](fizzbuzz.md) | [multiple-dispatch](multiple-dispatch.md) | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `koka` | Proof and effects | [fizzbuzz](fizzbuzz.md) | [effect-rows](effect-rows.md) | [roman-numerals](roman-numerals.md) → [turnstile](turnstile.md) |
| `kotlin` | Mainstream | [fizzbuzz](fizzbuzz.md) | [absence-in-the-type](absence-in-the-type.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `lean` | Proof and effects | [fizzbuzz](fizzbuzz.md) | [proofs-beside-the-code](proofs-beside-the-code.md) | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `lolcode` | Constrained | [leap-years](leap-years.md) | [guard-before-you-leap](guard-before-you-leap.md) | [roman-numerals](roman-numerals.md) |
| `lua` | Mainstream | [fizzbuzz](fizzbuzz.md) | [metatables](metatables.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `mercury` | Declarative | [fizzbuzz](fizzbuzz.md) | [modes-and-determinism](modes-and-determinism.md) | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `nim` | Mainstream | [fizzbuzz](fizzbuzz.md) | [code-that-runs-at-compile-time](code-that-runs-at-compile-time.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `objc` | Message passing | [fizzbuzz](fizzbuzz.md) | [messages-not-calls](messages-not-calls.md) | [roman-numerals](roman-numerals.md) → [tennis](tennis.md) → [video-store](video-store.md) |
| `ocaml` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [functors](functors.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `octave` | Array and numeric | [fizzbuzz](fizzbuzz.md) | [whole-array-operations](whole-array-operations.md) | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `pascal` | Systems | [fizzbuzz](fizzbuzz.md) | [values-and-references](values-and-references.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `perl` | Text processing | [fizzbuzz](fizzbuzz.md) | [context](context.md) | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `php` | Mainstream | [fizzbuzz](fizzbuzz.md) | [match-and-enums](match-and-enums.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `pony` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [reference-capabilities](reference-capabilities.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `powershell` | Text processing | [fizzbuzz](fizzbuzz.md) | [the-object-pipeline](the-object-pipeline.md) | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `prolog` | Declarative | [fizzbuzz](fizzbuzz.md) | [backtracking](backtracking.md) | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `python` | Mainstream | [fizzbuzz](fizzbuzz.md) | [generators](generators.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `qsharp` | Proof and effects | [leap-years](leap-years.md) | [superposition](superposition.md) | [bowling](bowling.md) → [turnstile](turnstile.md) |
| `r` | Array and numeric | [fizzbuzz](fizzbuzz.md) | [whole-array-operations](whole-array-operations.md) | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `racket` | Lisp | [fizzbuzz](fizzbuzz.md) | [syntactic-macros](syntactic-macros.md) | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `raku` | Text processing | [fizzbuzz](fizzbuzz.md) | [grammars](grammars.md) | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `ruby` | Mainstream | [fizzbuzz](fizzbuzz.md) | [blocks-and-enumerable](blocks-and-enumerable.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `rust` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [ownership-and-borrowing](ownership-and-borrowing.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `scala` | Pattern matching | [fizzbuzz](fizzbuzz.md) | [typeclasses-by-given](typeclasses-by-given.md) | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `scheme` | Lisp | [fizzbuzz](fizzbuzz.md) | [tail-recursion-and-continuations](tail-recursion-and-continuations.md) | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `smalltalk` | Message passing | [fizzbuzz](fizzbuzz.md) | [messages-not-calls](messages-not-calls.md) | [roman-numerals](roman-numerals.md) → [tennis](tennis.md) → [test-framework](test-framework.md) |
| `sql` | Declarative | [fizzbuzz](fizzbuzz.md) | [set-at-a-time](set-at-a-time.md) | [bowling](bowling.md) → [turnstile](turnstile.md) → [test-framework](test-framework.md) |
| `swift` | Mainstream | [fizzbuzz](fizzbuzz.md) | [absence-in-the-type](absence-in-the-type.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `tcl` | Text processing | [fizzbuzz](fizzbuzz.md) | [everything-is-a-string](everything-is-a-string.md) | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) |
| `typescript` | Mainstream | [fizzbuzz](fizzbuzz.md) | [narrowing-to-never](narrowing-to-never.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `visualbasic` | Mainstream | [fizzbuzz](fizzbuzz.md) | [query-over-a-sequence](query-over-a-sequence.md) | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `zig` | Systems | [fizzbuzz](fizzbuzz.md) | [code-that-runs-at-compile-time](code-that-runs-at-compile-time.md) | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |

Each generated project carries its own course in its `README.md`, so nobody has to come
back here to find it. This table is the place to see all 64 at once.

## Why these tracks

Eleven tracks, and three of them exist only because following the sources out of the Made
Tech list widened the pool:

- **Game of Life** is the array-language kata. Every cell is the same arithmetic over its
  neighbours, which is the one problem shape `bqn`, `octave`, `r`, `julia` and `fortran`
  are actually built for.
- **Eight Queens** is what `prolog`, `mercury` and `asp` exist to do. Writing down what a
  legal board is and letting the solver find the boards is the entire argument for having
  a logic language, and nothing on the original twelve asks for it.
- **Leap years** needs no strings and no collections, which is exactly the position
  `arm32`, `asp`, `befunge`, `intercal`, `lolcode` and `qsharp` are in — so it is the
  starter those six take in place of FizzBuzz. It is the only kata in the catalogue with
  no missing-primitive caveat at all, which is what qualifies it for the job.

Three single-row deviations earn the same note, and all three are now a course's last
follow-on rather than its final step. `forth` ends on
[RPN calculator](rpn-calculator.md), because the kata is a stack machine and so is the
language. `befunge` does [Langton's Ant](langtons-ant.md), because a 2D ant on a grid is
the one thing a 2D playfield is better at than anything else here. `smalltalk` ends on
[Test framework](test-framework.md), because SUnit is where every runner in
[languages.md](../languages.md) descends from.

## What a language cannot do

Four missing primitives decide every *Not available in* section, and each one is asserted
in the template's own suite rather than claimed here:

| Wall | Blocks | Rows |
| ---- | ------ | ---- |
| no strings | word-wrap, number-to-lcd, wordle, diamond, string-calculator | `intercal`, `befunge`, `lolcode`, `qsharp`, `asp` |
| no first-class functions | test-framework | `befunge`, `lolcode`, `basic`, `intercal`, `asp` |
| nothing catches a failure | test-framework | `qsharp`, `lolcode`, `befunge`, `intercal`, `arm32` |
| no polymorphism | video-store, tennis-refactoring | `sql`, `asp`, `bqn`, `befunge`, `intercal`, `lolcode`, `basic`, `forth`, `arm32`, `qsharp` |

`asp` is the one row that is not a general-purpose language at all: clingo grounds a
finite program, so unbounded iteration and arbitrary-length output are not expressible,
and building a string means leaving for a Lua `@`-term. The consequence inverts what you
would expect — ARM32 assembly can do Roman numerals and ASP cannot.

[Snake](snake.md) is blocked everywhere, by the harness rather than by a language:
[kitchen-sink.md](../kitchen-sink.md) keeps I/O out of every template on purpose, so
nothing here has an input or render path. Two catalogue katas are out for the same reason:
[Ohce](https://kata-log.rocks/ohce-kata) reads from stdin, and
[Anagram](https://codingdojo.org/kata/Anagram/) needs a dictionary file.

## The sources

Six, each reached by following a citation rather than picked by us. The first is where
this repo has always pointed; the next three are catalogues; the last two are single-kata
sources the Made Tech pages name.

| Source | Carries |
| ------ | ------- |
| [Made Tech](https://learn.madetech.com/technology/katas/) | The twelve this repo linked before this directory existed |
| [Coding Dojo](https://codingdojo.org/kata/) | 61 katas, cited by five of those twelve |
| [Kata-Log](https://kata-log.rocks) | 31 katas with difficulty tags, cited by Mars Rover |
| [Emily Bache](https://github.com/emilybache) | 28 kata repositories, cited by Tennis Refactoring |
| [Clean Coders](https://cleancoders.com) | Cited by Video Store |
| [Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch) | Cited by Test Framework |

**Two sources agreeing is a fact worth recording, not a duplicate to hide.** Video Store
is Coding Dojo's Movie Rental, is Emily Bache's Theatrical Players, is chapter 1 of
Fowler's *Refactoring* — one kata, four citations. The catalogue below is deduplicated by
problem, and every row lists each source that carries it.

Starting code for the refactoring katas is **linked, never vendored**. Those repositories
carry their own licences, and [template-contract.md](../template-contract.md) already sets
the bar for third-party code here: a link clears it and a copy opens a question.

## The feature katas

Fifty-four briefs, written here rather than followed out of a catalogue, because a
catalogue is organised by problem and these are organised by language. A catalogue kata
asks "can you score a bowling game"; a feature kata asks "can you do the one thing this
language is better at than the other sixty-three".

Four rules decided them:

1. **One per feature, not one per language.** The brief is named after the feature, so the
   rows that share one are sharing an honest fact rather than a template. Seven briefs are
   shared, by two or three rows each; forty-seven belong to one row alone.
2. **The feature has to be the answer, not decoration.** If the problem can be solved
   comfortably without it, it is the wrong problem — so `rust` gets a tally three functions
   need rather than a tally one function needs, and `go` gets two workers rather than one.
3. **It has to fit in an evening**, like FizzBuzz and unlike Bowling. The feature is the
   hard part; the problem must not be.
4. **It must not duplicate a follow-on.** Exhaustive matching over a state machine is
   already [tennis](tennis.md) and [turnstile](turnstile.md), which is why the eleven
   pattern-matching rows get eleven *different* features instead of one brief about
   matching.

**Four are a first exposure rather than reinforcement**, and their briefs say so:
`comptime` is nowhere in zig's kitchen sink, grammars are nowhere in raku's, koka's sink
shows built-in effects but never a handler of your own, and lean's template contains no
`theorem`, `decide` or `Prop` at all. The other fifty are grounded in something the
reader has already seen pass.

| Brief | Rows |
| ----- | ---- |
| [absence-in-the-type](absence-in-the-type.md) | `dart`, `kotlin`, `swift` |
| [abstract-types](abstract-types.md) | `haxe` |
| [actors-and-mailboxes](actors-and-mailboxes.md) | `erlang` |
| [backtracking](backtracking.md) | `prolog` |
| [blocks-and-enumerable](blocks-and-enumerable.md) | `ruby` |
| [channels-and-select](channels-and-select.md) | `go` |
| [choice-rules](choice-rules.md) | `asp` |
| [closures-that-remember](closures-that-remember.md) | `groovy`, `javascript` |
| [code-that-runs-at-compile-time](code-that-runs-at-compile-time.md) | `d`, `nim`, `zig` |
| [come-from](come-from.md) | `intercal` |
| [computed-gosub](computed-gosub.md) | `basic` |
| [condition-names](condition-names.md) | `cobol` |
| [context](context.md) | `perl` |
| [datalog-in-an-expression](datalog-in-an-expression.md) | `flix` |
| [defining-words](defining-words.md) | `forth` |
| [effect-rows](effect-rows.md) | `koka` |
| [everything-is-a-string](everything-is-a-string.md) | `tcl` |
| [exit-status-and-the-subshell](exit-status-and-the-subshell.md) | `bash` |
| [functors](functors.md) | `ocaml` |
| [generators](generators.md) | `python` |
| [grammars](grammars.md) | `raku` |
| [guard-before-you-leap](guard-before-you-leap.md) | `lolcode` |
| [illegal-states-unrepresentable](illegal-states-unrepresentable.md) | `elm` |
| [laziness](laziness.md) | `haskell` |
| [linear-types](linear-types.md) | `ats` |
| [match-and-enums](match-and-enums.md) | `php` |
| [messages-not-calls](messages-not-calls.md) | `objc`, `smalltalk` |
| [metatables](metatables.md) | `lua` |
| [modes-and-determinism](modes-and-determinism.md) | `mercury` |
| [multiple-dispatch](multiple-dispatch.md) | `julia` |
| [narrowing-to-never](narrowing-to-never.md) | `typescript` |
| [no-loops-only-recursion](no-loops-only-recursion.md) | `gleam` |
| [ownership-and-borrowing](ownership-and-borrowing.md) | `rust` |
| [pattern-matched-function-heads](pattern-matched-function-heads.md) | `elixir` |
| [persistent-data-structures](persistent-data-structures.md) | `clojure` |
| [proofs-beside-the-code](proofs-beside-the-code.md) | `lean` |
| [query-over-a-sequence](query-over-a-sequence.md) | `csharp`, `visualbasic` |
| [records-and-pattern-switch](records-and-pattern-switch.md) | `java` |
| [reference-capabilities](reference-capabilities.md) | `pony` |
| [set-at-a-time](set-at-a-time.md) | `sql` |
| [subtypes-and-contracts](subtypes-and-contracts.md) | `ada` |
| [superposition](superposition.md) | `qsharp` |
| [syntactic-macros](syntactic-macros.md) | `commonlisp`, `racket` |
| [tacit-programming](tacit-programming.md) | `bqn` |
| [tagged-unions-by-hand](tagged-unions-by-hand.md) | `c` |
| [tail-recursion-and-continuations](tail-recursion-and-continuations.md) | `scheme` |
| [the-object-pipeline](the-object-pipeline.md) | `powershell` |
| [the-playfield-is-the-program](the-playfield-is-the-program.md) | `befunge` |
| [the-register-contract](the-register-contract.md) | `arm32` |
| [typeclasses-by-given](typeclasses-by-given.md) | `scala` |
| [units-of-measure](units-of-measure.md) | `fsharp` |
| [values-and-references](values-and-references.md) | `pascal` |
| [visiting-a-variant](visiting-a-variant.md) | `cpp` |
| [whole-array-operations](whole-array-operations.md) | `fortran`, `octave`, `r` |

## The catalogue

103 katas from the sources above. The twenty-one with a brief are the ones a course uses;
the rest are here with their sources, which is what you need to pick one up. The
fifty-four [feature katas](#the-feature-katas) are not in this table: nothing carries them
but this repo.

| Kata | Brief | Sources |
| ---- | ----- | ------- |
| Anagram | — | [Coding Dojo](https://codingdojo.org/kata/Anagram/) |
| Args | — | [Coding Dojo](https://codingdojo.org/kata/Args/) |
| Bank OCR | — | [Coding Dojo](https://codingdojo.org/kata/BankOCR/) |
| Banking | — | [Kata-Log](https://kata-log.rocks/banking-kata) |
| Birthday Greetings | — | [Coding Dojo](https://codingdojo.org/kata/birthday-greetings/) |
| Bowling | [bowling](bowling.md) | [Made Tech](https://learn.madetech.com/technology/katas/bowling/) · [Coding Dojo](https://codingdojo.org/kata/Bowling/) · [Kata-Log](https://kata-log.rocks/bowling-game-kata) |
| Brainfuck | — | [Coding Dojo](https://codingdojo.org/kata/Brainfuck/) |
| BugsZero | — | [Kata-Log](https://kata-log.rocks/bugs-zero-kata) |
| CalcStats | — | [Bache](https://github.com/emilybache/CalcStats-TestDesign-Kata) |
| Cash Machine | — | [Bache](https://github.com/emilybache/CashMachine-Refactoring-Kata) |
| Christmas Delivery | — | [Coding Dojo](https://codingdojo.org/kata/christmas-delivery/) |
| Christmas Lights | — | [Kata-Log](https://kata-log.rocks/christmas-lights-kata) |
| Clarify Exception | — | [Bache](https://github.com/emilybache/Clarify-Exception-Refactoring-Kata) |
| Clock-in | — | [Kata-Log](https://kata-log.rocks/clock-in-kata) |
| Code Cracker | — | [Coding Dojo](https://codingdojo.org/kata/CodeCracker/) |
| Configure Your Own Wardrobe | — | [Kata-Log](https://kata-log.rocks/configure-wardrobe-kata) |
| CQRS Booking | — | [Coding Dojo](https://codingdojo.org/kata/CQRS_Booking/) |
| Cupcake | — | [Coding Dojo](https://codingdojo.org/kata/cupcake/) |
| Depth First Search | — | [Coding Dojo](https://codingdojo.org/kata/DepthFirstSearch/) |
| Diagram Printer | — | [Bache](https://github.com/emilybache/DiagramPrinter-Refactoring-Kata) |
| Diamond | [diamond](diamond.md) | [Coding Dojo](https://codingdojo.org/kata/Diamond/) · [Bache](https://github.com/emilybache/DiamondKata) |
| Dictionary Replacer | — | [Coding Dojo](https://codingdojo.org/kata/DictionaryReplacer/) |
| Discount Applier | — | [Bache](https://github.com/emilybache/DiscountApplier-TestDesign-Kata) |
| Eight Queens | [eight-queens](eight-queens.md) | [Coding Dojo](https://codingdojo.org/kata/eight-queens/) |
| Elephant Carpaccio | — | [Coding Dojo](https://codingdojo.org/kata/elephant-carpaccio/) · [Kata-Log](https://kata-log.rocks/elephant-carpaccio) |
| Employee Report | — | [Coding Dojo](https://codingdojo.org/kata/Employee-Report/) |
| Encode | — | [Bache](https://github.com/emilybache/Encode-TestDesign-Kata) |
| Enterprise Phonebook | — | [Bache](https://github.com/emilybache/EnterprisePhonebook-TestDesign-Kata) |
| FizzBuzz | [fizzbuzz](fizzbuzz.md) | [Coding Dojo](https://codingdojo.org/kata/FizzBuzz/) · [Kata-Log](https://kata-log.rocks/fizz-buzz-kata) · [Bache](https://github.com/emilybache/FizzBuzz-Refactoring-Kata) |
| FooBarQix | — | [Coding Dojo](https://codingdojo.org/kata/FooBarQix/) |
| Game of Life | [game-of-life](game-of-life.md) | [Coding Dojo](https://codingdojo.org/kata/GameOfLife/) · [Kata-Log](https://kata-log.rocks/game-of-life-kata) |
| Garden Catalogue | — | [Bache](https://github.com/emilybache/GardenCatalogue-TestDesign-Kata) |
| Gilded Rose | — | [Coding Dojo](https://codingdojo.org/kata/gilded-rose/) · [Kata-Log](https://kata-log.rocks/gilded-rose-kata) · [Bache](https://github.com/emilybache/GildedRose-Refactoring-Kata) |
| Gossiping Bus Drivers | — | [Kata-Log](https://kata-log.rocks/gossiping-bus-drivers-kata) |
| Greed | — | [Coding Dojo](https://codingdojo.org/kata/Greed/) |
| Hello, World | [hello-world](hello-world.md) | [Coding Dojo](https://codingdojo.org/kata/Hello/) |
| HTML Converter | — | [Bache](https://github.com/emilybache/HtmlConverter-TestDesign-Kata) |
| Ice Cream Forecasting | — | [Bache](https://github.com/emilybache/IceCreamForecasting-Refactoring-Kata) |
| JEE Web Authentication | — | [Coding Dojo](https://codingdojo.org/kata/JEEWebAuthentication/) |
| Lags | — | [Coding Dojo](https://codingdojo.org/kata/Lags/) |
| Langton's Ant | [langtons-ant](langtons-ant.md) | [Coding Dojo](https://codingdojo.org/kata/LangtonAnt/) |
| Leap Years | [leap-years](leap-years.md) | [Coding Dojo](https://codingdojo.org/kata/LeapYears/) |
| Lift | — | [Kata-Log](https://kata-log.rocks/lift-kata) · [Bache](https://github.com/emilybache/Lift-Kata) |
| Manhattan Distance | — | [Coding Dojo](https://codingdojo.org/kata/manhattan-distance/) · [Kata-Log](https://kata-log.rocks/manhattan-distance-kata) |
| Markov Chain | — | [Coding Dojo](https://codingdojo.org/kata/MarkovChain/) |
| Mars Rover | [mars-rover](mars-rover.md) | [Made Tech](https://learn.madetech.com/technology/katas/mars-rover/) · [Coding Dojo](https://codingdojo.org/kata/mars-rover/) · [Kata-Log](https://kata-log.rocks/mars-rover-kata) |
| Mastermind | — | [Coding Dojo](https://codingdojo.org/kata/Mastermind/) |
| Mathematical AST | — | [Coding Dojo](https://codingdojo.org/kata/mathematical-ast/) |
| Memory Map | — | [Bache](https://github.com/emilybache/MemoryMap-TestDesign-Kata) |
| Minesweeper | — | [Coding Dojo](https://codingdojo.org/kata/Minesweeper/) |
| Nearest Color | — | [Coding Dojo](https://codingdojo.org/kata/NearestColor/) |
| Necklace | — | [Bache](https://github.com/emilybache/Necklace-Refactoring-Kata) |
| Nim | — | [Coding Dojo](https://codingdojo.org/kata/Nim/) |
| Number to LCD | [number-to-lcd](number-to-lcd.md) | [Made Tech](https://learn.madetech.com/technology/katas/number-to-lcd/) · [Coding Dojo](https://codingdojo.org/kata/NumberToLCD/) |
| Numbers in Words | — | [Coding Dojo](https://codingdojo.org/kata/NumbersInWords/) |
| Ohce | — | [Kata-Log](https://kata-log.rocks/ohce-kata) |
| ORM | — | [Coding Dojo](https://codingdojo.org/kata/orm/) |
| Overtime Calculation | — | [Bache](https://github.com/emilybache/OvertimeCalculation-Refactoring-Kata) |
| PacMan | — | [Coding Dojo](https://codingdojo.org/kata/PacMan/) |
| Pagination Seven | — | [Coding Dojo](https://codingdojo.org/kata/PaginationSeven/) |
| Parallel Change | — | [Kata-Log](https://kata-log.rocks/parallel-change-kata) |
| Parrot | — | [Bache](https://github.com/emilybache/Parrot-Refactoring-Kata) |
| Pension Contribution | — | [Bache](https://github.com/emilybache/PensionContribution-TestDesign-Kata) |
| Phone Numbers | — | [Bache](https://github.com/emilybache/Phone-Numbers-Kata) |
| Pizza Maker | — | [Coding Dojo](https://codingdojo.org/kata/pizza-maker/) |
| Poker Hands | — | [Coding Dojo](https://codingdojo.org/kata/PokerHands/) |
| Potter | — | [Coding Dojo](https://codingdojo.org/kata/Potter/) |
| Quote of the Day | — | [Coding Dojo](https://codingdojo.org/kata/QotdCgi/) |
| Race Car — Leaderboard | — | [Kata-Log](https://kata-log.rocks/race-car-katas-leaderboard) |
| Race Car — Telemetry | — | [Kata-Log](https://kata-log.rocks/race-car-katas-telemetry) |
| Range | — | [Coding Dojo](https://codingdojo.org/kata/Range/) |
| Reversi | — | [Coding Dojo](https://codingdojo.org/kata/Reversi/) |
| Roman Calculator | — | [Coding Dojo](https://codingdojo.org/kata/RomanCalculator/) |
| Roman Numerals | [roman-numerals](roman-numerals.md) | [Made Tech](https://learn.madetech.com/technology/katas/roman-numerals/) · [Coding Dojo](https://codingdojo.org/kata/RomanNumerals/) · [Kata-Log](https://kata-log.rocks/roman-numerals-kata) |
| RPG Combat | — | [Bache](https://github.com/emilybache/RPG-Combat-Approval-Kata) |
| RPN Calculator | [rpn-calculator](rpn-calculator.md) | [Coding Dojo](https://codingdojo.org/kata/RPN/) |
| RSA | — | [Coding Dojo](https://codingdojo.org/kata/rsa/) |
| Score Keeper | — | [Kata-Log](https://kata-log.rocks/score-keeper-kata) |
| Sing a Song | — | [Kata-Log](https://kata-log.rocks/sing-a-song-kata) |
| Snake | [snake](snake.md) | [Made Tech](https://learn.madetech.com/technology/katas/snake/) |
| Social Network | — | [Coding Dojo](https://codingdojo.org/kata/social-network/) · [Kata-Log](https://kata-log.rocks/social-network-kata) |
| Strange Characters | — | [Bache](https://github.com/emilybache/StrangeCharacters-Refactoring-Kata) |
| String Calculator | [string-calculator](string-calculator.md) | [Coding Dojo](https://codingdojo.org/kata/StringCalculator/) · [Kata-Log](https://kata-log.rocks/string-calculator-kata) |
| Sudoku | — | [Coding Dojo](https://codingdojo.org/kata/sudoku/) |
| Supermarket Receipt | — | [Bache](https://github.com/emilybache/SupermarketReceipt-Refactoring-Kata) |
| Task List | — | [Kata-Log](https://kata-log.rocks/task-list-kata) |
| Tell Don't Ask | — | [Kata-Log](https://kata-log.rocks/tell-dont-ask-kata) |
| Tennis | [tennis](tennis.md) | [Made Tech](https://learn.madetech.com/technology/katas/tennis/) · [Coding Dojo](https://codingdojo.org/kata/Tennis/) · [Kata-Log](https://kata-log.rocks/tennis-kata) |
| Tennis Refactoring | [tennis-refactoring](tennis-refactoring.md) | [Made Tech](https://learn.madetech.com/technology/katas/tennis-refactoring/) · [Bache](https://github.com/emilybache/Tennis-Refactoring-Kata) |
| Test Framework | [test-framework](test-framework.md) | [Made Tech](https://learn.madetech.com/technology/katas/test-framework/) · [Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch) |
| Texas Hold'em | — | [Coding Dojo](https://codingdojo.org/kata/TexasHoldEm/) |
| Tic Tac Toe | — | [Coding Dojo](https://codingdojo.org/kata/tic-tac-toe/) · [Kata-Log](https://kata-log.rocks/tic-tac-toe-kata) |
| Trading Card Game | — | [Coding Dojo](https://codingdojo.org/kata/TradingCardGame/) |
| Train Reservation | — | [Bache](https://github.com/emilybache/KataTrainReservation) |
| Trip Service | — | [Coding Dojo](https://codingdojo.org/kata/TripService/) · [Kata-Log](https://kata-log.rocks/trip-service-kata) |
| Turnstile | [turnstile](turnstile.md) | [Made Tech](https://learn.madetech.com/technology/katas/turnstile/) |
| Ugly Trivia Game | — | [Kata-Log](https://kata-log.rocks/ugly-trivia-kata) |
| Unusual Spending | — | [Kata-Log](https://kata-log.rocks/unusual-spending-kata) |
| Video Store | [video-store](video-store.md) | [Made Tech](https://learn.madetech.com/technology/katas/video-store/) · [Coding Dojo](https://codingdojo.org/kata/movie-rental/) · [Bache](https://github.com/emilybache/Theatrical-Players-Refactoring-Kata) · [Clean Coders](https://cleancoders.com) |
| Wallet | — | [Coding Dojo](https://codingdojo.org/kata/Wallet/) |
| Word Wrap | [word-wrap](word-wrap.md) | [Made Tech](https://learn.madetech.com/technology/katas/word-wrap/) · [Coding Dojo](https://codingdojo.org/kata/WordWrap/) |
| Wordle | [wordle](wordle.md) | [Made Tech](https://learn.madetech.com/technology/katas/wordle/) |
| Yatzy | — | [Coding Dojo](https://codingdojo.org/kata/Yahtzee/) · [Kata-Log](https://kata-log.rocks/yahtzee-kata) · [Bache](https://github.com/emilybache/Yatzy-Refactoring-Kata) |
