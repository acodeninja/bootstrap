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

Framework templates (`javascript-react`, `python-fastapi`), and the five further
languages with verified official images listed under "Deferred" in
[languages.md](languages.md). Both are additions under the existing contract, not
changes to it.

Two known gaps are also deferred rather than solved: `bootstrap.ps1` has no CI coverage,
and the Windows `make` path is unverified. Both are consequences of the single-platform
matrix — see [ci.md](ci.md#what-is-not-covered). Revisit if Windows users report
breakage, or if the PowerShell script grows past the point where hand-testing it is
honest.

A release process is also still to define, and the version-pinning design depends on it:
tagging must bake the tag into both scripts' default ref, or a script served from
`v1.2.0` will fetch `main` templates.
