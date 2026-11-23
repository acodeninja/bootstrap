# bootstrap

A repo with bootstraps for projects in different languages and frameworks, each comes with a working test.

**macOS and Linux**

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh)" -- zig my-proj
```

**Windows**

```powershell
PS> & ([scriptblock]::Create((irm https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.ps1))) zig my-proj
```

Run either with no arguments to be prompted instead. No clone, nothing installed — see
[docs/install.md](docs/install.md).

One command gets you a project with a pinned toolchain, a formatter, a linter, CI, and
a test suite that runs immediately. That suite is a kitchen sink: one page of fifteen
passing assertions covering the collections, strings, types, iteration, functions and
error handling you need to go and solve a
[kata](https://learn.madetech.com/technology/katas/), plus the one quirk most likely to
cost you an hour — and nothing else. Delete the file when you start real work.

## Prerequisites

The same whichever language you pick:

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`
- **git**

You do not install the language. The toolchain lives in a container, so trying Zig costs
you nothing on your machine and leaves nothing behind.

All fifty: javascript, typescript, zig, go, rust, python, ruby, elixir, php,
swift, dart, erlang, gleam, clojure, haskell, kotlin, java, fsharp, csharp, ocaml, nim,
prolog, elm, lua, c, cpp, fortran, pascal, perl, cobol, basic, lolcode, intercal, r, ada,
forth, arm32, d, objc, asp, ats, julia, groovy, flix, haxe, raku, commonlisp, koka, lean,
mercury.

## Status

All fifty templates work. Each one scaffolds from a cold Docker cache, runs its own
suite green, keeps the generated project's git tree clean, and still builds when you
delete the kitchen sink:

```console
$ git clone git@github.com:acodeninja/bootstrap.git && cd bootstrap
$ ./bootstrap.sh --list
$ ./bootstrap.sh rust ../my-rust
```

Every template is covered by CI, on both architectures, whenever it changes — and weekly
regardless, so upstream breakage surfaces without waiting for an edit. `ocaml` is the
slowest to build at around four and a half minutes; the median is under a minute.

You do not normally pay that. Every template's image is published to
`ghcr.io/acodeninja/bootstrap/<template-id>:main` for `amd64` and `arm64` once its tests
pass, and the bootstrap pulls it instead of building — `ocaml` scaffolds, pulls and runs
its suite green in about fifteen seconds. The registry is public, so nothing needs a
login. The `Dockerfile` is still the version pin and still the authority: no image yet,
no network, or `--no-pull` and it builds locally instead.

Both entry points are complete: `bootstrap.sh` for macOS and Linux, `bootstrap.ps1` for
Windows, each in clone mode and in remote mode, and CI exercises each on the platform it
is for. The Windows leg also diffs the two across all fifty templates, so they
cannot drift apart quietly. The design is written up in **[docs/](docs/README.md)**;
[roadmap.md](docs/roadmap.md) has what is left.
