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

Planned targets, 26 of them: javascript, typescript, zig, go, rust, python, ruby, elixir,
php, swift, dart, erlang, gleam, clojure, haskell, kotlin, java, fsharp, csharp, ocaml,
nim, prolog, elm, lua, c, cpp.

## Status

Thirteen templates of twenty-six — `javascript`, `typescript`, `zig`, `go`, `rust`,
`python`, `ruby`, `dart`, `elixir`, `php`, `nim`, `erlang` and `kotlin` — each green in CI
from a cold registry:

```console
$ git clone git@github.com:acodeninja/bootstrap.git && cd bootstrap
$ ./bootstrap.sh --list
$ ./bootstrap.sh rust ../my-rust
```

`bootstrap.ps1` is not written yet, and the one-liners above 404 until this repo is
public — so remote mode is unimplemented and clone mode is the way in. The design is
written up in **[docs/](docs/README.md)**; [roadmap.md](docs/roadmap.md) has the order
the rest land in.
