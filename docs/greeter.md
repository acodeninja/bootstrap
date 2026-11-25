# The greeter

Every generated project ships a `greet` function and one test for it. The function is
three lines and the test asserts one string, which is the whole of what it does. What it
is *for* is the comments: they are the only place in this repo that explains how a
function is declared, exported, tested, named and run **in the language you just picked**.

It is step 1 of the course — [Hello, World](katas/hello-world.md) — already solved, so the
first thing a reader does is read the answer rather than guess at it.

## Comments are the payload here, and nowhere else

This is a deliberate exception and it is worth stating plainly, because every other rule in
this repo says comments are rare and over-commenting is the first thing to look for. That
rule is right about code whose reader already knows the language. It is wrong about the
first file somebody opens in Forth.

So the greeter is the one file where a comment may say what the line does. The
[kitchen sink](kitchen-sink.md) is the other half of the same idea and takes the opposite
approach: it is reference material, read once, then deleted. The greeter survives into real
work, so its comments are written for somebody who will still be reading them in a month.

Everything else in a generated project keeps the ordinary rule.

## Five things, and nothing else

The budget is five questions, in this order, in every language:

| # | The question | Which file |
| - | ------------ | ---------- |
| 1 | How is a function declared, and what makes it visible outside this file? | src |
| 2 | How does the runner find this test, with nothing naming it? | test |
| 3 | How is a test named, and where does that name appear when it fails? | test |
| 4 | How does one assertion read? | test |
| 5 | How do I run it? | test |

Five, because that is what a reader needs before they can write the second function. It is
a ceiling rather than a target, the same way fifteen assertions is for the sink.

**What is not here is as deliberate as what is.** No tour of the type system, no second
example, no list of what else the runner can do — the sink covers the language and the
runner's own documentation covers the runner. A comment that is interesting but answers
none of the five gets cut.

## The bar for one line

**Name the mistake a reader would make without it.** If you cannot name the mistake, the
comment is decoration.

| Instead of | Write |
| ---------- | ----- |
| `# return the greeting` | nothing — the code says that |
| `# this is a function` | `# def makes a function; nothing exports it, because every name in a module is importable` |
| `// the test` | `// node:test walks the tree for *.test.js, so no file lists this one` |
| `% assert they are equal` | `% assertion/1 throws, and a thrown goal is how a plunit test fails` |

The second column is longer, and that is the trade this file makes on purpose.

**The greeting is never the subject.** Nothing here explains what `"Hello, world!"` means,
because nobody needs that explained. The subject is always the language.

## It is not deletable

