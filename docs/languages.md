# Languages

The 60 targets, their chosen tooling, and when each lands. This is the implementer's
worksheet: one row is one template.

Test runners are chosen **stdlib-first**. A built-in runner is one less dependency to
install, one less thing to pin, and one less thing to rot in two years. A third-party
runner appears only where the language has no credible built-in (`hspec`, `busted`,
`alcotest`, `xUnit`, `PHPUnit`, and the two vendored C/C++ frameworks `Unity` and
`doctest`).

Base images were resolved against the registry on 2026-11-19: newest stable release,
Debian variant, picked by semantic version sort rather than by recency. Ordering registry
tags by last-updated does not give the newest version — maintenance branches get security
patches, so an old minor can outrank a current one. See
[containers.md](containers.md#base-images) for the official/vendor/hand-rolled split.

| id           | base image                                     | test runner                  | lint / fmt                           | wave |
| ------------ | ---------------------------------------------- | ---------------------------- | ------------------------------------ | ---- |
| `javascript` | `node:26.13.1-trixie-slim`                     | `node:test`                  | eslint / prettier                    | 0    |
| `zig`        | `debian:trixie-20261104-slim` + zig 0.17.1     | `std.testing`                | `zig fmt --check` / `zig fmt`        | 0    |
| `go`         | `golang:1.27.4-trixie`                         | `go test`                    | `go vet` / `gofmt`                   | 1    |
| `rust`       | `rust:1.100.0-slim-trixie`                     | `cargo test`                 | `clippy` / `rustfmt`                 | 1    |
| `python`     | `python:3.15.2-slim-trixie`                    | `pytest`                     | `ruff check` / `ruff format`         | 1    |
| `typescript` | `node:26.13.1-trixie-slim`                     | `node:test` + `tsc --noEmit` | eslint / prettier                    | 1    |
| `ruby`       | `ruby:4.0.10-slim-trixie`                      | `minitest`                   | `rubocop` / `rubocop -a`             | 1    |
| `elixir`     | `elixir:1.20.5-otp-29-slim`                    | `ExUnit`                     | `mix credo` / `mix format`           | 1    |
| `php`        | `php:8.6.0-cli-trixie` + `composer:2.11.2`     | `PHPUnit`                    | `phpstan` / `php-cs-fixer`           | 1    |
| `swift`      | `swift:6.4.2-trixie`                           | `swift-testing` + `XCTest`   | `swift format lint --strict` / `swift format` | 1    |
| `dart`       | `dart:3.14.1-sdk`                              | `package:test`               | `dart analyze` / `dart format`       | 1    |
| `erlang`     | `erlang:29.1.2.0-slim`                         | `eunit`                      | `dialyzer` / `erlfmt`                | 2    |
| `gleam`      | `ghcr.io/gleam-lang/gleam:v1.19.2-erlang-slim` | `gleeunit`                   | `gleam format --check` / `gleam format` | 2    |
| `clojure`    | `clojure:temurin-25-tools-deps-1.12.7.1681-trixie-slim` | `clojure.test`               | `clj-kondo` / `cljfmt`               | 2    |
| `haskell`    | `haskell:9.14.1-slim-bookworm`                 | `hspec`                      | `hlint` / `ormolu`                   | 2    |
| `kotlin`     | `gradle:9.9.1-jdk25`                           | `kotlin.test`                | `ktlint` / `ktlint -F`               | 2    |
| `java`       | `gradle:9.9.1-jdk25`                           | `JUnit 5`                    | `checkstyle` / `spotless`            | 2    |
| `fsharp`     | `mcr.microsoft.com/dotnet/sdk:10.0.404`        | `xUnit v3`                   | `fantomas --check` / `fantomas`      | 2    |
| `csharp`     | `mcr.microsoft.com/dotnet/sdk:10.0.404`        | `xUnit v3`                   | `dotnet format --verify-no-changes`  | 2    |
| `ocaml`      | `ocaml/opam:debian-13-ocaml-5.5` + digest      | `alcotest` via `dune test`   | `dune build @fmt` / `dune fmt`       | 2    |
| `nim`        | `nim:2.2.14`                                   | `unittest`                   | `nim check` / `nimpretty`            | 2    |
| `prolog`     | `swipl:11.0.0`                                 | `plunit`                     | `check` + status flags / —           | 2    |
| `elm`        | `node:26.13.1-trixie-slim` + elm 0.19.3-0      | `elm-test`                   | `elm-format --validate` / `--yes`    | 3    |
| `lua`        | `debian:trixie-20261104-slim` + lua5.4, luarocks | `busted`                     | `luacheck` / `stylua`                | 3    |
| `c`          | `gcc:16.2.0-trixie` + Unity 2.7.0 (vendored)   | `Unity`                      | `clang-format` check / in place      | 3    |
| `cpp`        | `gcc:16.2.0-trixie` + doctest 2.5.3 (vendored) | `doctest`                    | `clang-format` check / in place      | 3    |
| `fortran`    | `gcc:16.2.0-trixie` + fpm 0.14.0               | `test-drive` via `fpm test`  | `fprettify --diff` / `fprettify`     | 4    |
| `pascal`     | `debian:trixie-20261104-slim` + fpc 3.2.2      | `fpcunit`                    | `fpc -Sew` / —                       | 4    |
| `perl`       | `perl:5.44.0-slim-trixie`                      | `Test::More` via `prove`     | `perlcritic` / `perltidy`            | 4    |
| `cobol`      | `debian:trixie-20261104-slim` + GnuCOBOL 3.2   | TAP + `RETURN-CODE`          | `cobc -fsyntax-only -Wall` / —       | 4    |
| `basic`      | `debian:trixie-20261104-slim` + bwbasic 2.20   | TAP                          | — / —                                | 4    |
| `lolcode`    | `debian:trixie-20261104-slim` + lci 1.3        | TAP                          | — / —                                | 4    |
| `intercal`   | `debian:trixie-20261104-slim` + C-INTERCAL     | TAP from Roman numerals      | `ick -c` / —                         | 4    |
| `r`          | `debian:trixie-20261104-slim` + R 4.5.0        | `testthat`                   | `lintr` / `formatR`                  | 4    |
| `ada`        | `debian:trixie-20261104-slim` + GNAT 14.2      | `AUnit`                      | `gnatc` + `gnatwae` / —              | 4    |
| `forth`      | `debian:bookworm-20261104-slim` + gforth 0.7.3 | TAP, own `T{ -> }T`          | `gforth` compile / —                 | 4    |
| `arm32`      | `debian:trixie-20261104-slim` + binutils, qemu | TAP over semihosting         | `as --fatal-warnings` / —            | 4    |
| `d`          | `debian:trixie-20261104-slim` + LDC 1.40.0, dub 1.40.0 | `dub test`                   | `dscanner --styleCheck` / `dfmt`     | 5    |
| `objc`       | `debian:trixie-20261104-slim` + gobjc 14, GNUstep 1.31 | TAP, own `tap.h`             | `gcc -fsyntax-only -Wall -Werror` / `clang-format` | 5    |
| `asp`        | `debian:trixie-20261104-slim` + clingo 5.6.2    | clingo exit status to TAP    | `gringo --warn=all` / —              | 5    |
| `ats`        | `debian:trixie-20261104-slim` + ATS2 0.4.2      | TAP, own `tap.hats`          | `patsopt --typecheck` / —            | 5    |
| `julia`      | `julia:1.13.4-trixie`                          | `Test` (stdlib)              | `JuliaFormatter --check` / `--inplace` | 5    |
| `groovy`     | `gradle:9.9.1-jdk25` + Groovy 6.0.0            | `Spock 2.5`                  | `codenarc` / —                       | 5    |
| `flix`       | `eclipse-temurin:25.0.5.1_2-jdk-noble` + flix 0.80.0 | `flix test`            | `flix check` / `flix format`         | 5    |
| `haxe`       | `haxe:4.3.7-trixie` + utest 1.13.2             | `utest`                      | `--interp --no-output` + `formatter --check` / `formatter` | 5    |
| `raku`       | `rakudo-star:2026.09-trixie`                   | `Test` via `prove6`          | `raku -c` / —                        | 5    |
| `commonlisp` | `debian:trixie-20261104-slim` + SBCL 2.5.2, cl-fiveam 1.4.3 | `FiveAM`        | `sbcl` compile, warnings fatal / —   | 5    |
| `koka`       | `debian:trixie-20261104-slim` + Koka 3.2.9      | TAP, own `test/lib/tap.kk`   | `koka --library --no-compile` / —    | 5    |
| `lean`       | `debian:trixie-20261104-slim` + Lean 4.36.0     | `lake test`                  | `lake build`, warnings fatal / —     | 5    |
| `mercury`    | `debian:trixie-20261104-slim` + Mercury 22.01.9 from source | TAP, own `tap.m` | `mmc --make <mod>.check` / —         | 5    |
| `tcl`        | `debian:trixie-20261104-slim` + Tcl 8.6.16      | `tcltest` (stdlib)           | bytecode parse check / —             | 6    |
| `sql`        | `debian:trixie-20261104-slim` + SQLite 3.46.1, sqlfluff 4.5.0 | TAP through `sqlite3` | `sqlfluff lint` / `sqlfluff format`  | 6    |
| `scheme`     | `debian:trixie-20261104-slim` + Guile 3.0.10    | `SRFI-64`                    | `compile-file`, warnings fatal / —   | 6    |
| `racket`     | `debian:trixie-20261104-slim` + Racket 8.16     | `raco test` + `rackunit`     | `raco expand` / —                    | 6    |
| `scala`      | `eclipse-temurin:25.0.5.1_2-jdk-noble` + scala-cli 1.19.0 | `munit` 1.3.6      | `scalac -Wunused:all -Werror` / `scala-cli fmt` | 6    |
| `pony`       | `debian:trixie-20261104-slim` + ponyc 0.78.2    | `PonyTest`                   | `ponyc --pass verify` / —            | 6    |
| `qsharp`     | `python:3.15.2-slim-trixie` + QDK 1.34.0        | `qdk.test_utils.run_tests`   | QDK type checker / —                 | 6    |
| `bqn`        | `debian:trixie-20261104-slim` + CBQN 0.12.0 from source | TAP, own `Ok` vocabulary | `•BQN` compile-only / —              | 6    |
| `befunge`    | `debian:trixie-20261104-slim` + cfunge 1,001 from source | TAP, `q` carries the count | — / —                              | 6    |
| `smalltalk`  | `debian:trixie-20261104-slim` + GNU Smalltalk 3.2.5 from source | `SUnit`      | `gst` compile / —                    | 6    |

## Waves

Difficulty is now "does a usable image exist", not "can a version manager pin it". The
grouping follows from that — see [roadmap.md](roadmap.md) for what each wave delivers.

- **Wave 0** proves both image strategies before anything else is written: `javascript`
  on an official image, `zig` hand-rolled from `debian:trixie-slim`.
- **Wave 1** is official image plus a stdlib test runner — the cheapest rows.
- **Wave 2** is an official or vendor image with a real build tool underneath (the JVM,
  the BEAM, .NET, dune, opam). The images do the installing; the work is the build config.
- **Wave 3** is the remaining hand-rolled images, plus the two templates that vendor a
  test framework because the language has no stdlib one.
- **Wave 4** is everything added after the first twenty-six shipped. Its rows are not
  ordered by difficulty, because they arrive when somebody asks for them.
- **Wave 5** is the paradigm pass: thirteen rows picked because a cell in the language
  matrix was empty or thinly occupied rather than because somebody asked, plus the four
  that came off the Deferred list. See [paradigm coverage](#paradigm-coverage).
- **Wave 6** is a different axis from wave 5: its rows were chosen for the *model of
  computation* the first fifty missed — a declarative query language, an array language,
  a two-dimensional playfield, an image-based object system, actors with reference
  capabilities, a quantum language — rather than for a cell in the paradigm matrix.
  Some, like `scheme` and `tcl`, are instead languages that were simply overdue.

## Paradigm coverage

The first thirty-seven rows were chosen by what people write and by whether a usable image
existed. Nobody had checked the *paradigm* spread, and five cells were thin. Thirteen rows
in wave 5 fill them, and the honest accounting matters as much as the list: three of the
five already had an occupant, so those rows are a second one rather than a first.

| cell                                  | already there          | wave 5 adds                  |
| ------------------------------------- | ---------------------- | ---------------------------- |
| logic                                 | `prolog`               | `asp`, `mercury`, `flix`     |
| functional, memory not garbage collected | — (`swift` is ARC but not functional) | `koka`, `lean`, `ats` |
| systems, dynamically typed            | `forth`                | `objc`, `commonlisp`         |
| systems, garbage collected            | `go`, `nim`            | `d`                          |
| scripting, statically typed           | `typescript`, `dart`   | `haxe`, `raku`               |

**Only two cells were genuinely empty**: a second logic language, and a functional language
whose memory is reference counted or hand-managed. The three new logic rows are each a
different mechanism — `prolog` resolves, `asp` finds models, `mercury` type- and
mode-checks, `flix` embeds Datalog in a functional language — which is the point of having
four rather than one. `koka` and `lean` count references, `ats` frees by hand with linear
types, and every other functional row here traces.

The remaining four of the thirteen — `julia`, `groovy`, `raku` and `haxe` — came off the
Deferred list, which is now empty of languages. They had been declined on audience rather
than on whether the template would be good, and two of them turned out to be among the
better rows in the table.

**What this does not claim.** The cells are a coverage check, not a taxonomy: `flix` is
functional as much as it is logic, `objc` is a systems language with a dynamic object model
bolted onto a static one, and `raku`'s typing is gradual rather than static. A row earns its
place by being a good template, and the matrix is only what stopped the choice being made by
popularity alone.

## Where lint and fmt prove nothing

Twenty-eight of the lint and fmt targets above do nothing, across twenty-five templates,
and they are worth one list rather than twenty-five notes. **`basic`, `befunge` and
`lolcode` have no `lint`**: neither Bywater BASIC nor `lci` has a check mode, a
syntax-only flag or a third-party checker, and in Befunge there is no such thing as a
syntax error — every byte is a valid playfield cell — so `make lint` prints why and exits
0. CI runs it, and for those three it is theatre.

**Twenty-five have no `fmt`** — `ada`, `arm32`, `asp`, `ats`, `basic`, `befunge`, `bqn`,
`cobol`, `commonlisp`, `forth`, `groovy`, `intercal`, `koka`, `lean`, `lolcode`,
`mercury`, `pascal`, `pony`, `prolog`, `qsharp`, `racket`, `raku`, `scheme`, `smalltalk`
and `tcl`. Koka ships one binary with no format subcommand and issue 521 has been open
since 2024; Lean's release tarball carries a compiler, a linker and a build tool and
nothing that rewrites source; no BQN formatter exists for any implementation; a Befunge
program is a grid and a column position is as much a part of it as the characters are, so
there is nothing a formatter could safely do; nothing packaged formats Smalltalk, and
`gst-convert` translates between chunk and bracket syntax rather than formatting either;
Pony ships no formatter and no third-party one exists; the released QDK wheel installs no
console scripts at all, and Q#'s formatter lives only inside the language server;
Potassco publish no formatter for ASP and nothing third-party is packaged; ATS2 ships
`patscc` and `patsopt` and nothing that formats; Common Lisp indentation is a function of
what each macro means, which is why editors ship indent tables rather than formatters,
and Scheme has the same problem with nothing packaged to solve it; Racket's `raco fmt`
lives in a third-party package that publishes no version tags, so there is no version to
pin; nothing packaged formats Tcl and no third-party candidate is stable enough to pin;
Raku's only candidate, `Perl6::Tidy`, reaches into compiler internals that no longer
exist and fails on any input; Spotless's `greclipse` step deletes the space before every
`>`, so `n > 1` comes back as `n> 1` and seven Eclipse formatter options will not stop
it; `gnatpp` ships only with AdaCore's own distribution; GnuCOBOL, lci, gforth, GNU as
and SWI-Prolog publish no formatter; Free Pascal's `ptop` capitalises keywords and
dedents `end;` to column 0, which is worse than leaving the file alone.
Each one's `.editorconfig` carries the indent the language expects instead.

The alternative in both cases was a target that looked like a check. A reader
cannot tell a check that passed from one that was never made, so these say so.

## Notes on individual rows

**`cpp` follows `c`'s vendoring precedent and needs none of its machinery.** doctest is a
single header committed to `files/vendor/doctest/`, with the same provenance header and the
same `vendor/`-excluded-by-construction file list. But `TEST_CASE` macros self-register and
`DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN` in one translation unit supplies `main`, so discovery is
free: no generated runner, no glob, nothing naming the suite. Where `c` needed an image-baked
`unity-discover` and a forced regeneration, `cpp` ships a three-line `test/main.cpp`.

It is also the clearest demonstration of why these are two templates rather than one. C's
errors slot is a return code plus `errno`; C++'s throws a `std::runtime_error` subclass and
asserts that a destructor still runs as the stack unwinds. Its gotcha is
`map::operator[]` inserting a default-constructed value on a read, where C's is
array-versus-struct argument semantics. Nothing is ported.

One check needed relaxing rather than the template: a brace-elided aggregate initialiser —
`std::map<std::string, int> counts{{"a", 1}}` — matches a bare `{{` grep, and in C++ that is
simply how you write it. The contract's actual pattern is `{{[A-Z_]\{2,\}}}`, which requires
two or more uppercase-or-underscore characters and does not match brace init at all. The bare
`{{` form was an over-strict convenience check, not the contract.

**`c` is the first template to vendor a test framework, and it sets the precedent.** Unity is
**committed** into `files/vendor/unity/` rather than fetched in a `RUN` layer, and that choice
is the point: the contract's vendoring rule is written about the *generated project* — lives
in `vendor/`, version and upstream URL in a header on every file, excluded from lint and fmt,
licence named in the README — and a fetch into the image satisfies none of it, because the
code would then be somewhere the reader of a failing assertion cannot see. It costs 294 KB.

It also avoided zig's concession. Unity has no discovery — the idiom is a `main` naming every
test, and its own `generate_test_runner.rb` needs a Ruby the `gcc` image does not ship. An
image-baked `unity-discover` writes that `main` from the `test/*.c` files `build.mk` globs,
emitting `UnitySetTestFile` and a `#line` per test so a failure reports the real file and
line rather than the generated runner in `/cache`.

**The subtle part is when to regenerate.** Depending on the test sources' mtimes is not
enough: deleting the kitchen sink changes the *set* of files without touching any survivor,
so make skips the regeneration and the link then fails on undefined references to the
deleted tests. The runner is rewritten every run and kept only when the bytes differ.

**`gcc` 16.2.0 under `-Wall -Wextra -Werror` refuses to compile three of the four classic C
footguns** — `sizeof` on an array parameter, a signed/unsigned comparison and a provably
truncating `snprintf` all become errors. Shipping any of them would have needed a
`#pragma GCC diagnostic ignored`, which reads exactly like suppressing a warning to go green,
so the gotcha is array-versus-struct argument semantics instead: standard-guaranteed,
warning-free, and nothing a flag can save you from.

The real compile rules live in the project's own `build.mk`, run inside the container. C has
no build tool, so they have to live somewhere, and keeping them in the project means a reader
can change `CFLAGS` without rebuilding the image.

**`elm` spends its token on a directory, because no Elm module can be named from it.** A
module's name must match its path below a source directory *and* start with a capital, and
`{{PROJECT_SNAKE}}` is lowercase — so `src/{{PROJECT_SNAKE}}.elm` can hold no legal module at
all. `java`'s package-private escape has no analogue here, because the rule binds every
module rather than only exposed ones. So `source-directories` is `["src/{{PROJECT_SNAKE}}"]`
holding a fixed `Greeter`, following `clojure`'s precedent of putting the token in a path
segment.

**It pins its compiler twice, and only `make build` notices when the two disagree.** elm
0.19.3 rejects an `elm.json` whose `elm-version` is `0.19.1`, while `elm-test` ignores the
field entirely and runs green against a mismatched one. `elm make` is the fussier half
throughout: it demands an `elm/json` dependency nothing imports and the exact transitive
closure, rejecting any extra or missing entry as "edited by hand" without saying which.

The node slim image **carries no root certificates and elm links its own TLS stack**, so the
first package fetch fails with `certificate has unknown CA` under a message asking whether
you are on a slow connection. `elm-stuff` also has no flag or environment variable, making
this the third template needing a named volume nested inside the bind mount — and the
valuable thing to prime is `ELM_HOME`, not `elm-stuff`, because compiled package artefacts
live there.

`make build` compiles to `--output=/dev/null`: a library module has no `main`, `elm make`
refuses to emit without one, and that is the compiler's own documented answer rather than a
dodge. `elm-format` needs `--yes` to rewrite without prompting, and `elm-test` exits 1 on an
empty `tests/`.

**`elm make` deadlocks on arm64 now and then, and the cure costs more than the disease.**
One CI leg died with GHC's `thread blocked indefinitely in an MVar operation` at
`Reporting.hs:445` *after* printing "Success! Compiled 1 module.", then passed on a rerun
with nothing changed. A probe on the same native `ubuntu-24.04-arm` runner compiled the
module 153 times across 200 invocations without a single failure, so the rate is low — and
the obvious fix, `--report=json`, trades the reporting path for JSON error output on every
failure a human would rather read. Apple Silicon runs the same binary: if `make build`
hangs, run it again.

**`gleam format` sorts a module's imports, and that quietly makes the obvious test entry
module name-dependent.** With `import {{PROJECT_SNAKE}}` beside `import gleeunit`, exactly
one ordering is correct — and which one depends on how the project name sorts against
"gleeunit". `gleam_kata_lab` lints clean; `zebra_lab` goes red. The worst kind of bug: it
would have passed for roughly half of all project names. The entry module now imports
`gleeunit` alone and the project's own test lives in a sibling file with a single import, so
no file has two imports to order. Verified by bootstrapping with a name that sorts after
`gleeunit`.

`gleam test` insists the module `<name>_test` exists and offers no flag to point elsewhere,
which is why that file is the template's own and the kitchen sink is a sibling.

The `-erlang-slim` image **ships no CA bundle**, so every dependency-resolving command dies
with "Dependency resolution failed / builder error" — an error that names TLS nowhere. One
`apt-get install ca-certificates` fixes it.

Discovery turned out easier than feared: `gleeunit.main()` globs `test/**/*.{erl,gleam}` at
run time, so nothing names the suite. Note the convention is narrower than the mechanism —
the `_test` suffix must be on the **function** name; the filename suffix is convention only.
And gleam has no flag or environment variable for `build/`, making this the second template
after `clojure` to need a named volume nested inside the bind mount.

**`haskell` installs its linters from Debian, and the reason is worth recording because the
template first did the opposite.** hlint and ormolu were compiled from Hackage, which meant
building `ghc-lib-parser` — a complete GHC frontend — **twice**, at two versions that cannot
share any work: hlint pins the 9.12 series while the image's GHC is 9.14. A genuinely cold
build measured about forty-five minutes, and CI never once finished the leg. One
`apt-get install hlint ormolu` replaced all of it; the same build now measures **99s**.

The claim that sent it down the slow path was that neither tool publishes an
`aarch64-linux` release binary. That is true of **GitHub releases** and the wrong conclusion
to draw from it: both are in **Debian's archive**, which builds for every architecture the
base image does. `containers.md` already prescribes exactly this for `c` and `cpp`.

The cost is version currency. apt here carries **hlint 3.3.6 and ormolu 0.3.1.0**, both
around two years old, *because* this is [the one row with no trixie
image](#notes-on-individual-rows) — trixie offers 3.6.1 and 0.7.2.0. Both were verified
against this template's own sources before the swap: `hlint` reports no hints and every
`.hs` file passes `ormolu --mode check`, including files formatted by 0.9.0.0, so the
committed formatting needed no change. The newer GitHub binaries work too, but are amd64
only, and picking by architecture would mean the formatter differing between a Mac and CI —
`make fmt` on one could leave `make lint` red on the other. Identical tooling everywhere is
worth more here than two minor versions.

What remains in the image build is the `hspec`/QuickCheck compile, which is primed
deliberately and cannot come from apt: Debian's Haskell libraries are built against its own
GHC, not the image's. That keeps the first `make test` at about eight seconds.

**`-Wno-missing-home-modules` is suppressed on the test-suite stanza only**, and that is a
deliberate trade the contract forces. `hspec-discover` generates a main that imports the
Spec modules, and cabal's warning asks for them in `other-modules` — but listing them names
the kitchen sink, and `cabal test` then *fails* the moment it is deleted. The warning is
cabal bookkeeping rather than a correctness check: GHC still compiles and type-checks every
module, and the library and executable keep plain `-Wall` with zero warnings. Suppressing it
is what keeps the suite deletable, which is the rule that matters.

Two tool facts worth knowing: **`ormolu` takes files, never directories** (it dies with
"inappropriate type (is a directory)"), so an image-baked `ormolu-tree` wrapper globs for it
— a literal Makefile file list would have named the sink. And `ormolu --mode check` exits
**100** on a difference, not 1.

Haskell also cannot put a snake_case token in a *module* filename, since a module's filename
must equal its capitalised module name. The escape is `main-is`, which cabal treats as a
path: `src/{{PROJECT_SNAKE}}.hs` is the executable's entry point, with the library module
beside it.

**Debian's `luarocks` package drags in lua5.1, and that lua owns `/usr/bin/lua`.** Installing
`lua5.4` and `liblua5.4-dev` alongside it does not win the fight: `lua -v` silently reports
5.1 until `lua5.4` is re-symlinked onto `PATH`. Silently running the wrong interpreter is the
worst possible failure for a template whose point is a pinned toolchain, so the Dockerfile
pins the versioned packages and re-points `lua` explicitly.

`luarocks` 3.8.0 also has an undocumented interaction: `--tree` together with
`--lua-version` breaks `LUA_INCDIR` autodetection outright ("Failed finding Lua header
files"), though either flag alone is fine. `--lua-dir=/usr` alongside `--tree` is what works.

`luacheck` moved from `mpeterv/luacheck` to `lunarmodules/luacheck`, and the abandoned
repository's releases list looks exactly like "no recent releases" rather than a moved
project — the same trap `ktlint`'s org move set, by a different mechanism. It needs only
`std = "lua54"` in `.luacheckrc`, because it already applies its busted std to `*_spec.lua`
by itself.

`busted` exits non-zero on a wholly empty `spec/`, so `lua` joins `python`, `swift` and
`dart` as a row whose runner does not strictly succeed when it finds none. Deleting the
kitchen sink alone is safe, since the module spec survives.

The gotcha is worth noting for what it is *not*: a first version asserted `#values == 3`
after punching a hole in a table, and the Lua manual says any border is legal there — so the
assertion could have failed on a future point release with nobody touching the code. The
test now asserts what the spec guarantees, that `ipairs` stops at the first `nil`, and keeps
the unreliability of `#` in its name.

**`ocaml` is the one template pinned by digest, because `ocaml/opam` publishes no patch tag
and its minor tags are not all releases.** `debian-13-ocaml-5.6` carries
`ocaml-variants.5.6.0+trunk` — `ocaml --version` reports `5.6.0+dev2-2026-10-02` — so the
sweep's "newest by semantic sort" picked a development compiler. The template pins
`debian-13-ocaml-5.5` (OCaml 5.5.2) plus a sha256, which is a stronger pin than any other
row has rather than a weaker one. **Check `ocaml --version` inside the image before
believing a minor tag is a release**; the only other variants published are `-flambda` and
`-no-flat-float-array`, so there is no beta-suffixed tag to compare against.

It also **avoided zig's concession**, which was not obvious: dune's `(test (name …))` stanza
names its modules, so deleting the suite would break the `dune` file. Instead `test/dune`
names a generated `main`, and an image-baked `alcotest-discover` writes `main.ml` from a
`(glob_files *_test.ml)` rule — so `main.ml` *depends on* each test module, giving
deterministic link order rather than relying on registration side effects. Verified at
sixteen tests, one, and none.

Three image facts cost real time. `/home/opam` is mode `0700`, so at any uid but 1000 the
base image's `opam exec --` entrypoint fails with `[ERROR] Opam has not been initialised` —
advice that points nowhere near the cause; `chmod 0755 /home/opam` is the whole fix. The
bundled opam repository is a *frozen local clone*, so installing a pinned version fails with
"has no version" until `opam repository set-url default https://opam.ocaml.org` repoints it.
And `dune fmt` exits non-zero whenever it actually reformats something, so `make fmt` runs an
image-baked wrapper that re-checks afterwards and lets the check decide the exit code.

There is no `@lint` alias in dune — this row used to claim one. `@fmt` is the non-mutating
check.

**`clojure` was expected to need a second zig-style concession and does not.** `clojure.test`
has no discovering CLI, and both obvious routes break a rule: a third-party runner in
`deps.edn` fights stdlib-first, and `-M -e` naming namespaces fights "`test` must not name
the kitchen sink". The way out is a forty-line `clojure.test` harness baked into the
**image** at `/opt/clojure-test-runner` and reached from the `:test` alias with
`:local/root`. It reads each file's own `(ns …)` form under `test/` — reading it rather than
deriving it, because munging a hyphen to an underscore does not reverse — so `deps.edn`
carries `:paths`, one alias and nothing else, `make test` is a bare `clojure -M:test`, and
nothing anywhere names the suite. The same shape as `go`'s `gofmt-check` and `nim`'s
wrapper scripts.

Two environment facts cost a debugging cycle each, and both contradict what the obvious
variable name suggests. **`CLJ_CACHE` does not move `.cpcache`**: the CLI writes
`./.cpcache` whenever a project `deps.edn` exists and the directory is writable, and
`CLJ_CACHE` is only the fallback for when it cannot — there is no flag. And **`HOME=/cache`
does not move `~/.m2`**, because the JVM takes `user.home` from the passwd entry when one
exists, so priming as root filled `/root/.m2` while the mapped uid looked in `/cache` and
re-downloaded everything. `:mvn/local-repo` in an image-level `deps.edn` makes build time
and run time agree.

`{{PROJECT_SLUG}}` and `{{PROJECT_SNAKE}}` turn out to be exactly the namespace and path
forms of one name, so `(ns {{PROJECT_SLUG}}.greeter)` at `src/{{PROJECT_SNAKE}}/greeter.clj`
always corresponds — the free escape the missing sixth token would otherwise have needed.

**`swipl -g make -t halt` is not a lint, and this row used to claim it was.** `make/0`
reloads files that are *already* loaded, and a fresh process has loaded none, so the goal is
a no-op that exits 0 over a file with a syntax error in it. The gate that actually works is
`swipl --on-error=status --on-warning=status -g check -t halt <files>`, and the two halves
split unexpectedly: loading alone catches a syntax error and a singleton variable, while an
undefined predicate loads silently and needs `check/0` on top, which reports it as a
*warning* rather than an error. All four faults — including one planted inside the kitchen
sink — were verified red, and green again on restore.

Both `test` and `lint` go through wrapper scripts baked into the image, because `swipl`
takes files rather than directories and plunit has no directory discovery. That is the same
sanctioned pattern `nim` and `go` use. `run_tests/0` with nothing loaded prints
"No tests to run" and exits 0, so deleting the whole `tests/` directory still leaves
`make test` green — better than `pytest`'s exit 5.

`SWIPL_PACK_PATH` is also load-bearing: `swipl pack install` fails at any non-root uid with
"Cannot find a place to create a package directory", because it considers only the pack
directories on `file_search_path(pack, …)` — the one root-owned path in the image — and does
**not** fall back to `$HOME`.

**`csharp` inherits every .NET answer from `fsharp` and differs in exactly one place.**
`dotnet format` *does* support C#, so it stays as both `lint` and `fmt` — verified red on a
real whitespace violation (exit 2), where the same tool silently exits 0 on F#. The
`global.json` MTP opt-in, `HOME=/cache`, `Directory.Build.props`, the redirected test
results and `--ignore-exit-code 8` are all identical, deliberately: the two .NET rows
disagreeing on how `make test` treats an empty suite would be worse than either choice.

It also needs no compile-order glob. The SDK's default `**/*.cs` include picks up `src/` and
`test/` with no `<Compile>` list at all, where F# has to glob explicitly because it compiles
in listed order.

**`fsharp` cannot use `dotnet format`, so it uses Fantomas.** `dotnet format` supports C#
and Visual Basic only: handed an F# project it prints "Format currently supports only C#
and Visual Basic projects" and exits **0**, so a `lint` built on it can never go red —
verified against deliberately mangled source. Fantomas is installed as a pinned
`--tool-path` tool in the image, reads `.editorconfig`, and exits 99 on a violation.
`csharp` keeps `dotnet format`, so the two .NET rows differ here on purpose.

Two more .NET facts this template had to solve. **xUnit v3 runs on Microsoft.Testing
Platform, and the .NET 10 SDK refuses the old VSTest path for it** — `dotnet test` fails
before running anything unless a `global.json` carries
`"test": { "runner": "Microsoft.Testing.Platform" }`. The .NET 9 spellings
(`TestingPlatformDotnetTestSupport`, a `dotnet.config` runner section) do not work on
10.0.404. And `make test` carries `--ignore-exit-code 8` because MTP exits 8 for "ran zero
tests": without it, deleting the suite would turn `make test` red. It is scoped to that one
code — a failing test still exits 2 — which was verified, so it is not a `|| true`.

The SDK image is **Ubuntu 24.04, not Debian**, and Microsoft publishes no Debian default tag
for the 10.0 SDK, so this pair is the one exception to the Debian-variant rule. Its `$HOME`
problem is also distinctive: the image has a passwd entry for uid 1000 *only*, so at any
other uid NuGet's migration runner dies creating a named mutex. `ENV HOME=/cache` fixes it;
`DOTNET_CLI_HOME` alone does not, because NuGet reads `HOME`.

**`swift` is the one template whose lint cannot gate on the tool's own exit code.**
`swift format lint` reports every finding as a *warning* and exits 0 regardless, so
`make lint` needs `--strict` to be able to go red at all. swift-format also indents by
**2 spaces** by default, not the 4 most Swift style guides use, and the template follows the
tool rather than shipping a `.swift-format`.

Its kitchen sink is **swift-testing**, not XCTest, and that is the one place a template
moved off the row's chosen runner. `kitchen-sink.md` asks for flat tests with no grouping
block and names that are complete sentences; XCTest can express neither, because discovery
*is* subclassing `XCTestCase` and names are method identifiers. swift-testing's
`@Test("a sentence")` on a free function gives both, ships in the toolchain, and needs no
Makefile change — `swift test` runs both libraries in one invocation and reports
`15 tests in 0 suites`. The surviving `src/` test deliberately stays on XCTest: `swift test`
exits 2 on a test target with nothing in it, so keeping one XCTest case is what makes the
kitchen sink safe to delete.

`ENV HOME=/cache/home` is load-bearing rather than tidiness: SwiftPM has no environment
variable for its cache, config or security paths and derives all three from `$HOME`, so at
`/` even manifest compilation fails. SwiftPM also guards `--scratch-path` with a lock file
in `/tmp` named after it, which the priming layer leaves root-owned — the Dockerfile clears
`/tmp` in its last layer, the same trap `nim` records.

Swift's backtick escape does work for a reserved-word module name, verified both ways with a
module named `static`, so this is one of the templates where a keyword project name builds.

**`java` reaches the contract's flat `src/` layout with a package-private class.** Java
enforces that a *public* class matches its filename, and there is no CamelCase token to
build `{{PROJECT_SNAKE}}.java` a matching class name from. A non-public class carries no
such rule, so `src/{{PROJECT_SNAKE}}.java` legally holds `class Greeter`. That also turned
out to need no Javadoc suppressions: Google's checks already exempt members of a non-public
top-level class.

Two of Google's shipped checks are removed, each with a comment where it stood:
`OuterTypeFilename`, which has no visibility exception and so rejects the arrangement above,
and `PackageDeclaration`, which demands a package tree the flat `src/` has no room for.
Everything else in `google_checks.xml` is intact and was proven to catch a real violation.

Test names use `@DisplayName` with a short camelCase method name, because Java identifiers
cannot contain spaces — the standard JUnit idiom for exactly this gap, and the nearest thing
to the complete sentences [kitchen-sink.md](kitchen-sink.md) asks for. The strings section
substitutes `String#formatted` for interpolation: JEP 430's string templates were withdrawn
and Java 25 has no interpolation syntax at all.

**`kotlin` redirects three project-root writes, not one.** `build/` needs
`layout.buildDirectory`, `.gradle/` needs `--project-cache-dir` on *every* invocation, and
`.kotlin/` needs the `kotlin.project.persistent.dir` Gradle property. Dropping that last
one alone puts `.kotlin/` straight back into the bind mount, and only the
`git status --porcelain` check catches it.

Its uid fix is a **chmod, not a write**, which is why `chmod -R 777` is not enough: Gradle's
single-use daemon calls `chmod 700` on `$GRADLE_USER_HOME/daemon/<version>`, and chmod needs
*ownership*. A root-primed directory therefore fails for every other uid however permissive
its mode. The image deletes that one directory after priming and lets the first run recreate
it — the same shape as `dart`, by a different mechanism. Note also that `--no-daemon` does
not prevent a daemon process: Gradle forks a single-use one anyway, which is the only reason
that chmod is reached.

**ktlint's `standard:filename` rule is irreconcilable with the contract** and is the one
rule disabled. It rejects any snake_case `.kt` filename outright — with a single class it
demands the class's name, with none it demands PascalCase — so `src/{{PROJECT_SNAKE}}.kt`
cannot pass, and there is no CamelCase token to name the file after its class.

**Both Gradle templates must name Maven Central in `pluginManagement`**, and this was
learned the hard way — twice, from intermittent CI failures that passed on the next run and
never reproduced locally. Plugin-classpath resolution consults only
`plugins.gradle.org/m2` by default; `mavenCentral()` in `build.gradle` governs
*dependencies*, not plugins. The portal proxies Central, so resolution works until the
proxy doesn't: `kotlin` failed on `kotlin-gradle-plugins-bom`, which the portal does not
always serve, and `java` failed on a Spotless transitive whose proxied GET errored.
Naming both repositories gives Gradle a second, direct route. Verify any change here with
`docker compose build --no-cache`, because a warm layer cache hides it completely.

ktlint has also **moved from `pinterest/ktlint` to `ktlint/ktlint`**; the old releases
endpoint answers 301 with an empty body, which looks exactly like "no releases" unless you
follow the redirect.

**`erlang` installs rebar3 itself and primes the dialyzer PLT.** The slim image ships no
rebar3, so it comes from a pinned release escript with a sha256 — and unlike `zig`'s
tarball there is no per-architecture variant, because an escript is portable.

The PLT is the reason this template needs priming at all. Building it takes about thirty
seconds and `make lint` would pay that on every run; built in a `RUN` layer, a wiped volume
reseeds from the image and `make lint` measures 5.4s instead. `REBAR_BASE_DIR` and
`REBAR_CACHE_DIR` put both the base and project PLTs inside `/cache` with no `dialyzer`
stanza in `rebar.config` at all.

`erlfmt` is wired as `{project_plugins, [{erlfmt, VSN}]}` and the task is `rebar3 fmt`
— not `{plugins, …}`, and there is no `rebar3 erlfmt` command. Using `project_plugins` makes
rebar3 write a `rebar.lock` even with zero dependencies; its content is the static `[].`,
so it ships pre-generated like `rust`'s `Cargo.lock`.

`rebar3 eunit` exits 0 given sixteen tests, one, or none — better discovery behaviour than
`pytest`, and on par with `javascript`'s bare `node --test`.

**`swift` must use the full image, not `-slim`.** Swift's `-slim` tags are runtime-only:
in `swift:6.4.2-trixie-slim` there is no `swift` binary on `PATH` at all, only the runtime
libraries for deploying an already-built binary. The Debian-variant rule that picks `-slim`
everywhere else is wrong here.

`swift format` is confirmed present as a toolchain subcommand in 6.4.2, reporting the same
version as the compiler, and `/usr/bin/swift-format` exists alongside it — so no separate
install is needed. Both `XCTest.swiftmodule` and `Testing.swiftmodule` ship, so
swift-testing is available even though the row specifies XCTest.

**`nim` is the first template where `lint` and `fmt` check genuinely different things.**
`nim check` is a type check and is blind to whitespace; `nimpretty` has no check mode at
all. So `make lint` cannot gate formatting, which the generated README says plainly rather
than hiding.

Neither tool accepts a directory — `nim check src` tries to open `src.nim` — so both run
through wrapper scripts baked into the image that glob the `.nim` files, the same trick
`go` uses for `gofmt`'s useless exit code. A first attempt named two files explicitly in
the Makefile instead, which left the kitchen sink neither type-checked nor formatted: the
file the template exists to make someone read was the one file no tool touched.

Two traps the image works around: `nim`/`nimble` write a scratch directory under `/tmp`
regardless of `--nimcache` and `NIMBLE_DIR`, so priming the cache as root leaves it
root-owned and every other uid then fails to compile — the Dockerfile clears `/tmp` in its
last layer. And `nim`'s cache only skips the C-compiler step, not its own frontend, so the
warm-run speedup is real but modest: measured in isolation, 22 `gcc` invocations cold
against 0 warm.

**`nim` pins the 2.2 line, not the newest.** `nim:2.4.0` publishes `amd64` and `i386`
only, so buildkit answers `no match for platform in manifest` on arm64 and nothing arm64
can be produced from it. That is not a property of nim. The official image is
`debian:bookworm-slim` plus a downloaded nightlies tarball, and `official-images`
generates each tag's architecture list from the assets that nightly happened to carry —
the `2026-10-28-version-2-4` build `2.4.0` pins has `linux_x64`, `linux_x32` and
`macosx_arm64`, and no `linux_arm64`. Every 2.2 and 2.0 image has all four architectures,
and `nim:2.2.14` was rebuilt the same day as `2.4.0`.

A release line behind buys arm64, and nothing here pays for it: `nimble test`, `nim check`,
`nimpretty` and `std/unittest` all long predate 2.4, and `nimpretty` 2.2.14 reformats none
of the shipped files. Two files carry the pin — the `Dockerfile` and the generated
`.nimble`'s `requires`, which nimble enforces, so a bump of one without the other fails on
the compiler it was handed. Returning to the 2.4 line is that tag bump: the `version-2-4`
branch has published `linux_arm64` in every nightly since, and nim-lang.org offers a
released `nim-2.4.2-linux_arm64.tar.xz`, so an official 2.4.x image should generate an
arm64 entry of its own.

**`kotlin` and `java` pin the newest *LTS* JDK, not the newest JDK.** `gradle:9.9.1`
publishes jdk17, jdk21, jdk25 and jdk27 variants. 21 and 25 are LTS; 27 is an interim
release, and the Kotlin Gradle plugin, Checkstyle and Spotless all lag interim JDKs. A
template exists to hand someone a toolchain that works, so "newest" here means newest LTS.

**`php` resolves the `vendor/` collision by never installing into the project.** The
contract reserves `vendor/` for third-party source a template ships deliberately; Composer
installs dependencies to the same path. So PHPUnit, PHPStan and php-cs-fixer install inside
the image at `/tools`, against a `composer.json` written in the Dockerfile, with
`COMPOSER_VENDOR_DIR=/tools/vendor` and `COMPOSER_HOME=/cache/composer`. The project's own
`composer.json` declares identity and nothing else, so no `vendor/` and no `composer.lock`
is ever written into the scaffold. Composer itself arrives via
`COPY --from=composer:<version>`, never a piped installer.

Two image details that cost real time to find: `php:8.6-cli-trixie` ships neither
`mbstring` (PHPUnit needs it) nor `unzip`, and `apt-get purge --auto-remove libonig-dev`
after building `mbstring` also removes `libonig5`, which `mbstring.so` links against —
breaking PHP at every later invocation. Do not purge that build dependency.

php-cs-fixer also refuses to run on PHP 8.6 without
`Config::setUnsupportedPhpVersionAllowed(true)`; it supports syntax only up to 8.5.

**`elixir` redirects its lock file with `mix.exs` itself.** `Mix.Project`'s `:lockfile`
key takes an absolute path, so `mix.lock`, `deps/` and `_build/` all move into `/cache`
and credo stays an ordinary dependency — a third answer to the lock-file problem, cleaner
than `ruby`'s manifest-free route or `rust`'s pre-generated lock. The manifest-free route
was tried and **does not work here**: `mix archive.install hex credo` exits 0 and installs
only credo's own ebin, omitting `bunt`, `jason` and `file_system`, so `mix credo` then dies
with `UndefinedFunctionError`.

`MIX_HOME` also has to move off `~/.mix`. The slim image has no passwd entry for the
calling uid, so `$HOME` resolves to `/` and the default archive location is unreadable at
run time — the first `make test` fails with "Could not find an SCM for dependency".

Elixir 1.20's set-theoretic type checker is new enough to be worth knowing about: it warns
at compile time on literal cross-type comparisons, which is exactly what the `==` versus
`===` gotcha demonstrates. The suite threads values through variables so the lesson still
lands without the compiler pre-empting it.

**`dart` is the one template where the container's uid is load-bearing.** `dart pub`
refreshes `.dart_tool/package_config.json` by setting its mtime, and Linux requires
*ownership* for that, not merely write permission — so a `chmod 777` is not enough. The
Dockerfile seeds `.dart_tool` as an empty world-writable directory on a named volume, which
lets the first run create that file as whatever uid Compose maps in. An earlier attempt
chowned it to 1000 and passed locally while failing for every other uid, including CI's.
Verified at uid 1000, 1001 and 1234.

`pubspec.lock` is gitignored rather than shipped — the one place the preferred lock-file
remedy does not apply, because a host-written lock arrives through a Windows bind mount
owned by root and `pub`'s mtime touch then fails the same way. It carries no project name,
so there is nothing to tokenise, and gitignoring it is Dart's own convention for a library.
`dart analyze` also needs `--fatal-infos`: warnings are fatal by default, infos are not.

**`typescript` pins TypeScript 6, not 7, and that is the ecosystem's limit rather than
ours.** `typescript-eslint` 8.73.0 declares `"typescript": ">=4.8.4 <6.1.0"` and hard
*throws* on 7.x at require time rather than warning. Since the template ships eslint, 6.0.3
is the newest version the whole toolchain can actually use. A first attempt reached 7.0.2
by aliasing `typescript` to a `@typescript/typescript6` compat shim for eslint and
`@typescript/native` for the real compiler; it worked, and was rejected — two conceptual
compiler entries and a README paragraph telling people not to simplify them is too much
config surface for a kata starter to carry for a version number.

Two Node 26 constraints are worth knowing, both verified by running rather than inferred:
its TypeScript support is **strip-only**, so a constructor parameter property throws
`ERR_UNSUPPORTED_TYPESCRIPT_SYNTAX` at runtime even though `tsc` accepts it; and relative
imports between `.ts` files need the literal `.ts` extension, which needs
`allowImportingTsExtensions` to type-check and `rewriteRelativeImportExtensions` to emit.

**`ruby` ships no `Gemfile`.** `bundle install` cannot run in `ruby:4.0.10-slim-trixie`:
bundler reinstalls the `json` and `racc` the image already carries, builds both native
extensions from source, and the slim image has no `cc` and no `make` — verified. Pinning
those gems to the image's own versions does not help, because bundler reinstalls default
gems rather than reusing them. `gem install --no-document rubocop:<version>` in the
Dockerfile reuses them, and installs into the image's `GEM_HOME`, so no `Gemfile.lock` can
ever dirty the generated project. It is the same reasoning that leaves `zig` without a
`build.zig.zon`.

`make test` is `rake test` against a `Rake::TestTask` glob, because minitest has no
discovering CLI and naming the suite is what the contract forbids. Ruby 4.0 bundles
minitest 6, whose assertions are unchanged from 5.x.

**`go` needs a wrapper to make `make lint` fail.** `gofmt -l` exits `0` whether or not it
names a file, so a recipe gating on its exit code can never go red. `go vet` does exit
non-zero, but it does not check formatting. The Dockerfile bakes a two-line `gofmt-check`
script into the image and the Makefile calls that.

The reason it lives in the image rather than the project: the no-quotes, no-`sh -c` rule
constrains the *Makefile*, because those recipes run through `cmd.exe` on Windows. It says
nothing about what runs inside the container, which has a real shell. A first attempt put
a small Go program in the generated project instead, which worked but shipped a `tools/`
directory to every kata for a toolchain deficiency.

**`python` pins ruff's rule selection, and has to.** With no `[tool.ruff.lint] select`,
ruff 0.17.6 enables roughly eight hundred rules rather than the `E4,E7,E9,F` baseline the
documentation implies — including `flake8-bugbear`, which fails the template's own
`src/`. The `pyproject.toml` pins the baseline explicitly; removing it reopens this.

`pytest` also exits `5` on an empty suite rather than `0`, so `python` is the one template
where the runner does not strictly "succeed when it finds none". Deleting the kitchen sink
alone is safe — `src/` still holds a test, which the contract requires — but deleting that
too makes `make test` fail. `javascript`'s bare `node --test` has no such edge.

**`javascript` is pure JavaScript.** No TypeScript, no bundler, no transpiler, no
`package.json` dependencies beyond the linter. `node:test` and `node:assert` are in the
runtime. This is the template that proves the baseline can be genuinely small.

Its tests are flat `test()` calls from `node:test`, not `describe`/`it`. `test` is the
module's own idiom, and flatness is what keeps the names readable on their own — see
[kitchen-sink.md](kitchen-sink.md#test-conventions).

Its `make test` is a bare `node --test` with no path, and that is not an oversight.
`node --test <path>` treats the argument as a module to load and exits `1` with
`MODULE_NOT_FOUND` even when the suite is green. Bare, node walks the tree itself and
exits `0` when it finds nothing — which is what makes the suite safe to delete.

**`typescript` is a separate template, not a flag.** It differs in layout, config and
the lint task, and the two-template split is cheaper than conditionals in one.

**`zig` was wave 0 on purpose**, as the template expected to break the contract — and it
did, in three places.

It has **no test discovery**. A test file runs only if something names it as a module
root, so `build.zig` names `src/kitchen_sink.zig` rather than finding it. It names it
behind a probe, which is what keeps the suite deletable: `dependOnDirectoryMetadata` on
`src/` makes the configure phase re-run when a file there appears or disappears, and
without it the cached graph outlives the deleted file and names a source that is gone.
The one cost is in the image: `.dockerignore` keeps `src/` out of the build context, and
the configure phase fails outright on a missing directory, so the prime creates an empty
one.

It ships **no `build.zig.zon`**. The manifest is optional for a project with no
dependencies, and that is the only reason this works: `.fingerprint` is checked against
the package name, so a hardcoded one in a template would reject every project not named
after the template. Omitting the file sidesteps a problem that literal token substitution
cannot solve.

Its **image primes its own cache, and the prime only survives on the machine that built
the image.** `zig build` compiles `build.zig` into a runner before it builds anything,
which is about seventy seconds of `std.Build` against a cold cache. The Dockerfile copies
the project's own `build.zig` and runs `zig build --help`, which compiles that runner and
nothing else. Built locally — clone mode, CI, `--no-pull` — the first `make test` then
measures 3.0s against 72.1s.

From the **published** image it measures 73.2s, which is to say it buys nothing. The
runner has to run on the host, so it is compiled for the native target, and the target is
part of the cache key: adding `-mcpu baseline` to an otherwise identical compile produces
a second cache manifest. The 28 MB runner GitHub's hardware compiled is therefore
unreachable from a `znver5` laptop, and sits unread in the volume. `zig build` has no flag
that pins the runner's target — checked against 0.17.1's `--help` — so this is structural
rather than a thing to fix.

The prime is kept because clone mode and this repo's own CI do hit it, and because the
version it replaced was worse: a throwaway `zig init && zig build test` cached a runner
compiled from a *different* `build.zig`, which no project asks for on any machine. A
differently *named* project does hit a locally built prime — a name costs 1.4s of
test-binary recompilation, not seventy seconds of `std.Build`. See
[containers.md](containers.md#caching-is-mandatory).

**`erlang` and `prolog` are no longer platform-restricted.** Under mise they were
linux+macos only because the toolchains were unreliable elsewhere. In a Linux container
the host stops mattering, which is most of the argument for this design.

**`prolog` has no formatter.** SWI-Prolog ships nothing worth wiring in. `make lint`
runs a real load check (see below) and `make fmt` is a no-op that says so
— the contract requires all six targets to exist, not all six to do work.

**`haskell` is the only row not on trixie.** Upstream publishes no `slim-trixie` variant,
so it pins `9.14.1-slim-bookworm`. Re-check whenever this row is touched: a trixie slim tag
would be worth taking for consistency, and it now buys something concrete as well — the
linters come from apt, and trixie carries hlint 3.6.1 and ormolu 0.7.2.0 against bookworm's
3.3.6 and 0.3.1.0. This is the only row where the Debian generation sets a tool version
rather than just the base layer.

**`kotlin` uses the `gradle` image** rather than a Kotlin one, because no official
Kotlin image exists and Gradle is how the project builds anyway.

**`java` and `csharp` cost almost nothing.** Each reuses an image already pinned for
another template — `gradle:9.9.1-jdk25` from `kotlin`, `mcr.microsoft.com/dotnet/sdk:10.0.404`
from `fsharp`. They exist because mainstream class-based OO was otherwise unrepresented:
Kotlin and F# are both reactions *against* the dialect most people actually write at
work, and a kata set that cannot show you plain Java has a hole in it.

**`c` and `cpp` are separate templates on one image.** Combining them was considered and
rejected. C has no sum types, no generics, no namespaces, no RAII and no exceptions, so
their types and errors sections have almost nothing in common. A single
template would have to hedge every section, which is precisely what the
"idiomatic, not lowest-common-denominator" rule in
[kitchen-sink.md](kitchen-sink.md) forbids.

They are also the only two templates that vendor a third-party test framework — see
[template-contract.md](template-contract.md#vendored-code).

**`fortran` is the third template on the gcc image, and it needed no new one.** The
official `gcc` image is built `--enable-languages=c,c++,fortran,go`, so `gfortran` was
already inside the tag `c` and `cpp` pin. What was missing is everything around the
compiler: fpm for dependencies and test discovery, and a formatter.

`fpm test` builds every file under `test/` that contains a `program` into its own
executable and runs all of them, so nothing names the kitchen sink and deleting it leaves
the other test discovered. That is better than the concession `zig` needed, and it comes
free rather than through a wrapper.

Two things the row does not show. fpm resolves dependencies by cloning them into `build/`
*inside the project*, so `compose.yaml` mounts a named volume there — the same arrangement
`gleam`, `dart`, `elm` and `clojure` already need — and the image leaves `test-drive`
resolved at that path for the volume to seed from, verified by running the suite green
with the network switched off. And `fprettify` is the whole of `lint`: Fortran has no
linter in wide use, `fprettify --diff` prints a diff but still exits `0`, so a wrapper
compares its output against nothing. Compilation errors come from `make build`.

`fprettify` is published to PyPI only, which is the one ugly part of the image: python3
ships in the gcc image but pip does not, so the Dockerfile installs `python3-pip` to
install one formatter. The alternative was `prolog`'s documented no-op, and a real
formatter was worth more than the layer it costs.

**`pascal` has a real xUnit, and it was never a third-party one.** fpcunit ships in the
Free Component Library, which Debian packages as `fp-units-fcl`, so the test framework
costs one more apt package rather than a vendored tree like `c` and `cpp` need. Tests are
`published` methods on a `TTestCase`, discovered through RTTI, which is as declaration-free
as `go test`.

What is not free is the runner. fpcunit finds the tests inside a unit but the *program*
has to name every unit in a `uses` clause, which would name the kitchen sink and break
when somebody deletes it. The image generates that clause from `tests/`, which is `c`'s
`unity-discover` pattern rather than `zig`'s concession.

**There is no formatter, and `ptop` is the reason rather than the absence of one.** It
ships with Free Pascal, so it was tried: it capitalises every keyword to `Unit`, `Begin`
and `End`, moves `end;` to column zero inside a procedure, and leaves trailing whitespace
after `var`. The first is fixable by deleting `capital` from its generated config; the
other two are not, and the last fights `.editorconfig`. `make fmt` is therefore `prolog`'s
documented no-op, and `make lint` compiles every unit with `-Sew` instead — warnings as
errors, which is a real check rather than a stand-in for one.

That choice paid for itself immediately. `-Sew` caught an uninitialised managed result in
the kitchen sink's own `Apply`, and the compiler separately refused `[LetterA, LetterB,
LetterA]` outright: a duplicate in a *set constructor* is an error, while adding a member
that is already there by union is fine. Both are in the suite now because the toolchain
objected first.

One trap worth stating because it has no error message worth reading: a unit name is an
identifier in the same namespace as everything else, so a unit called `greet` hides a
function called `Greet` and the compiler complains about a missing `.` instead. The test
units are `*_test.pas` for that reason, not for symmetry with `ruby`.

**`perl` came off the deferred list, and the reason it was on it no longer holds.** It was
declined for "text-processing heritage, small audience", which is a judgement about
popularity rather than about whether the template would be good. It is one of the best in
the set: `Test::More` and `prove` are both core, so the runner needs nothing installed,
`prove -Isrc -r t` discovers tests with no declaration anywhere, and the language has a
real linter *and* a real formatter — which is more than most rows here manage.

`5.45.5-slim-trixie` exists and is not the one to pin. Perl marks development releases
with an odd minor version, so `5.44.0` is the current stable and the newest tag is a devel
build.

**Two things cost more than they look.** Perl::Critic's dependency tree reaches `Clone` and
`Params::Util`, both XS, so building it needs a compiler that `-slim` does not carry; it is
built in a stage that installs `gcc` and the modules are copied out. Copying `site_perl`
alone is not enough, because `Pod::Parser` is an old dual-life distribution that installs
into the *core* library path — the first build failed on a missing `Pod::PlainText` for
exactly that reason, so the copy takes `/usr/local/lib/perl5` whole.

And `perltidy -b` edits in place by setting the output file's permissions and mtime, which
a bind mount from a Windows host refuses, and perltidy treats the refusal as a failure. The
formatter writes through a temporary file instead. `--assert-tidy` is a real check mode, so
`lint` needs no diffing wrapper, but it does need `-se`: without it perltidy reports an
assertion failure by writing a `.ERR` file into the project rather than to stderr.

The kitchen sink's own first run found one more: `reduce`'s `&@` prototype swallows what
follows it, so `is( reduce { $a * $b } @values, 24 )` passes one argument to `is` and dies
at compile time. The fold is assigned first, which is what the act phase of the test wanted
anyway.

**`cobol` is the first template with no test framework, and the reason is licensing rather
than absence.** Two exist. `gcblunit` is the real one, and it is GPL-2 with copybooks that
compile *into* the program under test, so a project scaffolded from an MIT template would
come out GPL. `cobol-check`, under the Open Mainframe Project, is Apache-2 and would be
fine — but its repository is archived, its last release was 0.1.0 in March 2021, and it is
Java, so it would put a JVM in a COBOL image. Nothing else pushed since 2024 has more than
two stars.

So a test is a program, which is how COBOL has always tested COBOL: it exercises the code,
reports each case as a line of [TAP](https://testanything.org), and sets `RETURN-CODE` to
the failure count. The idiom and the protocol agree rather than competing — the exit status
is right when the suite is run by hand, and the TAP gives a readable line per case when it
is run by `make test`. The runner in the image fails on a `not ok`, on a plan that does not
match the number of results, and on a non-zero exit, and succeeds when it finds no tests at
all. All three were tested by breaking them.

**Free format, declared in the source.** Fixed format confines code to columns 8 through 72
and is still GnuCOBOL's default, which cannot hold a test name long enough to be a sentence
without continuation lines. Every file therefore opens with `>>SOURCE FORMAT IS FREE` — at
column 8, because the compiler reads that first line in the format it has not yet been told
to change. At column 1 it works too, by detection, but then says so on every compile.

**`-Wall` earned its place twice while the kitchen sink was being written.** It rejected
`FUNCTION LENGTH(WS-BUILT) = 32` as constant-folded — true at compile time, so asserting
nothing — and it warned about `MOVE 123 TO WS-TWO-DIGITS`, which disproved the gotcha the
case was making. The honest version is now in the file: a *literal* too large for its
target draws a warning, and a *field* too large for its target does not. `COMPUTE` without
`ON SIZE ERROR` discards the high-order digits in silence, which is what the errors case
and the gotcha case now show from either side.

There is no formatter, so `make lint` is `cobc -fsyntax-only -Wall` and `make fmt` is
`prolog`'s documented no-op.

**`basic` is Bywater, and the choice was authenticity over tooling.** `yabasic` is also in
trixie, is maintained, and has a `--check` flag that would have made `make lint` a real
check. Bywater has none of that and was picked anyway: line numbers, `GOSUB`, `DEF FN`, an
interpreter that is also its own shell. FreeBASIC was the third option and was ruled out
rather than declined — no Debian package, and its official binaries are x86 only, which
would have reintroduced the single-architecture row that `nim` had just stopped being.

**It is the first template where `make lint` proves nothing.** bwbasic has no check mode and
does not parse a line until the line runs, so a mistake in a branch nothing took is
invisible until something takes it. `make fmt` and `make build` are no-ops too — three of
the six targets. The generated `README.md` says so plainly rather than letting a green
check imply something it cannot.

**The plan line is the whole safety net.** A program that fails an assertion exits 0; so
does one that stops half way through with `ERROR in line`. Nothing in the exit status
distinguishes any of it, which is why TAP earns its place here more than anywhere else: the
runner compares the `1..15` against the number of results, so a dead program is caught by
the results it never printed. That was demonstrated by accident — a duplicated line number
sent the kitchen sink off the end of itself at case nine, and the plan check is what said
so.

**Line numbers are the module system.** There is no `import`; `MERGE` loads another file's
lines into the running program, so what makes it work is a convention about which ranges
belong to whom: the test below 8000, its reporting subroutines at 8000, and `src/` from 9000
up. A subroutine takes its arguments in shared variables because `GOSUB` has none.

Two limits found by writing the suite, both now stated in it: a `DEF FN` call will not nest
inside another `DEF FN` call, and `UCASE$` does not exist. And the gotcha slot writes itself
— nothing is ever declared, so a mistyped name is not an error but a new variable worth
zero.

**`lolcode` is a joke with a working toolchain behind it.** `lci` is alive — 820 stars, last
pushed September 2026 — and builds from its release tarball with CMake in about ten seconds.
It is GPL-3, which is why it is installed into the image and never vendored into the
template: the same relationship every Debian-based image already has with its contents. The
runtime stage needs nothing but libc and libm, so the compiler that builds it stays in the
stage above. `g++` is in that stage's package list for one reason: `project(lci)` asks cmake
for a C++ compiler the project never uses.

**It has no import, so the image provides one.** `CAN HAS` takes a library name rather than
a path, and two files on one `lci` command line are two separate programs — the second
cannot see the first's functions. The only way a test can reach `src/` is to be the same
program as it, so `tap-run` strips each file's `HAI` and `KTHXBYE`, splices the bodies with
the modules first, and feeds the result to `lci` through standard input. This is `basic`'s
`MERGE` problem with no `MERGE` to solve it, and the consequence is one namespace across the
whole project.

Unlike `basic`, there is a real crash signal: `lci` exits non-zero on a runtime error, and
it parses the entire program before running any of it, so a syntax error anywhere fails the
suite immediately. The plan line still earns its place, because nothing distinguishes a
failed assertion from a passed one.

**The language is poorer than the sections assume, and saying so is the content.** There is
no array — `SRS` turns a number into a slot name on a `BUKKIT`, which is as close as it
gets, and nothing reports how many slots there are. There is no set. `SMOOSH` is the whole
of the string library: no length, no substring, no split. `O RLY?` and `WTF?` are
statements, so the only way a branch yields a value is `FOUND YR` inside a function. A
function can call itself and cannot be handed anywhere.

The gotcha wrote itself once the suite was running: `SUM OF 1 AN "3"` is 4, because
arithmetic casts a `YARN` without being asked, and `BOTH SAEM "3" AN 3` is `FAIL`, because
comparison does not. Two things that were *not* usable: an uninitialised variable is a fatal
"cannot implicitly cast nil" rather than a quiet zero, and `WILE` cannot stand alone — it
has to follow `UPPIN` or `NERFIN`.

**`intercal` was the one expected to be impossible, and the assertion is what made it
work.** C-INTERCAL is in Debian stable for arm64 as well as amd64. The problem was never
the toolchain: it is that nothing in the language can print the name of a test. `READ OUT`
writes Roman numerals and that is the entirety of its output — text means one character
code at a time, which is why Hello World in INTERCAL is a column of magic numbers.

So an assertion is an **array subscript**. `,9` is dimensioned to exactly one element, and
the comparison `'?.2$.3'~'#0$#65535'` is zero exactly when two values match; syslib's
`(1020)` adds one to it, and indexing `,9` with the result either works or ends the program
with `ICL241I VARIABLES MAY NOT BE STORED IN WEST HYPERSPACE`. A test then reads out the
number of each assertion it survived, and the runner pairs those numerals in order with the
`DON'T ok - ` lines in the source to produce TAP. An assertion that failed has no numeral,
so it and everything after it come back as `not ok` — which is why breaking the eighth of
fifteen reports eight failures rather than one.

`DON'T` is the only comment the language has: the statement is abstained, so it never runs
and never has to parse. That is also what lets the test names live in the file.

**`make lint` is real here, and it is the best lint in the repo.** `ick -c` stops after
translating INTERCAL to C, so it rejects a syntax error — and it rejects a program whose
share of `PLEASE` falls outside one fifth to one third of its statements. Both were checked
by provoking them: `ICL079I PROGRAMMER IS INSUFFICIENTLY POLITE` and `ICL099I PROGRAMMER IS
OVERLY POLITE`. The ratio is over the whole spliced program, so adding a case or a module
can push it out of range, which makes it the only template where a dependency can break the
build by arithmetic.

**`-b` is not optional.** `ick` inserts a chance of `E774 RANDOM COMPILER BUG` into every
compile deliberately. Before that flag was added, one run of the suite died at the sixth of
fifteen assertions and the next five runs were clean — which is exactly the kind of thing
that would have been blamed on the test for a week.

Like `lolcode` it has no import at all, so the runner splices the test and the modules into
one program, test first: execution starts at the first statement and stops at its `GIVE UP`,
which leaves the subroutines after it reachable only by `NEXT`. `src/` therefore holds
labelled subroutines and never a `GIVE UP`, labels are global, and arguments are shared
variables because `NEXT` has no parameters.

**`r` is the one row that has an official image and does not use it.** `r-base:4.6.2`
exists, is multi-architecture, and installs in seconds — but it is built on Debian
*testing*, so the package set moves under a fixed tag. That leaves two bad options and no
good one: pin `r-cran-testthat` and friends and watch the pin rot as testing rotates the
versions out, or leave them unpinned and have the template scaffold differently next month.
Neither is the pin this repo is built on, so `r` sits on the datestamped stable base the
other hand-rolled rows use, which fixes R and all three libraries at once. The cost is
R 4.5.0 rather than 4.6.2 and each library a minor version back, and nothing a kata does
goes near the difference.

It needs no CRAN at all, which was the reason it was declined ("slow CRAN installs"):
`r-cran-testthat`, `r-cran-lintr` and `r-cran-formatr` are all packaged, and the three
install in about twenty seconds together. `styler` is the formatter the R world reaches for
and is *not* packaged, which is why `formatR` is here instead.

**The two tools disagree, and the shipped code is written for both.** `lintr` enforces the
tidyverse's two-space indent and eighty-column lines; `formatR` indents by four unless told
otherwise, and it will join a `switch` onto an eighty-one column line that `lint` then
rejects. `make fmt` therefore passes `indent = 2`, and the kitchen sink's branching case is
written with braces and a short `switch` so that `fmt` changes nothing and `lint` finds
nothing. That conflict is real and was hit, not anticipated: the first version of the case
failed `make lint` immediately after `make fmt` produced it.

The project is not an R package, so nothing would load `src/` for the tests. `make test`
sources every `src/*.R` before handing the directory to `testthat`, which is the job a
package's `NAMESPACE` would otherwise do — and it keeps the suite from naming any file, so
deleting the kitchen sink leaves the rest discovered.

**`ada` has a real xUnit and real static checking, and its one missing piece is the
formatter.** Debian carries GNAT 14.2, gprbuild and AUnit, so nothing is vendored and
nothing is fetched. `gnatpp` is the formatter Ada people use and it is not packaged — it
ships with AdaCore's own distribution — so `make fmt` is `prolog`'s documented no-op and
`.editorconfig` holds the three-space indent GNAT's own style checks expect.

**Every test is one procedure body, which is the whole reason the template works.** A
package would need a spec beside it, so deleting one test would mean deleting two files and
the project would not compile until both were gone. A library-level procedure is a complete
compilation unit on its own: it declares its fixture, its `AUnit.Test_Caller` instance, its
test procedures and its suite in one declarative part, then runs them. Nothing has to be
generated to find them either — `make test` hands each `tests/*.adb` to gprbuild as a main,
one at a time, which is simpler than the harness `pascal` needs.

Two things that only work because of that nesting: `Test_X'Access` matches the
`Test_Method` access type because both are declared at the same level, and
`Test_Runner_With_Status` is instantiated with a local `Suite` function. Put the fixture in
a package and the accessibility rules stop both. `Test_Runner_With_Status` rather than
`Test_Runner` is also what makes a failure reach `make`: the plain runner prints its report
and exits zero.

**`make lint` is the Ada front end, and two switches earn their place.** `-gnatc` checks
without generating code and `-gnatwae` makes every warning an error; between them they
caught a missing case arm and a type error when those were introduced deliberately. `-f` is
there because gprbuild is incremental and `make test` compiles the same sources with
different switches — without it, lint reuses objects that were never checked and passes by
saying nothing, which it did until that was noticed. `-gnatwC` drops "condition is always
True", which a suite full of assertions about static properties trips constantly; that is a
fact about tests rather than a fault in them.

The compiler also rejected two things while the suite was being written, both now in it:
`Natural'Last + 1` will not compile at all, because a static overflow is an error rather
than a warning, and the same expression through an ordinary variable warns instead — so the
errors case reaches `Natural'Last` through `'Value` to put the overflow out of the
compiler's reach. And with more than one `"="` in scope, comparing a `String` expression is
"ambiguous", which is why the strings case names each result before asserting on it.

**`elixir` is the third BEAM template, and not redundant.** `erlang` shows the runtime
raw, `gleam` shows a static type system on top of it, and `elixir` shows the ergonomic
mainstream dialect with the best test tooling of the three — ExUnit is in the stdlib,
`mix test` needs no configuration, and doctests are executable.


**`forth` is the first stack language, and the test framework is twenty lines of the
project's own.** `T{ <code> -> <expected> }T` is what the Forth 2012 test suite reads
like, so it is already familiar, and defining it rather than depending on it is what the
language is for — `docs/template-contract.md`'s bar for a third vendored framework is
deliberately high and Forth clears nothing by meeting it. `T{` remembers the stack depth,
`->` stashes whatever the code left, `}T` compares that against the values after the
arrow and prints one TAP line with the rest of the line as its name.

**The hour this template cost was spent in the return stack and in `ENDCASE`.** `index-of`
first saved its wanted character with `>r` and read it back with `r@` inside a `?do` loop,
which returns a loop control parameter instead — the loop keeps its own state on the same
stack — so the character lives in a variable. And a `CASE` whose default branch yields a
value returns the *selector*: `ENDCASE` compiles a `DROP` to discard the selector that an
`OF` branch would already have consumed, so it eats the default's result instead. The
kitchen sink shows the working form, which pushes a throwaway zero for `ENDCASE` to take,
and the gotchas slot asserts the broken one.

**gforth is not in trixie.** It was dropped before the release and is back in testing, so
the base is `debian:bookworm-20261104-slim` — same datestamp as every other Debian base
here, one generation back. Upstream's 1.0.2 was tried first and builds in about forty
seconds, but `make install` fights libtool over a video4linux wrapper nothing here wants;
0.7.3 has every word the template uses, which was checked against the suite rather than
assumed.

**`make lint` is real and deliberately partial.** Compiling a Forth file is a genuine
check, because an undefined word is a compile-time error and gforth exits 1. It covers
`src/` and the test vocabulary but not the test bodies, because `require`-ing a test
*runs* it — and running them is `make test`'s job.


**`arm32` is the first template that emulates a machine, and the first whose tests are
firmware.** The toolchain targets a chip the host is not, so `make test` assembles each
test together with `src/`, links it into an image with the project's own linker script,
and boots it on QEMU's MPS2 AN385 — a Cortex-M3 development board — one test at a time.
`binutils-arm-none-eabi` rather than `gcc-arm-none-eabi`: pure assembly wants an
assembler and a linker, and the compiler package is an order of magnitude larger for a C
compiler nothing invokes.

**There is no operating system, so the output channel is the emulator itself.** ARM
semihosting is a `bkpt 0xAB` with an operation number in `r0`, and `src/start.S` uses two
of them: `SYS_WRITE0` to print a NUL-terminated string and `SYS_EXIT` to stop the
machine. That is the whole of the template's I/O, and it is what makes TAP possible at
all — the alternative was a UART and a serial console to read it from.

**The timeout is the crash signal, and this is the template that needed one.** Assembly's
characteristic failure is a branch to itself: no fault, no exit status, no output, just a
chip running forever. Every image therefore boots under a ten-second `timeout`, which was
verified by writing the infinite loop on purpose — it reports `exited 124` after ten
seconds rather than hanging the suite. The plan line catches the other half, an image
that faults part way through and prints fewer results than it promised.

**Each test is a whole program because bare metal leaves no alternative.** There is no
loader to link against at run time, so `src/start.S` supplies the vector table — the
initial stack pointer and the reset address, at address zero, where the chip looks — and
a test supplies `main`. One main per test file is `ada`'s shape for a different reason.

**The gotchas slot had no competition.** Every address of Thumb code carries its low bit
set, and that bit is not part of the address: it tells the processor which instruction set
to switch into. So `bx` to an even address faults, and a function pointer built by
arithmetic rather than by asking the assembler for a symbol is not callable. The
assertion is `ldr r0, =double` followed by `ands r0, r0, #1`, which is `1`.

**It is the one template that cannot honour "one page".** `kitchen-sink.md` asks for a
file read top to bottom in under a minute, and fifteen assertions in assembly is 246
lines: four instructions to set up each comparison, a `.asciz` for each name, and the
helper routines the assertions call. The assertions themselves are still fifteen and
still one idea each, and `report_eq` exists precisely so a case is four lines rather than
twenty — but the budget that holds everywhere else is a line count this language cannot
meet, and pretending otherwise would mean cutting assertions to flatter the rule.

**`asp` asserts by being unsatisfiable, and clingo's exit status is the trap.** A test is a
program whose integrity constraints throw away every answer set where its expectations do
not hold, so a pass has no output to parse — only a status. There are two success statuses,
not one: **30** when the search exhausts, which plain facts reach, and **10** when a choice
rule stops it at the first model. A runner that knows only about 10 reports every
plain-facts test as a failure. 20 is a violated constraint and 65 is clingo refusing the
file. The Dockerfile carries the table.

Two of its kitchen-sink sections assert what the language does *instead* of the construct,
which [kitchen-sink.md](kitchen-sink.md) allows and this is the template that needed it: a
string is one opaque term nothing opens, so text has to be spread over a `char(Position,
Letter)` relation first, and nothing returns, so an operator becomes a constant and the
answer becomes one more argument.

**`ats` is the only row here that manages its own memory**, and `make lint` is what proves
it: `patsopt --typecheck` rejects a linear value that is preserved rather than consumed,
naming the variable. Every other functional template in the set is garbage collected, so
that error message is the whole reason this row exists. It is also the hardest fifteen
assertions in the repo to write.

**`objc` wants `libgnustep-base-dev`, not `gnustep-devel`.** Both give you Foundation; the
metapackage also drags in a GUI backend, an interface builder and an IDE, for 240MB that a
template with no window never opens. Two smaller traps: `gnustep-config --objc-flags`
carries `-MMD -MP`, so a syntax-only check leaves `.d` files in the bind mount and dirties
the tree unless every invocation adds `-MF /dev/null`; and gcc's Objective-C front end
still defaults to C89, so a `for` loop declaring its index is an error until `-std=gnu11`
says otherwise. The import-ordering hazard it also found is in
[template-contract.md](template-contract.md#token-substitution), because it applies to any
template whose formatter sorts.

**`d`'s linter is not packaged anywhere**, so `dscanner` and `dfmt` are built from their
release tarballs during the image build — 70 seconds and 36 seconds respectively, which the
layer cache pays once. `dscanner --styleCheck` then shaped the source rather than the
reverse: the kitchen sink's fixtures are `private` because they are the suite's own
business, and `greet` carries a ddoc comment because a public declaration without one is a
finding. No check is disabled and there is no `dscanner.ini`.

**`julia` was declined as "array-scientific, not kata-shaped", and the row that landed
answers that**: nothing in its kitchen sink is a matrix, a broadcast or a `LinearAlgebra`
call. Its gotcha slot goes to array aliasing rather than 1-based indexing, because 1-based
is advertised everywhere and turns up free in the strings and iteration slots, while `alias
= items` binding instead of copying is the one that costs an hour.

The deferred table's `julia:1.11` was two minors stale. `1.13.4` is current, and `1.11.9`
and `1.10.13` both sort *above* it by last-updated — exactly the trap
[containers.md](containers.md#base-images) describes.

**Two traps worth keeping.** `JULIA_DEPOT_PATH=/cache/julia` *replaces* the depot list
rather than prepending to it, discarding the pkgimages Julia ships for its own stdlib: the
trailing separator is load-bearing, and without it `make lint` goes from 2.4s to 55.7s.
And `Pkg.test()` writes `Manifest.toml` into the project, whose `project_hash` varies with
the project name, so it cannot be shipped pre-resolved the way
[containers.md](containers.md#file-ownership) prefers — it is gitignored instead, which is
also the ecosystem's convention for a package rather than an application.

**`groovy` is the second row whose formatter would make the source worse.** Spotless's
`greclipse` step deletes the space before every `>`, so `n > 1` comes back as `n> 1`, in
method bodies, in `expect:` blocks and inside closures; `>=` and `<` survive, so it is
misreading `>` as a closing type-argument bracket. Seven Eclipse formatter options
(`insert_space_before_relational_operator` among them) changed nothing, and the only
Spotless version that runs at all pins Eclipse 4.41. `fmt` therefore says why and exits 0,
and `lint` takes CodeNarc's `formatting` ruleset as well as the correctness ones so that
spacing and indentation are still checked by something.

CodeNarc's `convention` and `naming` rulesets are deliberately absent: enabled, they
report 100 violations on a clean project — `NoDef` on every `def`, `MethodName` on all
sixteen Spock sentence names, `ImplicitReturnStatement` on idiomatic Groovy. A linter
tuned to reject the language it is linting is worse than no linter.

**`flix` is the row where `lint` and `fmt` swap their usual relationship.** `flix format`
rewrites in place and has no check mode, so `lint` cannot check layout; `flix check` is a
non-mutating compile instead, and the compiler is strict enough that an unused local
variable and an unexpected `IO` effect are both errors. The shipped sources are the
formatter's own output, so `make fmt` on a fresh scaffold changes nothing.

Its Datalog constraints are what earn the row, and they sit in the iteration slot: a
self-referential `Path(x, z) :- Path(x, y), Edge(y, z).` is the loop you do not write,
which is the honest place for it in a language with no `while` outside a region.

**`eclipse-temurin` publishes no Debian variant** — only Ubuntu, Alpine, UBI and Windows —
so this row cannot honour the Debian preference, the same way `fsharp` and `csharp` cannot.
There is also nothing to prime into the image: Flix has no incremental build and
recompiles its standard library every invocation, so the only reusable artefact is the
JVM's class-data archive, which the launcher creates in `/cache` on first use rather than
baking 57MB keyed to one exact JDK build into the image.

**`haxe` is on the official image, and `haxe:5.0.0` is not the tag to pin.** The plain
`5.0.0` tag's manifest annotates itself `5.0.0-preview.1-trixie`, so 4.3.7 is the newest
stable — a variant of the trap in [containers.md](containers.md#base-images), where the
version in the tag is not the version in the image. The image is
`buildpack-deps:trixie-scm`, which is why `haxelib git` works without installing anything.

It is here as a statically typed scripting language, so the suite is about the type system
as a programmer uses it — an enum with a parameter and an exhaustive `switch`, an
`abstract` over `Int`, anonymous structure types, `Null<T>` — and there is no
cross-compilation anywhere, which was the reason it had been declined.

**Two Haxe facts cost a draft each.** Enums with arguments cannot be compared with `==` at
all: it is a compile error directing you to `switch` or `Type.enumEq`, so it cannot be the
asserted half of a gotcha, and the shipped assertion uses the half that *does* compile and
silently lies — two anonymous structures with identical fields are not `==`. And
`haxe-formatter` deletes the blank line between two adjacent `//` comment blocks, which is
the obvious layout for a section header above a note, so the suite is shaped to survive its
own formatter rather than configured to stop it.

**`raku` needed no package manager and no pin.** `rakudo-star:2026.09-trixie` is a Docker
Official Image on both architectures and bundles `zef` and `App::Prove6`, which Debian's
`rakudo` does not — so `prove6 -Isrc t` discovers tests with no declaration anywhere, the
same property that makes [`perl`](#notes-on-individual-rows) one of the better rows. There
is no `ARG` in the Dockerfile at all: the `FROM` tag is the pin, and Dependabot moves it.

Rakudo writes a module's precompiled bytecode to `.precomp` **beside the source**, and
there is no flag or environment variable that moves it — so `compose.yaml` mounts a named
volume at `src/.precomp`, the nested-volume pattern `fortran` and `clojure` already use.

**The single-argument rule is the gotcha, and it is the opposite of Perl 5.** `@a` inside
another list stays one element rather than flattening; `|@a` is what asks for flattening.
A draft asserting the Perl 5 behaviour went red on that line, which is the best argument
for the assertion being in the file.

**`commonlisp` takes FiveAM from apt on purpose.** The tarball route would have meant four
pins for a framework and three dependencies, and one of them — `alexandria` — has no
authoritative GitHub home at all, so `pins.yml` would hit its `no upstream found` branch
and the weekly row would be permanently red. Debian's `cl-fiveam 1.4.3` *is* the current
upstream release, so one apt layer buys the whole tree with the datestamped base tag as
its pin. `templates/r` makes the same trade for `r-cran-testthat`.

`clfoundation/sbcl` was considered and rejected: it is a credible multi-arch vendor image,
but it publishes no datestamped tag, so apt packages installed on top of it would move
under a tag that does not.

**`lint` had to be `handler-bind`, not ASDF.** SBCL keeps style warnings out of
`compile-file`'s `warnings-p`, so `asdf:*compile-file-warnings-behaviour* :error` does not
notice an unused binding — measured, not assumed. A `handler-bind` on `warning` sees both
that and a genuine type error, which is what the lint script uses, and `:force` is there
because a fasl already up to date is loaded in silence and would pass anything.

Its generated test system is only rewritten when the bytes change. ASDF treats every
component as stale when its system definition is newer than the fasl, so writing that file
unconditionally recompiled the whole suite on every run — the same rule `templates/c`'s
`unity-discover` follows, for the same reason.

**`koka` cannot fail on its own, which the runner has to make up for.** There is no `exit`
in the standard library and an uncaught exception still leaves the process at status 0 — a
binary that printed `not ok 13` exited 0 when it was checked. So `koka-tap` is what fails
the build: it reads the TAP stream, refuses any `not ok` line, and compares the plan against
the number of results. A template that trusted the program's exit code would have shipped a
suite that could not go red.

Reporting a result is itself an effect in `test/lib/tap.kk`, which is the language's claim
made structural, and `lint` is a type *and effect* check: `koka --library --no-compile`
rejects an effect dropped from a signature. `--library` is not optional there, because
without it Koka synthesises a `main` and fails on a module that has none.

Two further Koka facts. `{{PROJECT_SNAKE}}` is unusable: `_` is a module path separator, so
`import my_koka` resolves to `my/koka` and fails — the template uses the slug throughout.
And `std/data/map`, `set`, `dict` and `array` are 13-to-15-line stubs whose bodies say
`Todo.`, so the collections section asserts a list and a list of pairs, the same shape `c`
has to take.

**`lean` carries its own C toolchain, so the image has none.** The release tarball ships
`clang`, `ld.lld`, `libc++` and `libunwind`; `command -v cc gcc ld` prints nothing in the
built image and `lake test` still compiles and links. `ca-certificates`, `curl` and `git`
are installed for `lake update` alone, the way `zig` keeps certificates for `zig fetch`.
The toolchain is 3.1GB, most of it `Init`/`Std`/`Lean` oleans, and it is not pruned: the
parts that look removable are what the bundled `clang` links against, and a pruned
toolchain fails in somebody else's project rather than here.

**`warningAsError` is what gives `lean`'s lint teeth**, and it was measured: the same unused
binding that fails the build with the option set builds successfully without it. `linter.all`
is deliberately off — it demands a doc string on every public declaration, and `lake lint`
only lints the modules named on its command line, which would mean naming the kitchen sink.

`lake test` discovers tests through a `testDriver` naming a library whose modules come from
a glob, and the glob needs **two** entries plus a root module that exists: `["test", "test.+"]`
works, `["test.*"]` and `["test.+"]` both fail demanding a root, and `roots = []` is ignored.
`lakefile.toml` rather than `lakefile.lean` for a related reason — a Lean config file is
elaborated and compiled to native code before anything else builds, and that artefact cannot
cross machines, which is `zig`'s unwinnable case avoided by not creating it. `lean-toolchain`
is deliberately absent too: without elan it is ignored, so it would be an unchecked second
pin, and `lake update` rewrites it.

**`mercury` is the row with no package and no image anywhere**, so the image bootstraps the
compiler from C: 5m22s on arm64 and 6m03s on amd64, measured on both CI architectures
before the row was written, for a 154MiB install. The build cache turns that into a cost
paid when the Dockerfile changes rather than on every run, which is the only reason it is
affordable — and it is why the bootstrap sits in the final stage. A builder stage would
either leave the 407MB unpacked source in a layer forever or make the expensive layer's
cache key depend on a stage that inline cache does not record.

**`--enable-libgrades=hlc.gc` is half the configuration.** It builds one grade, but amd64
still *defaults* to `asm_fast.gc` and then cannot find the standard library it did not
build; aarch64 already defaults to `hlc.gc`, so the mistake is invisible on one of the two
architectures the matrix runs. `--with-default-grade=hlc.gc` is the other half.

`--errorcheck-only` cannot be used, despite being the obvious flag: it wants `.int` files
nothing has built, and combining it with `--make` is refused outright. The `--make` target
`<module>.check` is the usable spelling — it builds the interfaces, error-checks, and writes
no target code. And `mmc` has no build-directory flag at all, only `./Mercury`; passing
absolute paths makes it write a `Mercury.modules` mapping, so the whole build runs from
`/cache/build` and points back at the bind mount, which is why this template needs no nested
volume where `raku` and `fortran` do.

**The mode system is subtler than "a wrong mode is an error".** A *ground* argument in an
`out` slot is accepted: Mercury compiles an implied mode, a fresh variable plus a unification
afterwards, and what changes is the determinism — the call becomes `semidet`, which is fine
in a semidet context and rejected in a `det` one. Only a *free* argument in an `in` slot is
a mode error. Mercury also reorders conjunctions to satisfy modes, which quietly rescues
several things a reader would expect to fail. The gotchas slot is written around the real
behaviour rather than the expected one.

What `lint` catches here, no other row in this table catches: a determinism declaration that
is tighter than the code (`Declared 'det', inferred 'semidet'`), one that is looser than it
needs to be, and a switch that does not cover every constructor.

**`tcl`'s lint exists because Tcl raises nothing when it parses a broken file.** The
byte-compiler turns a parse error into a `syntax` instruction that fires only if the code
runs, so byte-compiling succeeds on anything and every obvious check — `tclsh -c` does not
exist, `info complete` returns true for `set x {a}b` — reports a broken file as fine. The
instruction is the verdict instead: `::tcl::unsupported::getbytecode` returns the
instruction stream, and the literal pushed before the `syntax` opcode is the message. That
catches an unclosed brace, an unclosed bracket, an unterminated quote, characters after a
close-brace and a malformed `expr`, with no false positives over Tcl's own shipped library.
It cannot catch a misspelled command, because that is a runtime error in Tcl, and a parse
error inside a `proc` body surfaces under `make test` rather than `make lint` — a body is
not compiled until it is first called. The README says so.

Two tcltest defaults would each have made the suite a lie. `runAllTests` prints what failed
and then *returns* whether anything did, exiting for nothing, so `exit [runAllTests]` is
what makes a red assertion red. And `-notfile` defaults to `l.*.test`, which silently skips
every test file whose name begins with `l`: a `tests/lexer.test` would never have run and
nothing would have said so.

**`sql` is the only row whose test framework is the output format.** Each file prints its own
plan and one `iif(cond, 'ok', 'not ok') || ' N - name'` line per assertion, and
`sqlite3 -batch ':memory:' '.read src/schema.sql' '.read tests/x.sql'` runs it — `.read` as
positional arguments, schema first. `sqlite3` exits 0 for a query that returns the string
`not ok` exactly as it does for any other string, so `tap-run` decides the status, the same
shape `forth`, `cobol`, `basic`, `lolcode` and `intercal` use. A runtime error does not stop
`.read` either: the interpreter carries on to the end of the file, which is why the
plan-versus-count check matters as much as the exit code.

sqlfluff is both the lint and the fmt, and it dictates the file's shape rather than the other
way round. `LT05` counts comment lines, so `{{PROJECT_NAME}}` gets a line of its own: a
52-character project name interpolated into a prose line pushed a freshly scaffolded project
over 80 characters and `make lint` went red before its owner had written anything. `LT14`
rejects `ORDER BY` inside an aggregate while allowing it inside `OVER (…)`, and the
`group_concat` assertion needs it, because SQLite's aggregate order is otherwise arbitrary.
And `RAISE` is unusable in a TAP file — it aborts the script, so the errors slot asserts
`INSERT OR IGNORE` plus `changes() = 0`, which is how a test sees a refusal without the
refusal taking the file down.

**`scheme` is a reminder that a framework can report a failure without reporting it to the
shell.** SRFI-64 prints `# of unexpected failures 1` and exits 0; Guile's own
`srfi-64/testing.scm` calls `test-runner-on-final` and nothing else. So the image's helper
installs a `test-runner-factory`, keeps every runner `test-begin` asks for, and exits 1 when
the fail and unexpected-pass counts across all of them are non-zero. It also turns
`test-log-to-file` off, because SRFI-64 writes `<suite>.log` into the working directory,
which in a bind mount is the user's project.

`guild` is in `guile-3.0-dev` rather than `guile-3.0`, so `lint` and `build` call
`compile-file` from `(system base compile)` — in the runtime package — and capture
`current-warning-port` instead. The warnings are named individually rather than by level:
`-W3` is what reports unused variables, and it reports fifteen of them inside SRFI-64's own
expansion of `test-equal`, which would leave the kitchen sink permanently unlintable.

**`racket`'s bytecode cannot be left in the project, and `.gitignore` is not enough.** Racket
CS stamps its machine type into every `.zo` and does not fall back to the source when it
does not match: an amd64 scaffold's `compiled/` run under the arm64 image fails outright with
`fasl-read: incompatible fasl-object machine-type 'ta6le found`. This repo builds both
architectures, so ignoring the directory would park architecture-specific state in somebody's
checkout. `PLTCOMPILEDROOTS=/cache/zo:` moves it into the volume, and **the trailing colon is
load-bearing**: the empty element expands to the default roots, which is where Debian ships
the collections' own bytecode under a per-architecture path. Spelled `/cache/zo:same`, every
run recompiles the whole of rackunit's closure from source, on the second run as well as the
first.

`lint` is `raco expand`, not `raco make`. Both resolve identifiers, but `raco make` caches:
the second run prints `[already up-to-date]` for every file and checks nothing, which is the
failure this repo already records against `gprbuild`. Expansion redoes the work every run and
writes nothing, so it is also the only one of the two that leaves the tree alone, which is
what `lint` is for. `raco make` is `make build`, where caching is the point.

**`scala`'s lint had to turn the build server off to mean anything.** Under scala-cli's
default incremental compile server, `-Werror` still writes class files and the server does
not report that as a failed run: `make test` printed `[error] unused import` and then ran
the suite and exited 0. Incremental compilation also only reports warnings for the files it
recompiled, so a file nobody touched is never re-checked. `lint` therefore passes
`--server=false` — full, deterministic, and the only form that exits non-zero on a warning.
A genuine type error fails `make test` either way. `-Xfatal-warnings`, the flag this was
first written with, is self-defeating on Scala 3.10: it emits a deprecation warning naming
`-Werror` as its replacement, which `-Werror` semantics then promote to an error.

**Three pieces of scala-cli state live outside `$HOME`, and one of them lands in the work
tree.** The GraalVM native launcher reads `user.home` from the passwd entry rather than the
environment, so `ENV HOME=/cache/home` moves nothing: `SCALA_CLI_HOME` is what moves the
incremental state, and `COURSIER_ARCHIVE_CACHE` is a separate setting that `COURSIER_CACHE`
does not cover. Left unset, as a uid with no passwd entry — which is every CI run — coursier
created a directory literally named `?` in the project. The run-time uid having a passwd
entry is what hides this locally, because `eclipse-temurin:…-noble` ships an `ubuntu` user
at 1000. `--workspace /cache/workspace` keeps `.scala-build` out of the tree, and it is
honoured only while that path is writable by the running uid; otherwise scala-cli falls back
to a virtual project silently, and the symptom is a slow run rather than an error.

**`pony` generates its test harness because PonyTest cannot discover anything.** A `TestList`
names every test class, and naming the suite is what the contract forbids. So a helper scans
`tests/*.pony` for `class iso Test… is UnitTest`, writes a `Main` into `/cache/test`, and
compiles that as its own package with `--path /work`, reaching the real suite through
`use "tests"` — a Pony package is a directory, so nothing is copied and compiler errors point
at the file the reader actually has. Test classes are public rather than `_`-prefixed as the
stdlib idiom would have them, because a package-private class is invisible to the harness
package; renaming one to `_TestFoo` is then how you park a test.

The generator drops its `use "tests"` line when it finds no test classes, which is what makes
an emptied suite a green run instead of a build error: `use` on a directory holding no `.pony`
files is a hard ponyc error. And ponyc has no incremental mode — every invocation runs LLVM
over the whole reachable program in about six seconds however little changed — so the helper
keeps the harness binary beside a record of each source's path, mtime and size, and reuses it
when that record matches. `pony-lint` ships in 0.78.2 and is deliberately stripped: it
requires one public type per file with the file named after it, which no kitchen sink can
satisfy, and `--pass verify` is the compiler's own answer rather than a style opinion.

**`qsharp` is the only row whose suite is driven from another language, and the QDK leaves no
alternative.** The released wheel publishes no test CLI, so the Python host lives in the image
as `qsharp-test` and the project ships only `.qs` files. Discovery is the QDK's own:
`qdk/test_utils.py` walks `context.code` and collects every callable whose `__is_test__` is
true, which is what Q#'s `@Test()` attribute sets, so nothing names a test anywhere.

The manifest is why the tests are evaluated rather than compiled. `qdk.Context` raises
without a `qsharp.json` and there is no fallback, and that file's `files` field takes file
paths only — `{"files": ["src", "tests"]}` fails with `File src/demo.qs is not listed in the
files field`. Naming each test file in the manifest is naming the suite, so the helper loads
`src/` as the project and `eval`s each `tests/**/*.qs` into the same context. The cost is in
the generated README: a failing assertion reports `line_0:58:5` rather than a path, though it
does name the test, and errors in `src/` name their real file. The manifest's `lints` field is
inert from Python — those rules are a language-server feature — so `lint` is the type checker.

`ENV QDK_PYTHON_TELEMETRY=none` is not optional. `qdk` starts a daemon thread at import and
registers an `atexit` handler that posts to an Application Insights endpoint; telemetry is on
by default for any non-`dev` version. A template that phoned home on every test run would be
a defect, not a feature.

**`bqn` needs `CC=cc`, and without it the template would be amd64-only.** CBQN defaults to
clang. On amd64 its build driver notices clang is absent and falls back to `cc` with a note;
on arm64 it does not — the bootstrap stage builds, then the driver invokes clang and dies
with `exited with error code 127`. The rest of the flag set is `singeli=0 REPLXX=0` (the
other two git submodules, which a source tarball does not have), `FFI=0` (no libffi in the
image), `nogit=1` as a guard, and `version=` because `nogit=1` leaves nothing to derive a
version from.

The bootstrap problem is the interesting part. CBQN's build system is written in BQN, so
building it needs a BQN, and upstream resolves that with precompiled bytecode pulled as a
submodule. The template downloads that bytecode separately and unpacks it at
`build/bytecodeLocal`, pinned to the commit **CBQN v0.12.0 itself records** rather than to
the newest one, so the bytecode matches the compiler it bootstraps. That commit is the one
pin in the repo `pins.yml` cannot watch, because the bytecode repository publishes no tags.

`lint` is real, which is not obvious for a language with no syntax-only flag: wrapping a
file's source in `{𝕊: … }` and handing it to `•BQN` compiles the body and calls it nowhere,
so an unknown glyph, a malformed train or an undefined identifier is reported without
executing a line. It therefore also checks the suite, which a template whose `lint` runs the
tests cannot do. Two failure routes ship, because neither suffices: `•Exit` carries the fail
count, and `tap-run` compares the plan against the results — an uncaught BQN error ends the
program where it stands, so without the plan check a dead file would look merely shorter.

**`befunge` prints its test names by traversing the grid westwards.** The IP pushes cells in
the order it visits them and `,` pops from the top, so a stringmode run read right-to-left
lands with its leftmost character on top: the name is written in the grid in natural order
and the row is walked east-to-west, with a `0` under it and `>:#,_` printing until that zero.
Each assertion is two rows of 79 columns, and the code row's turning `v` sits in column 78
because the text row pads to column 78 with `<`. Those 29 cells repeat fifteen times, because
Befunge has no functions — and that repetition is the lesson rather than an accident.

Three things about the language that the suite had to be built around. **Every scratch cell
lives at a negative coordinate.** The failure count was first kept at `(0,50)`, and the moment
the file grew past fifty rows `p` overwrote a row of the suite and the program hung on
`Unknown instruction at x=0 y=50`; a negative coordinate is the only address a growing program
can be certain it will never grow over. **`k` repeats n+1 times, not n** — cfunge's
`iterate.c` says so deliberately, because the IP then advances onto the instruction and runs
it once more, which makes it the gotcha slot. And **a never-written cell reads back as 32**, a
space, not zero.

There is no splice here, so the lolcode and intercal precedent does not transfer: those
languages are linear, and concatenating two Befunge grids would mean deciding which
coordinates each occupies, with nothing in the language to store a return address. `i` loads
a file into the playfield at a vector you choose and is the nearest thing to an import, and it
still gives you no way to run the loaded grid and come back. So every file is a program on its
own. For the same reason no `{{TOKEN}}` appears inside a grid row: substitution changes the
row's width, and the turning column only works because the row below is exactly as wide.

**`smalltalk` cost one compiler error, which was not the expectation.** Debian dropped GNU
Smalltalk after bullseye and upstream has released nothing since 2010, so the template builds
3.2.5 from `ftp.gnu.org`. The 2010 C needed `-Wno-error=incompatible-pointer-types` for a
single `iconv` call in gnulib and nothing else — no `-fcommon`, no `-std=gnu89` — and aarch64
behaved identically. What actually stopped the build three times was the host, not the code:
`configure` wants GNU awk and InfoZIP by name, and the tarball is `.tar.xz`.

**`gst` exits 0 after a parse error**, which is the hazard that would have shipped silently.
It reports on stderr, skips the statement and carries on, so a test class that failed to
compile would leave a suite that passed by being empty. The helper therefore treats non-empty
stderr as a failure as well as reading `TestResult hasPassed`, and the two signals never
conflate: a green run writes exactly zero bytes to stderr, and a failing assertion also leaves
it empty. `gst-sunit` could not be used at all — it takes `class.tests` arguments or a package
name, and both name the suite — so the helper builds the suite from `TestCase allSubclasses`
against a snapshot that has no `TestCase` subclasses of its own, which makes whatever `tests/`
filed in the whole suite without anything naming it.

Its `fmt` is the usual no-op, but `build` is real and worth the row: the build output of an
image-oriented language is an image, so `make build` files `src/` into a fresh object memory
and snapshots it to `/cache`, which `gst -I` then starts with the project already loaded.

**Two languages were asked for in wave 6 and are not here.** J was wanted as the array row
and lost it to BQN on the architecture filter: `jsoftware.com` publishes
`j9.5_linux64.tar.gz` and `j9.6_linux64.tar.gz` and **404s on both `_linuxarm64` URLs**, and
every image in this repo is built natively on `ubuntu-24.04-arm` as well as on amd64. The
same filter removed Hack and Debian's `crystal` in wave 5; it is the single most common
reason a language does not get a row.

Unison was dropped for the opposite kind of reason: `ucm` publishes `linux-arm64` and
`linux-x64` binaries, so it would have built. But Unison code does not live in text files —
the codebase is a SQLite database, `.u` scratch files are an input to it, the base library
comes from Unison Share over the network, and the only non-interactive driver is
`ucm transcript`. A template whose source of truth is a binary database fights `git init`
and cannot have a deletable kitchen sink, which is two of this contract's load-bearing
assertions. The language is interesting and the template would have been a lie.

## Deferred

Frameworks are out of the first cut, but the ID namespace reserves them:
`javascript-react`, `python-fastapi`, `rust-axum`, `go-chi`. They are additional
template directories under the same contract, not a new mechanism.

**The language list is empty.** All four that sat here — `julia`, `groovy`, `raku` and
`haxe` — landed in wave 5, and the reasons they had been declined were judgements about
audience rather than about whether the template would be any good. Two of the four
turned out to be among the better rows in the set.

No official image exists for `crystal`, `deno` or `bun`, so those would be hand-rolled
or vendor and are not in the cheap category. `racket` sat in that
list until wave 6 built it on Debian's package, as did `scala` on a Temurin JDK.
