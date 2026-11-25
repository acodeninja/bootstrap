# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Koka. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # type and effect check every source and test module
$ make fmt     # a no-op: Koka ships no formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

A test is a program that prints [TAP](https://testanything.org): a plan line,
then one `ok` or `not ok` per assertion. Koka has no test framework, so
`test/lib/tap.kk` defines the plan and the result lines in about twenty lines
of Koka, and the image compares what a program planned against what it
reported — which is what tells a failed assertion from a program that stopped
part way through.

Reporting a result is itself an effect:

```koka
pub effect tap
  fun ok( held : bool, name : string ) : ()
```

So a test's own type says it is a test, and `suite` is the only thing that
decides what a result means. `fun` rather than `ctl` is the promise that every
handler resumes exactly once, which is what stops a failing assertion
abandoning the rest of the file.

What fails the build is the runner reading those lines back, not the suite's
own exit status. Koka has no `exit`, and an uncaught exception prints to stderr
and still leaves with status 0 — so `throw` in `suite` is the summary a human
reads, and the `not ok` line is what the build acts on.

`make test` compiles and runs every `test/*.kk`. Nothing names a test file, so
adding one is enough to have it run and deleting one is enough to stop.
`test/lib/tap.kk` sits one directory down precisely so the glob does not take
it for a test of its own.

Binaries and the C that Koka generates land in `/cache/build`, which is a named
volume: the project directory stays clean, and a second `make test` with
nothing edited reuses what the first one built.

A module name is a path, and `_` is one of its separators — `koka` reads
`my_project` as `my/project` and then cannot find it. That is why these files
and the identifiers in them are hyphenated, which is the house style anyway.

## Perceus, and where the memory goes

Koka runs with no garbage collector. Every heap value is reference counted, and
the counts are not a runtime service: the compiler works out where each
reference dies and writes the decrement there. That pass is
[Perceus](https://www.microsoft.com/en-us/research/publication/perceus-garbage-free-reference-counting-with-reuse/),
and it is why a Koka binary has no collector thread, no pause and no heap
walk — just `kklib` and mimalloc underneath it.

Two things follow that are worth knowing before you write much.

**A count of one is a licence to mutate.** When the count says a value is not
shared, the cell is reused in place instead of a copy being allocated, so a
`map` over a list you are done with allocates nothing at all. Two keywords
promise it in the type, and the standard library uses both:

```koka
pub fip fun map( xs : list<a>, ^f : a -> e b ) : e list<b>
pub fbip fun zip( xs : list<a>, ys : list<b> ) : list<(a,b)>
```

`fip` means that if the owned arguments are unique at run time the function
neither allocates nor frees and runs in constant stack space; `fbip` is the
weaker one, which may free and may recurse but still never allocates. Both are
checked, so writing one is how you get told at compile time about an allocation
you did not mean to make. `fip(1)` allows a stated number of constructors,
which is what in-place tree insertion needs.

**A cycle is a leak.** Reference counting cannot free one, and nothing comes
along later to notice. Koka's `type` declarations are inductive, so most data
simply cannot form a cycle — but a `ref` can point back at something that
reaches it, and that memory is gone for the life of the process.

## Effects are part of every type

A signature carries what a function may *do* as well as what it takes and
answers:

```koka
pub fun greet( name : string ) : string          // total: it cannot even print
fun digit-of( c : char ) : exn int               // may throw
fun countdown( n : int ) : div int               // may not terminate
```

The row is checked, not advisory, and this is what `make lint` is:

```console
$ make lint
src/{{PROJECT_SLUG}}.kk(3,39): type error: effects do not match
  context        : pub fun greet( name : string ) : string
                     println("greeting " ++ name)
                     "Hello, " ++ name ++ "!"
  inferred effect: <console/console|_e>
  expected effect: total
```

Adding a `println` to a function you wrote as pure is a compile error, not a
warning. The same check catches an operation called with no handler above it,
an effect left out of a handler's own signature, and a `match` missing a
constructor. It runs `koka --library --no-compile`, which stops before the C
backend and writes nothing outside the cache.

The surprise this costs people an hour is the quiet direction: you change a
body, Koka infers one more effect than before, and the error lands on the
*signature* you did not touch. `test/kitchen-sink.kk` has fifteen worked
answers to the questions that come up first.

## There is no formatter

Nothing formats Koka. The release ships one binary, `koka`, with no format
subcommand and no flag, and there is no third-party formatter to install —
[koka-lang/koka#521](https://github.com/koka-lang/koka/issues/521) has been
open since 2024 and the implementation it mentions has never landed.
`make fmt` says so and exits 0 rather than pretending a check was made.

`make lint` is therefore the type and effect check described above, which is a
real check and a thorough one. `.editorconfig` is what keeps the layout honest.

## Adding a dependency

Koka has no package manager for Koka code. What ships with the compiler is
`std/core` plus `std/num`, `std/text`, `std/time`, `std/os` and `std/async`.
Note that `std/data/map`, `std/data/set` and `std/data/dict` are declared and
empty in 3.2.9 — a keyed collection is a list of pairs until they are not.

A third-party module is vendored: drop the `.kk` files in and add their
directory to the `-i` list in the `Dockerfile`, where the compile commands
live.

C is the escape hatch, and the intended one. `extern` gives a Koka signature to
something already compiled, `extern import c file "x.c"` pulls in C alongside a
module, and `--cclib` links a system library. Install the library's Debian
package in the `Dockerfile`, add the flag to the same file, and run
`docker compose build`. Koka can also fetch C libraries through vcpkg, which is
why its installer asks for `cmake` and `ninja-build`; this image leaves all
three out, so nothing here reaches the network to compile.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`.github/workflows/actions.lock` pins the actions that workflow uses to exact
commits, so a tag that moves upstream cannot change what runs. It is
machine-generated: after you add a workflow or edit a `uses:` line, install the
tool once with `gh extension install github/gh-actions-lock` and run
`gh actions-lock` to rebuild it. Turning on Dependabot for `github-actions`
keeps the workflow and the lockfile in step without that.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Course

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [The signature that changes](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/effect-rows.md) — effect rows, and a handler that subtracts one

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
