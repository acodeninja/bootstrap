# Roadmap

Twenty-six templates landing as one change is unreviewable. They land in waves, one
commit per template, against a contract fixed in wave 0.

## Wave 0 — the harness

The only wave with real design risk. Everything after it is repetition.

- `bootstrap.sh` and `bootstrap.ps1` implementing [cli.md](cli.md) in full, in both
  clone and remote mode per [install.md](install.md)
- `.github/workflows/ci.yml` per [ci.md](ci.md), with registry auth
- `templates/javascript/` — official `node` image, `node:test`, no runtime dependencies
- `templates/zig/` — hand-rolled image from `debian:trixie-slim`, `std.testing`

Two templates, chosen because they are maximally unalike on both axes that matter:
interpreted versus compiled, and official image versus hand-rolled. If the contract fits
both, it fits. Build `javascript` first, then `zig`, and fix the contract from what `zig`
breaks before writing a third.

**Done when:** both bootstrap green from a cold Docker cache, neither repeats install
work on a second `make test`, and the one-liner works end to end against a public repo.

Making the repository public is a prerequisite for that last one and is not a code
change — see [install.md](install.md). Until it happens, wave 0 can be finished and
verified through clone mode, with the remote path tested by pointing `BOOTSTRAP_REF` at
a local archive.

## Wave 1 — official image, stdlib runner

The cheapest rows, and the ones that confirm the contract generalises.

`go` · `rust` · `python` · `typescript` · `ruby` · `elixir` · `php` · `swift` · `dart`

`php` is the one exception to "stdlib runner" here: PHPUnit arrives via Composer, which
the Dockerfile copies from the official `composer:2` image.

## Wave 2 — official or vendor image, real build tool

The image installs the language; the work is the build configuration underneath — the
JVM, the BEAM, .NET, dune, opam.

`erlang` · `gleam` · `clojure` · `haskell` · `kotlin` · `java` · `fsharp` · `csharp` ·
`ocaml` · `nim` · `prolog`

`java` and `csharp` are near-free: each reuses an image the template beside it already
pinned. Build them immediately after `kotlin` and `fsharp` respectively, while the build
configuration is fresh.

## Wave 3 — hand-rolled images and vendored frameworks

Two kinds of work that share a wave because both mean writing what other templates get
for free. `zig` in wave 0 already proved the hand-rolled path.

`elm` · `lua` — no usable upstream image, so the Dockerfile does the installing.

