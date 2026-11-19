# Languages

The 26 targets, their chosen tooling, and when each lands. This is the implementer's
worksheet: one row is one template.

Test runners are chosen **stdlib-first**. A built-in runner is one less dependency to
install, one less thing to pin, and one less thing to rot in two years. A third-party
runner appears only where the language has no credible built-in (`hspec`, `busted`,
`alcotest`, `xUnit`, `PHPUnit`, and the two vendored C/C++ frameworks `Unity` and
`doctest`).

Base images were resolved against the registry on 2026-11-19 — see
[containers.md](containers.md#base-images) for the official/vendor/hand-rolled split.

| id           | base image                               | test runner                  | lint / fmt                           | wave |
| ------------ | ---------------------------------------- | ---------------------------- | ------------------------------------ | ---- |
| `javascript` | `node:24-bookworm-slim`                  | `node:test`                  | eslint / prettier                    | 0    |
| `zig`        | `debian:bookworm-slim` + tarball         | `std.testing`                | `zig fmt --check` / `zig fmt`        | 0    |
| `go`         | `golang:1.23-bookworm`                   | `go test`                    | `go vet` / `gofmt`                   | 1    |
| `rust`       | `rust:1.83-slim`                         | `cargo test`                 | `clippy` / `rustfmt`                 | 1    |
| `python`     | `python:3.13-slim`                       | `pytest`                     | `ruff check` / `ruff format`         | 1    |
| `typescript` | `node:24-bookworm-slim`                  | `node:test` + `tsc --noEmit` | eslint / prettier                    | 1    |
| `ruby`       | `ruby:3.3-slim`                          | `minitest`                   | `rubocop` / `rubocop -a`             | 1    |
| `elixir`     | `elixir:1.17-otp-27`                     | `ExUnit`                     | `mix credo` / `mix format`           | 1    |
| `php`        | `php:8.3-cli` + `composer:2`             | `PHPUnit`                    | `phpstan` / `php-cs-fixer`           | 1    |
| `swift`      | `swift:6.0`                              | `XCTest`                     | `swift format lint` / `swift format` | 1    |
| `dart`       | `dart:3.5`                               | `package:test`               | `dart analyze` / `dart format`       | 1    |
| `erlang`     | `erlang:27-slim`                         | `eunit`                      | `dialyzer` / `erlfmt`                | 2    |
| `gleam`      | `ghcr.io/gleam-lang/gleam:v1.9.1-erlang` | `gleeunit`                   | `gleam check` / `gleam format`       | 2    |
| `clojure`    | `clojure:temurin-21-tools-deps`          | `clojure.test`               | `clj-kondo` / `cljfmt`               | 2    |
| `haskell`    | `haskell:9.6.6`                          | `hspec`                      | `hlint` / `ormolu`                   | 2    |
| `kotlin`     | `gradle:8.10-jdk21`                      | `kotlin.test`                | `ktlint` / `ktlint -F`               | 2    |
| `java`       | `gradle:8.10-jdk21`                      | `JUnit 5`                    | `checkstyle` / `spotless`            | 2    |
| `fsharp`     | `mcr.microsoft.com/dotnet/sdk:9.0`       | `xUnit`                      | `dotnet format --verify-no-changes`  | 2    |
| `csharp`     | `mcr.microsoft.com/dotnet/sdk:9.0`       | `xUnit`                      | `dotnet format --verify-no-changes`  | 2    |
| `ocaml`      | `ocaml/opam:debian-12`                   | `alcotest` via `dune test`   | `dune build @lint` / `ocamlformat`   | 2    |
| `nim`        | `nim:2.2.0`                              | `unittest`                   | `nim check` / `nimpretty`            | 2    |
| `prolog`     | `swipl:9.2.9`                            | `plunit`                     | load check / —                       | 2    |
| `elm`        | `node:24-bookworm-slim` + elm            | `elm-test`                   | `elm-format --validate`              | 3    |
| `lua`        | `debian:bookworm-slim` + lua, luarocks   | `busted`                     | `luacheck` / `stylua`                | 3    |
| `c`          | `gcc:14` + Unity (vendored)              | `Unity`                      | `clang-format` check / in place      | 3    |
| `cpp`        | `gcc:14` + doctest (vendored)            | `doctest`                    | `clang-format` check / in place      | 3    |

## Waves

Difficulty is now "does a usable image exist", not "can a version manager pin it". The
grouping follows from that — see [roadmap.md](roadmap.md) for what each wave delivers.

- **Wave 0** proves both image strategies before anything else is written: `javascript`
  on an official image, `zig` hand-rolled from `debian:bookworm-slim`.
- **Wave 1** is official image plus a stdlib test runner — the cheapest rows.
- **Wave 2** is an official or vendor image with a real build tool underneath (the JVM,
  the BEAM, .NET, dune, opam). The images do the installing; the work is the build config.
- **Wave 3** is the remaining hand-rolled images, plus the two templates that vendor a
  test framework because the language has no stdlib one.

## Notes on individual rows

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

**`zig` is wave 0 on purpose.** It is the only hand-rolled image that lands before the
contract is settled, and it is the one that will expose whatever the contract gets wrong
about templates with no base image to inherit from.

**`erlang` and `prolog` are no longer platform-restricted.** Under mise they were
linux+macos only because the toolchains were unreliable elsewhere. In a Linux container
the host stops mattering, which is most of the argument for this design.

**`prolog` has no formatter.** SWI-Prolog ships nothing worth wiring in. `make lint`
runs a load-time check (`swipl -g make -t halt`) and `make fmt` is a no-op that says so
— the contract requires all six targets to exist, not all six to do work.

**`kotlin` uses the `gradle` image** rather than a Kotlin one, because no official
Kotlin image exists and Gradle is how the project builds anyway.

**`java` and `csharp` cost almost nothing.** Each reuses an image already pinned for
another template — `gradle:8.10-jdk21` from `kotlin`, `mcr.microsoft.com/dotnet/sdk:9.0`
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

**`elixir` is the third BEAM template, and not redundant.** `erlang` shows the runtime
raw, `gleam` shows a static type system on top of it, and `elixir` shows the ergonomic
mainstream dialect with the best test tooling of the three — ExUnit is in the stdlib,
`mix test` needs no configuration, and doctests are executable.

## Deferred

Frameworks are out of the first cut, but the ID namespace reserves them:
`javascript-react`, `python-fastapi`, `rust-axum`, `go-chi`. They are additional
template directories under the same contract, not a new mechanism.

Six more languages have official images, verified on 2026-11-19, and were declined for
now rather than ruled out — adding one is a mechanical job:

| id       | image              | test runner         | why it was declined                      |
| -------- | ------------------ | ------------------- | ---------------------------------------- |
| `perl`   | `perl:5.40`        | `Test::More` (core) | text-processing heritage, small audience |
| `julia`  | `julia:1.11`       | `Test` (stdlib)     | array-scientific, not kata-shaped        |
| `r`      | `r-base:4.4.2`     | `testthat`          | as above, plus slow CRAN installs        |
| `groovy` | `groovy:4.0-jdk21` | `Spock`             | duplicates a JVM already covered twice   |
| `raku`   | `rakudo-star`      | `Test` (core)       | distinct, but very small audience        |
| `haxe`   | `haxe:4.3`         | `utest`             | cross-compilation is the draw, not idiom |

No official image exists for `crystal`, `scala`, `racket`, `deno` or `bun`, so those
would be hand-rolled or vendor and are not in the cheap category.
