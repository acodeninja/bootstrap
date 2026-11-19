# Roadmap

Twenty-six templates landing as one change is unreviewable. They land in waves, one
commit per template, against a contract fixed in wave 0.

## Wave 0 — the harness

The only wave with real design risk. Everything after it is repetition.

- `bootstrap.sh` and `bootstrap.ps1` implementing [cli.md](cli.md) in full, in both
  clone and remote mode per [install.md](install.md)
- `.github/workflows/ci.yml` per [ci.md](ci.md), with registry auth and layer caching
- `templates/javascript/` — official `node` image, `node:test`, no runtime dependencies
- `templates/zig/` — hand-rolled image from `debian:bookworm-slim`, `std.testing`

Two templates, chosen because they are maximally unalike on both axes that matter:
interpreted versus compiled, and official image versus hand-rolled. If the contract fits
both, it fits. Build `javascript` first, then `zig`, and fix the contract from what `zig`
breaks before writing a third.

**Done when:** both bootstrap green from a cold Docker cache, a second `make test` is
materially faster than the first, and the one-liner works end to end against a public
repo.

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

`c` · `cpp` — official `gcc:14`, but no stdlib test runner, so each vendors one (Unity
and doctest). First use of the vendoring rule in
[template-contract.md](template-contract.md#vendored-code); get it right here because
it sets the precedent.

## Per-template definition of done

1. `make test`, `make lint` and `make fmt` all work from a cold image.
2. A second `make test` with no edits is materially faster than the first — if not, the
   cache volumes point at the wrong directory. See
   [containers.md](containers.md#caching-is-mandatory).
3. The base image tag is pinned, not floating.
4. All ten `kitchen-sink/` files are present and every assertion passes, per
   [kitchen-sink.md](kitchen-sink.md). `09_errors` uses the language's native failure
   idiom; `10_gotchas` has at least four entries genuinely specific to this language.
5. `rm -r kitchen-sink KITCHEN-SINK.md` leaves a project that still builds.
6. The Makefile calls no host tool but `docker`.
7. Any vendored code is confined to `vendor/`, version-pinned in a header comment,
   excluded from lint and fmt, and its licence named in the generated `README.md`.
8. `grep -r '{{' <generated>` finds nothing.
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

Framework templates (`javascript-react`, `python-fastapi`), and the six further
languages with verified official images listed under "Deferred" in
[languages.md](languages.md). Both are additions under the existing contract, not
changes to it.

Three known gaps are also deferred rather than solved: `bootstrap.ps1` has no CI
coverage, the Windows `make` path is unverified, and the remote one-liner cannot be
tested until the repo is public. The first two are consequences of the single-platform
matrix — see [ci.md](ci.md#what-is-not-covered). Revisit if Windows users report
breakage, or if the PowerShell script grows past the point where hand-testing it is
honest.

A release process is also still to define, and the version-pinning design depends on it:
tagging must bake the tag into both scripts' default ref, or a script served from
`v1.2.0` will fetch `main` templates.
