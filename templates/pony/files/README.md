# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need ponyc. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # type and capability check every source and test file
$ make fmt     # a no-op: Pony has no formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Layout

A Pony package is a directory, and every `.pony` file in it is part of the same
package — there are no module declarations and no import of one file by
another. `src/` is this project's package, `tests/` is another, and `tests/`
reaches `src/` with `use "src"`.

```
src/{{PROJECT_SNAKE}}.pony   the module
src/main.pony          the Main actor make build compiles
tests/{{PROJECT_SNAKE}}_test.pony  a test for the module
tests/kitchen_sink.pony        fifteen worked answers, yours to delete
```

`make build` writes the executable to `/cache/program/{{PROJECT_SLUG}}` inside
the container, so the project directory stays clean. `make shell` and then
`/cache/program/{{PROJECT_SLUG}}` runs it.

## Tests

The runner is [PonyTest](https://stdlib.ponylang.io/pony_test--index/), which
ships with the compiler, so nothing is declared and nothing is downloaded. A
test is a class:

```pony
class iso TestGreeting is UnitTest
  fun name(): String => "a greeting names whoever it is given"

  fun apply(h: TestHelper) =>
    h.assert_eq[String]("Hello, world!", Greeter.greet("world"))
```

PonyTest has no discovery. It takes a `TestList`, and a `TestList` names every
class in it — which would mean this project could not survive the deletion of
its own kitchen sink. So the list is generated instead: `make test` scans
`tests/*.pony` for public `class iso Test… is UnitTest` declarations and writes
a `Main` actor naming the ones it found, into the cache volume rather than into
your tree.

The convention that follows is the only thing to remember: **a test class is
public and its name starts with `Test`.** Rename it to `_TestGreeting`, as
Pony's own standard library does, and the generated list will not include it —
which is also how you park one. Helper types in a test file take the `_` prefix
and are invisible to the generator for the same reason.

Deleting every test is a supported state, not a broken one. The generated
`Main` then has an empty list, `make test` prints `No tests found` and exits 0.

`h.assert_error` takes a partial lambda, which is how a refusal is asserted:

```pony
h.assert_error({()? =>
  _Percentage("140")?
  None
})
```

Tests run concurrently by default — one actor each, up to the number of
scheduler threads. `make test` passes `--sequential` and `--noprog`, so one
test runs at a time and two failures cannot interleave their logs. Drop either
in the `Dockerfile` if you would rather have the parallelism back.

## Reference capabilities, and the hour they cost

Every type in Pony carries one of six capabilities saying what may be done with
that reference and who else may hold one: `iso` (nobody else), `trn` (nobody
else may write), `ref` (mutable, one actor), `val` (immutable, shareable),
`box` (readable, may be either) and `tag` (identity only — not even readable).
This is what lets Pony be data-race free at compile time rather than by
convention.

The thing that costs the hour is that these are not casts. A `ref` is not a
`val` and no annotation makes it one, because somebody else may still hold a
mutable reference to the same object. Building a mutable thing and then
freezing it is spelled `recover`, which is a block the compiler can see nothing
escapes from:

```pony
let frozen: Array[USize] val =
  recover val
    let building = Array[USize]
    building.push(1)
    building
  end
```

The second surprise comes from the standard library returning `iso` where you
expected `ref`. `String.split` hands back an `Array[String] iso^`, so

```pony
let words = "one two".split(" ")
words.values()
```

fails with "receiver type is not a subtype of target type" — `values()` needs a
`ref` receiver and `words` is `iso`. Annotating the destination fixes it,
because the ephemeral `iso^` a constructor returns can be recovered down to
anything:

```pony
let words: Array[String] = "one two".split(" ")
```

`tests/kitchen_sink.pony` has fifteen worked answers to the questions that come
up first. It is meant to be deleted when you start real work.

## There is no formatter

Nothing formats Pony. The release ships `ponyc` and a linker and no format
subcommand, and no third-party formatter exists. `make fmt` says so and exits 0
rather than pretending a check was made.

`make lint` is `ponyc --pass verify`, which runs the front end up to and
including the pass that checks reference capabilities and then stops, writing
no object code. It is not a style check: it is the compiler's own answer, so it
rejects a `val` you tried to mutate, an `iso` you used after consuming it, a
field a constructor left unassigned, and a `match` that does not cover its
union.

```console
$ make lint
Error:
tests/kitchen_sink.pony:14:12: receiver type is not a subtype of target type
    frozen.append("!")
           ^
```

It type-checks every test class whether or not the generated list names it, so
a test you parked still has to compile.

The release does also ship `pony-lint`, a style checker, and this image leaves
it out. Its rules want one public type per file and that file named after it,
which a one-file suite of fifteen test classes cannot satisfy. Delete the
`rm -f` line in the `Dockerfile` and add `pony-lint src tests` to `pony-verify`
if your project can live with the naming rule.

## Adding a dependency

Pony's package manager is [corral](https://github.com/ponylang/corral), which
is not in this image — nothing here reaches the network. The standard library
is large enough that most katas need nothing else: `collections` for maps and
sets, `itertools` for folds and lazy pipelines, `random`, `time`, `files`,
`format`, `json`, `net`, `http`.

To vendor a package, drop its directory in and `use` it by relative path. To
add one through corral, install it in the `Dockerfile` and add `_corral` to the
cache volume so a fetch is not repeated on every run.

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

Five katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) — splitting a string, and recursion
4. [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) — a closed set of states, and a branch that yields a value
5. [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md) — a state machine, and a transition that carries an action

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
