# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Flix or a JDK. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # type and effect check without writing anything
$ make fmt     # reformat in place
$ make build   # compile to class files in the build volume
$ make shell   # open a shell in the container
```

## Tests

A test is a `def` annotated `@Test` whose effect row includes `Assert`:

```flix
@Test
def two_and_two_make_four(): Unit \ Assert =
    Assert.assertEq(expected = 4, 2 + 2)
```

`flix test` finds every `@Test` in the project — `test/` is convention, not
configuration — so nothing names a file and nothing registers a suite. Add a
file, it runs; delete one, it stops.

`Assert` is an effect rather than a library of throwing functions, which is why
it appears in the signature. `Assert.assertEq`, `assertTrue`, `assertOk`,
`assertSome` and `assertMemberOf` cover most of what a test needs.

## Datalog constraints

Flix carries a logic sublanguage inside the functional one. A constraint set is
an ordinary value written between `#{` and `}`, a collection of tuples becomes a
relation with `inject`, and `query` runs the rules to a fixpoint:

```flix
let edges = inject List#{(1, 2), (2, 3)} into Edge/2;
let rules = #{
    Path(x, y) :- Edge(x, y).
    Path(x, z) :- Path(x, y), Edge(y, z).
};
query edges, rules select y from Path(1, y)
```

`Path` refers to itself, so the solver keeps deriving until nothing new appears.
The kitchen sink uses it for the iteration section, because this is the loop you
do not write.

## The effect system is the lint

`flix check` is the whole linter, and it is strict enough not to need another
one: an unused local variable is a *Redundancy Error*, not a warning, and a
function with no effect annotation may not perform effects. A `def` that calls
`println` without `\ IO` in its signature fails to compile.

That is the one thing to expect to get wrong on arrival. The escape hatches are
an underscore prefix for a variable you meant to discard, and an honest effect
row on the signature.

## Formatting

`flix format` rewrites every `.flix` file under `src/` and `test/` in place, and
it is what `make fmt` runs. There is no check mode, so `make lint` checks types
and effects rather than layout; the shipped files are already formatted, and
`.editorconfig` records the four-space indent the formatter produces.

## Adding a dependency

`flix install flix/museum-clerk` adds a Flix package and `flix outdated` reports
what has moved. Resolved packages land in `lib/`, which is a named volume rather
than part of your tree, and `packages.lock` records what was chosen.

The first resolution needs the network. Nothing else here does: `make test`
works offline.

## The toolchain version lives in two places

`ARG FLIX_VERSION` in the `Dockerfile` is the pin, and `flix` in `flix.toml` is
the version this project asks for. Flix refuses a manifest that asks for more
than the jar provides, so move them together.

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
