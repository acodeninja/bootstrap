# Languages

The 35 targets, their chosen tooling, and when each lands. This is the implementer's
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

## Where lint and fmt prove nothing

Nine of the lint and fmt targets above do nothing, across seven templates, and they
are worth one list rather than seven notes. **`basic` and `lolcode` have no `lint`**:
neither Bywater BASIC nor `lci` has a check mode, a syntax-only flag or a
third-party checker, so `make lint` prints why and exits 0. CI runs it, and for
those two it is theatre.

**Seven have no `fmt`** — `ada`, `basic`, `cobol`, `intercal`, `lolcode`, `pascal`
and `prolog`. `gnatpp` ships only with AdaCore's own distribution; GnuCOBOL, lci
and SWI-Prolog publish no formatter; Free Pascal's `ptop` capitalises keywords and
dedents `end;` to column 0, which is worse than leaving the file alone. Each one's
`.editorconfig` carries the indent the language expects instead.

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
root, and since 0.17 `build.zig` runs in a sandboxed configurer with no `std.fs`, so it
cannot find the files for itself. `build.zig` names `src/kitchen_sink.zig` explicitly and
deleting the suite means deleting that block too — the one template so far where the
kitchen sink is not self-contained. See [kitchen-sink.md](kitchen-sink.md#it-is-meant-to-be-deleted).

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

## Deferred

Frameworks are out of the first cut, but the ID namespace reserves them:
`javascript-react`, `python-fastapi`, `rust-axum`, `go-chi`. They are additional
template directories under the same contract, not a new mechanism.

Four more languages have official images, verified on 2026-11-19, and were declined for
now rather than ruled out — adding one is a mechanical job:

| id       | image              | test runner         | why it was declined                      |
| -------- | ------------------ | ------------------- | ---------------------------------------- |
| `julia`  | `julia:1.11`       | `Test` (stdlib)     | array-scientific, not kata-shaped        |
| `groovy` | `groovy:4.0-jdk21` | `Spock`             | duplicates a JVM already covered twice   |
| `raku`   | `rakudo-star`      | `Test` (core)       | distinct, but very small audience        |
| `haxe`   | `haxe:4.3`         | `utest`             | cross-compilation is the draw, not idiom |

No official image exists for `crystal`, `scala`, `racket`, `deno` or `bun`, so those
would be hand-rolled or vendor and are not in the cheap category.
