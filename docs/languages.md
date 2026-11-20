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
| `swift`      | `swift:6.4.2-trixie`                           | `swift-testing` + `XCTest`   | `swift format lint --strict` / `swift format` | 1    |
| `dart`       | `dart:3.14.1-sdk`                              | `package:test`               | `dart analyze` / `dart format`       | 1    |
| `erlang`     | `erlang:29.1.2.0-slim`                         | `eunit`                      | `dialyzer` / `erlfmt`                | 2    |
| `gleam`      | `ghcr.io/gleam-lang/gleam:v1.19.2-erlang-slim` | `gleeunit`                   | `gleam check` / `gleam format`       | 2    |
| `clojure`    | `clojure:temurin-27-tools-deps-trixie`         | `clojure.test`               | `clj-kondo` / `cljfmt`               | 2    |
| `haskell`    | `haskell:9.14.1-slim-bookworm`                 | `hspec`                      | `hlint` / `ormolu`                   | 2    |
| `kotlin`     | `gradle:9.9.1-jdk25`                           | `kotlin.test`                | `ktlint` / `ktlint -F`               | 2    |
| `java`       | `gradle:9.9.1-jdk25`                           | `JUnit 5`                    | `checkstyle` / `spotless`            | 2    |
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
