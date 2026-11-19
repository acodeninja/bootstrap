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
a test suite that runs immediately. That suite is a kitchen sink: ten short themed files
of passing assertions covering the language's variables, operators, equality, control
flow, collections, strings, functions, types, errors and quirks — everything you need to
go and solve a [kata](https://learn.madetech.com/technology/katas/), and nothing you
don't. Delete it in one move when you start real work.

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

Design stage — the scripts and templates don't exist yet, and the commands above will
404 until this repo is public. The design is written up in **[docs/](docs/README.md)**;
start there.
