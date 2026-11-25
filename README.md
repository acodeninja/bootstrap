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
error handling you need to go and solve a [kata](docs/katas/), plus the one quirk most
likely to cost you an hour — and nothing else. Delete the file when you start real work.

It also ships a **course**: three katas in order, listed in its `README.md`. Hello, World,
which arrives already solved and commented so you can read how a function and a test are
written here; a starter kata; and then one chosen so that the thing this language is *for*
is the thing that solves it — ownership in Rust, effect rows in Koka, reference
capabilities in Pony. Follow-ons after that, and the catalogue behind it all is
[docs/katas](docs/katas/).

## Prerequisites

The same whichever language you pick:

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`
- **git**

You do not install the language. The toolchain lives in a container, so trying Zig costs
you nothing on your machine and leaves nothing behind.

All sixty-four: javascript, typescript, zig, go, rust, python, ruby, elixir, php,
swift, dart, erlang, gleam, clojure, haskell, kotlin, java, fsharp, csharp, ocaml, nim,
prolog, elm, lua, c, cpp, fortran, pascal, perl, cobol, basic, lolcode, intercal, r, ada,
forth, arm32, d, objc, asp, ats, julia, groovy, flix, haxe, raku, commonlisp, koka, lean,
mercury, tcl, sql, scheme, racket, scala, pony, qsharp, bqn, befunge, smalltalk,
bash, powershell, visualbasic, octave.

## Which one to try

Pick the language you already write and the kitchen sink is a cheatsheet for something
you know. The container is the whole argument for picking the opposite: it costs you
nothing on your machine and leaves nothing behind. So find your day job on the left,
and work right.

| You write                             | Start with | Then      | Then you are ready for |
| ------------------------------------- | ---------- | --------- | ---------------------- |
| javascript, typescript                | `gleam`    | `zig`     | `prolog`               |
| python, ruby                          | `elixir`   | `rust`    | `bqn`                  |
| java, csharp, kotlin                  | `clojure`  | `haskell` | `forth`                |
| go                                    | `rust`     | `erlang`  | `prolog`               |
| rust                                  | `erlang`   | `ats`     | `prolog`               |
| c, cpp                                | `ada`      | `haskell` | `commonlisp`           |
| php                                   | `elixir`   | `rust`    | `smalltalk`            |
| swift, dart                           | `elm`      | `zig`     | `prolog`               |
| bash, powershell                      | `raku`     | `clojure` | `prolog`               |
| sql                                   | `prolog`   | `asp`     | `haskell`              |
| r, octave, matlab                     | `julia`    | `bqn`     | `racket`               |
| haskell, ocaml, fsharp, scala, elixir | `koka`     | `lean`    | `mercury`              |

**Start with** is one new idea and everything else familiar — `gleam` compiles to
JavaScript, `clojure` runs on the JVM, `elixir` does the web work you already do.
**Then** is two or three new ideas at once. **Then you are ready for** is the one that
will not let you write your usual solution at all: no mutation, no functions, no loops,
or no control flow you chose. Where that spread comes from is
[docs/languages.md](docs/languages.md#paradigm-coverage), which records the paradigm
cell each of the sixty-four occupies and which cells were thin.

Each one ships the same fifteen-assertion kitchen sink and its own
[course](docs/katas/), so the paradigm is the only unfamiliar thing in the project. The
cost of being wrong is `rm -rf`.

`befunge`, `intercal` and `lolcode` are in no row on purpose. They are not a paradigm
to take back to work — they are what it is like to work with a primitive missing, and
[docs/katas](docs/katas/README.md#what-a-language-cannot-do) says which one for each.
Worth a weekend, not a career.

## Status

All sixty-four templates work. Each one scaffolds from a cold Docker cache, runs its own
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
is for. The Windows leg also diffs the two across all sixty-four templates, so they
cannot drift apart quietly. The design is written up in **[docs/](docs/README.md)**;
[roadmap.md](docs/roadmap.md) has what is left.