`c` · `cpp` — official `gcc:16-trixie`, but no stdlib test runner, so each vendors one (Unity
and doctest). First use of the vendoring rule in
[template-contract.md](template-contract.md#vendored-code); get it right here because
it sets the precedent.

## Wave 4 — after the first twenty-six

Languages added because somebody asked for them rather than because the contract needed
proving. One commit each, against the same definition of done below.

`fortran` — official `gcc:16-trixie`, which already carried `gfortran`. The work was fpm
for dependencies and test discovery, and a formatter.

`pascal` — Debian carries the compiler and fpcunit. The work was generating the test
runner, because fpcunit finds tests by RTTI but the program must name their units.

`perl` — official image, `Test::More` and `prove` in core. The work was getting
Perl::Critic built without leaving a compiler in the final image.

`cobol` — Debian carries GnuCOBOL, and no test framework exists to carry. Tests are
programs that report in TAP and set RETURN-CODE; the image consumes the TAP.

`basic` — Bywater BASIC, with line numbers and GOSUB. Tests report TAP because the
interpreter exits 0 whatever happens, including when it dies half way.

`lolcode` — lci built from its release tarball. LOLCODE has no import, so the runner
splices src and the test into one program and feeds it to the interpreter.

`intercal` — C-INTERCAL from Debian. An assertion is an array subscript that ends the
program when it does not match, and the runner turns the Roman numerals into TAP.

`r` — testthat, lintr and formatR, all three as Debian packages. The official r-base image
is built on Debian testing, so this one is not: see its row for why.

`ada` — GNAT, gprbuild and AUnit, all from Debian. Each test is one procedure body, so a
suite is a single file and nothing has to be generated to find it.

`forth` — bookworm, because gforth is not in trixie. No framework and no package
manager to add one through, so the project defines `T{ -> }T` itself in twenty lines
and prints TAP.

`arm32` — binutils and qemu-system-arm, both from Debian. Each test is firmware for a
Cortex-M3, printing TAP over ARM semihosting because there is no operating system to
print through, and booted under a timeout because a spinning chip reports nothing.

## Wave 7 — the mainstream four

Languages any popularity ranking puts near the top, and that the first sixty had
somehow skipped while covering Befunge and Answer Set Programming. One commit each,
against the same definition of done below.

`bash` — bats, ShellCheck and shfmt are all trixie packages, so the image is one
`apt-get install`. The work was the ShellCheck directives: a sourced file has no shebang
to infer a dialect from, and `-x` resolves a followed path against the working directory
rather than the file.

`powershell` — hand-rolled, because Microsoft's own image has no arm64 and its Debian
tags stop at bookworm. The work was the test driver: Pester's `-CI` writes a report into
the bind mount and shells out to `id` to build it, so only its exit-code half was wanted.

`visualbasic` — the .NET SDK image `csharp` already pins, and almost nothing else new.
The work was proving the two risks out: that xUnit v3 runs from a `.vbproj` at all, and
that `dotnet format` really goes red on VB where it silently exits 0 on F#.

`octave` — Debian carries Octave and MISS_HIT comes from PyPI in a venv. The work was
finding the runner: `runtests` is MATLAB's and does not exist, `oruntests` returns
nothing, and `test` is the one that reports counts a driver can exit on.

## Per-template definition of done

1. `make test`, `make lint` and `make fmt` all work from a cold image.
2. No run repeats work an earlier one did. For a compiled language that means a second
   `make test` is materially faster than the first; for an interpreted one with no build
   artefacts, first ≈ second is the pass. See
   [containers.md](containers.md#caching-is-mandatory).
3. The base image tag is pinned, not floating.
4. The `kitchen-sink` file has every section, no more than fifteen assertions, and all
   of them pass, per [kitchen-sink.md](kitchen-sink.md). The errors slot uses the
   language's native failure idiom; the gotcha is genuinely specific to this language.
5. Deleting the kitchen sink — the file at `KITCHEN_SINK`, plus any build-script block
   that names it — leaves a project that still builds.
6. The Makefile calls no host tool but `docker`.
7. Any vendored code is confined to `vendor/`, version-pinned in a header comment,
   excluded from lint and fmt, and its licence named in the generated `README.md`.
8. `grep -rn '{{[A-Z_]\{2,\}}}' <generated>` finds nothing. Not a bare `{{` — that
   also matches the `${{ secrets... }}` every template's CI workflow ships.
9. CI is green.
10. A row in [languages.md](languages.md).
11. One commit: `feat: add <id> template`.

## Commits

Conventional Commits, no scope, lowercase, present tense. One logical change each:

```
docs: add bootstrap design docs
refactor: replace mise with docker and make
feat: add bootstrap.sh
feat: add bootstrap.ps1
feat: add javascript template
ci: bootstrap every template on ubuntu
feat: add zig template
```

Tests ship in the commit that makes them pass — a template and its kitchen sink are one
change.

## Not in scope yet

Framework templates (`javascript-react`, `python-fastapi`), and the four further
languages with verified official images listed under "Deferred" in
[languages.md](languages.md). Both are additions under the existing contract, not
changes to it.

One known gap is also deferred rather than solved: the Windows `make` path is
unverified, because no Windows runner can run a Linux container and so none of them
invokes `make` at all — see [ci.md](ci.md#what-is-not-covered). `bootstrap.ps1`
itself is no longer in that list: the Windows leg of `contract` runs PSScriptAnalyzer
over it, asserts the same exit codes the other legs assert of `bootstrap.sh`, diffs
the two scripts across every template, and `remote` runs the documented scriptblock
one-liner.

A release process is also still to define, and the version-pinning design depends on it:
tagging must bake the tag into both scripts' default ref, or a script served from
`v1.2.0` will fetch `main` templates.
