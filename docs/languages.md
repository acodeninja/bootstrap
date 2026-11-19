# Languages

The 26 targets, their chosen tooling, and when each lands. This is the implementer's
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
| `swift`      | `swift:6.4.2-trixie-slim`                      | `XCTest`                     | `swift format lint` / `swift format` | 1    |
| `dart`       | `dart:3.14.1-sdk`                              | `package:test`               | `dart analyze` / `dart format`       | 1    |
| `erlang`     | `erlang:29.1.2.0-slim`                         | `eunit`                      | `dialyzer` / `erlfmt`                | 2    |
| `gleam`      | `ghcr.io/gleam-lang/gleam:v1.19.2-erlang-slim` | `gleeunit`                   | `gleam check` / `gleam format`       | 2    |
| `clojure`    | `clojure:temurin-27-tools-deps-trixie`         | `clojure.test`               | `clj-kondo` / `cljfmt`               | 2    |
| `haskell`    | `haskell:9.14.1-slim-bookworm`                 | `hspec`                      | `hlint` / `ormolu`                   | 2    |
| `kotlin`     | `gradle:9.9.1-jdk27`                           | `kotlin.test`                | `ktlint` / `ktlint -F`               | 2    |
| `java`       | `gradle:9.9.1-jdk27`                           | `JUnit 5`                    | `checkstyle` / `spotless`            | 2    |
| `fsharp`     | `mcr.microsoft.com/dotnet/sdk:10.0.404`        | `xUnit`                      | `dotnet format --verify-no-changes`  | 2    |
| `csharp`     | `mcr.microsoft.com/dotnet/sdk:10.0.404`        | `xUnit`                      | `dotnet format --verify-no-changes`  | 2    |
| `ocaml`      | `ocaml/opam:debian-13-ocaml-5.6`               | `alcotest` via `dune test`   | `dune build @lint` / `ocamlformat`   | 2    |
| `nim`        | `nim:2.4.0`                                    | `unittest`                   | `nim check` / `nimpretty`            | 2    |
| `prolog`     | `swipl:11.0.0`                                 | `plunit`                     | load check / —                       | 2    |
| `elm`        | `node:26.13.1-trixie-slim` + elm               | `elm-test`                   | `elm-format --validate`              | 3    |
| `lua`        | `debian:trixie-20261104-slim` + lua, luarocks  | `busted`                     | `luacheck` / `stylua`                | 3    |
| `c`          | `gcc:16.2.0-trixie` + Unity (vendored)         | `Unity`                      | `clang-format` check / in place      | 3    |
| `cpp`        | `gcc:16.2.0-trixie` + doctest (vendored)       | `doctest`                    | `clang-format` check / in place      | 3    |

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

## Notes on individual rows

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
root, and since 0.17 `build.zig` runs in a sandboxed configurer with no `std.fs`, so it
cannot find the files for itself. `build.zig` names `src/kitchen_sink.zig` explicitly and
deleting the suite means deleting that block too — the one template so far where the
kitchen sink is not self-contained. See [kitchen-sink.md](kitchen-sink.md#it-is-meant-to-be-deleted).

It ships **no `build.zig.zon`**. The manifest is optional for a project with no
dependencies, and that is the only reason this works: `.fingerprint` is checked against
the package name, so a hardcoded one in a template would reject every project not named
after the template. Omitting the file sidesteps a problem that literal token substitution
cannot solve.

Its **image primes its own cache**. `zig build` compiles `build.zig` into a runner before
it builds anything, which is about seventy seconds of `std.Build` against a cold cache.
The Dockerfile runs a throwaway `zig init && zig build test`, and the named volume seeds
from the image — first `make test` measures 2.8s instead of 73s.

**`erlang` and `prolog` are no longer platform-restricted.** Under mise they were
linux+macos only because the toolchains were unreliable elsewhere. In a Linux container
the host stops mattering, which is most of the argument for this design.

**`prolog` has no formatter.** SWI-Prolog ships nothing worth wiring in. `make lint`
runs a load-time check (`swipl -g make -t halt`) and `make fmt` is a no-op that says so
— the contract requires all six targets to exist, not all six to do work.

**`haskell` is the only row not on trixie.** Upstream publishes no `slim-trixie` variant,
so it pins `9.14.1-slim-bookworm`. Re-check when writing the template: if a trixie slim
tag has appeared, take it, because the whole set being one Debian generation is worth more
than the bump.

**`kotlin` uses the `gradle` image** rather than a Kotlin one, because no official
Kotlin image exists and Gradle is how the project builds anyway.

**`java` and `csharp` cost almost nothing.** Each reuses an image already pinned for
another template — `gradle:9.9.1-jdk27` from `kotlin`, `mcr.microsoft.com/dotnet/sdk:10.0.404`
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