The [kitchen sink](kitchen-sink.md#it-is-meant-to-be-deleted) is one file nothing depends
on, and `rm` followed by `make test` still passes. The greeter is the opposite: it is the
test that **survives** that deletion, which is the whole reason
[template-contract.md](template-contract.md) asks for a test under `src/` at all.

Two consequences:

- Whatever is written here is permanent in somebody's real project, so it may not read as
  scaffolding. No "delete this when you start work", no reference to the course, no
  reference to this repo.
- Deleting the sink must not orphan it. Several templates reach the greeter test through
  shared infrastructure that is not itself a test — `forth/tests/tester.fs`,
  `bqn/tests/tester.bqn`, `ats/tests/tap.hats`, `koka/test/lib/tap.kk`,
  `mercury/tests/tap.m`, `objc/tests/tap.h`, `haskell/test/Spec.hs`, `lean/test.lean`,
  `julia/test/runtests.jl` and `gleam`'s entry module. Those survive too.

## It must ship formatted and lint-clean

`make fmt` on a freshly scaffolded project has to change nothing, and `make lint` has to
pass — CI asserts both, on two architectures, and comments are the single
most-reformatted thing in a source file. So the procedure is not optional:

```console
$ ./bootstrap.sh <id> ../scaffold --no-pull
$ cd ../scaffold
$ make lint
$ make fmt && git status --porcelain      # must print nothing
$ make test
```

Write the comments, run that, and take the formatter's answer rather than arguing with it.

Three templates were done first, chosen to break: `java` for the strictest linter and
formatter in the set, `forth` for a hand-rolled TAP runner whose assertion syntax and
comment syntax collide, and `befunge` for having no comment syntax at all. All three pass
`make lint`, leave `make fmt` with nothing to do, and still pass with the sink deleted —
`befunge` went from seven rows to twenty-two and still prints its greeting. Nothing in the
set is harder than those three, so the procedure above is known to be sufficient.

### What bites, by language

Twenty-five templates have no formatter at all and are unconstrained. The rest are, and
these are the ones that have actually broken something:

| Row | What happens |
| --- | ------------ |
| `befunge` | **There is no comment syntax.** Prose survives only because the pointer never reaches it: the file opens `v` in column 0, so the pointer travels down column 0 and a leading space on every prose line is the no-op it passes through. Prose therefore goes **between that opening `v` and the first `>` row**, and nowhere else — the `>`/`v`/`<` rows below it are a coupled routing block. A column is semantics, `make fmt` says "moving a cell changes the program", and the sink's header records a bug where the file grew past row 50 and `p` began overwriting the suite. Both of this template's files keep their count at `0,-1`, one row above the playfield, which is what makes growing them safe at all. |
| `ocaml`, `ats`, `fsharp`, `pascal` | A comment is delimited by `(*` and `*)`, and the lexer still reads character literals inside it — so an apostrophe in English prose breaks the build. Write around it. |
| `java` | Google checkstyle at `severity=error`: a 100-column cap, `CommentsIndentation`, four Javadoc-asterisk rules, `SummaryJavadoc` (no lowercase start), `JavadocParagraph`, and a rule that **bans banner comments**. `spotlessApply` reflows Javadoc. **Use `//` and never `/** */`**: every one of those Javadoc rules then has nothing to find, and google-java-format leaves a `//` block at the right indentation alone. Keep comments out of an annotation list too — above `@Test`, not between it and `@DisplayName`. |
| `basic` | A comment is a numbered `REM`, and line numbers are the call targets — the greeter is at 9100 and the TAP reporter at 8000. Commenting consumes the address space. |
| `forth` | `}T` takes the rest of its line as the test name, so **no comment shares a line with an assertion** — a `\` there is swallowed into the name rather than ignored. Prose goes above the definition or the assertion it describes. `\` and `(` each need a following space, and the `( addr u -- addr u )` stack effect is documentation and syntax at once: a stray `)` inside it ends it early. |
| `intercal` | The only comment is `DON'T`, and the runner scrapes `DON'T ok - ` as TAP. Prose must never begin that way. |
| `objc` | clang-format LLVM at 100 columns, so `ReflowComments` and `SortIncludes` are both on. The blank line between `#import "tap.h"` and the project's own header is load-bearing and must not be filled. |
| `r` | Two of them. lintr runs with defaults, so `commented_code_linter` fails on a comment whose text parses as R — a worked call in a comment is a lint error — and `line_length_linter` caps comments at 80. Then `formatR` **reflows comment paragraphs and deletes `#`-only separator lines**, so a block written in paragraphs comes back as one. Write it, run `make fmt`, and commit what it gives you. |
| `smalltalk` | `"` is a comment and `'` is a string. An unbalanced `"` silently swallows code, and `gst-test` fails on any stderr at all. |
| `haskell` | A comment may not **begin** with `$` or `^`: ormolu reads those as the start of a Haddock named chunk or a trailing doc comment and **deletes the line**, which `--mode check` then fails on. `--` followed by an operator character is an operator rather than a comment, so `-->` needs a space. |
| `elm` | elm-format is not configurable, moves comments, and enforces its own blank lines around top-level declarations. |
| `dart` | `dart format` hard-wraps at 80 and rewraps `///`; lint is `--fatal-infos`. |
| `lolcode` | `BTW` must begin a statement, and `src/` is spliced into each test with `HAI` and `KTHXBYE` stripped — a comment outside those markers is lost. |
| `tcl` | `#` is a comment only where a command may begin. Inside a `switch` arm list or an `expr` body it is an argument. |
| `zig` | `///` is a compile error anywhere but immediately before a declaration, and `//!` only at the top of a file. There is no block comment. |
| `visualbasic` | No block comment exists; every line needs its own apostrophe, and a continuation underscore cannot be followed by one. |
| warnings as errors | `ada`, `arm32`, `asp`, `c`, `commonlisp`, `cpp`, `erlang`, `lean` — commenting a line out leaves an unused binding, which fails `make lint`. |
| first lines that cannot move | `cobol`'s source-format directive at seven spaces, `pascal`'s mode directive, `ruby`'s frozen-string pragma, `racket`'s `#lang`, `raku`'s `unit module`, `bash`'s shellcheck shell directive. |
| column caps counting comments | 80 — `dart`, `octave`, `r`, `sql`, `typescript`. 88 — `python`. 98 — `elixir`. 100 — `c`, `cpp`, `erlang`, `java`, `objc`, `scala`, `swift`. 120 — `groovy`, `lua`, `ruby`. 140 — `kotlin`. |

`bash`'s existing shellcheck directives and `arm32`'s register-convention block are not
prose: they are load-bearing, and they are preserved rather than rewritten.

## Where a language has no greeter

Six rows cannot have the ordinary one, and each gets the nearest thing the language has
rather than an apology. The comments explain the substitution, because the substitution is
the lesson.

| Row | What stands in |
| --- | -------------- |
| `sql` | A real `greet(name text) returns text`. A function is the unit of work here, which the template's own README already says, so this is the one of the six that simply gains a greeter. |
| `asp` | A rule deriving a greeted atom from a fact. Nothing is called and nothing returns, and a string cannot be built without leaving for a Lua term. |
| `befunge` | The program that prints the greeting. There is no import of any kind, so nothing in `src/` can be called from anywhere — the comments say so. |
| `intercal` | Subroutine `(200)`, reached by `DO (200) NEXT`, answering through the shared variables `.1` and `.3`. There are no parameters and no return values. |
| `qsharp` | `Encode`, writing an integer across a qubit register. A string has no length, no index, no split and no join, so there is no greeting to return. |
| `octave` | The existing function, which is named after the project because Octave takes a function's name from its filename. |

`mercury` has a greeter under a different name — `greeting/1`, beside a `shouted/2`
predicate — because that pair is what shows a function against a predicate. It stays.

## Why not generate it

The same reason the kitchen sink is written by hand in each language: a greeter ported from
another template teaches that template's idiom. `rust` returns a `String`, `zig` takes a
caller-owned buffer and can fail, `cobol` writes into a linkage-section out-param, `bash`
prints rather than returns, and `forth` leaves an address and a count on the stack. Each of
those is the right answer in its own language and wrong in the other four, and the comments
are where that gets said.
