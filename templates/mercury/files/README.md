# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Mercury. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # type, mode and determinism check every module
$ make fmt     # a no-op: Mercury has no formatter
$ make build   # compile src into a library in /cache
$ make shell   # open a shell in the container
```

## The first build takes about five minutes

Nobody publishes a Mercury binary, and Debian dropped the package before
trixie, so the image bootstraps the compiler from the source distribution. It
takes four to six minutes depending on the machine — the install phase is
longer than the compile — and the result is about 155 MB of compiler and
standard library under `/opt/mercury`.

It happens once. `docker compose` keeps the layer, and a `make test` after that
is seconds. The published image at `ghcr.io/acodeninja/bootstrap/mercury:main`
has already paid it, so the bootstrap pulls rather than builds unless you ask
it not to.

Only one grade of the standard library is built — `hlc.gc`, high-level C with
the Boehm collector — because each extra grade costs minutes and tens of
megabytes. `configure` is told to make it the *default* grade as well as the
only one, which is why nothing here ever passes `--grade`.

## Modes and determinism

This is the part of Mercury that no other logic language in this collection
has, and the part worth reading the kitchen sink for. A declaration says three
things:

```mercury
:- pred shouted(string::in, string::out) is det.
```

- the **types** of the arguments
- the **mode** each one is in: `in` arrives bound, `out` arrives free and
  leaves bound, `di`/`uo` are the unique modes the `io` state uses
- the **determinism**: `det` succeeds exactly once, `semidet` once or not at
  all, `multi` one or more times, `nondet` any number of times including none

All three are checked, and a mistake in any of them is a compile error rather
than a warning or a wrong answer. A predicate declared `det` whose clauses do
not cover every input is rejected, and so is a call that leaves an `in`
argument unbound.

The one that catches people is subtler. Handing a *bound* value to an `out`
argument is allowed — Mercury compiles it as a fresh variable plus a
unification afterwards, an **implied mode** — and that unification can fail, so
the call comes out `semidet`. The line is fine in a `semidet` context and
rejected in a `det` one, with the determinism message rather than a mode
message. The kitchen sink's gotcha is this.

`make lint` is where you see all of it. The compiler is the only checker
Mercury has, and it is a thorough one.

## Tests

A test is a module under `tests/` that declares `main/2`. It prints a plan and
one line per assertion in [TAP](https://testanything.org), because Mercury
ships no test framework, and `tests/tap.m` is the fifty lines that do the
printing — a module rather than a dependency.

`make test` discovers tests twice over:

- `mmc` works in module names rather than paths, so the runner writes a
  `Mercury.modules` mapping from every `.m` file under `src/` and `tests/`.
  That is what lets a build running elsewhere find your source at all.
- A module under `tests/` that declares `main/2` is a test, because that is
  what `mmc --make` can link into an executable. Anything else there is a
  library the tests import, which is how `tests/tap.m` avoids being run as a
  test of its own.

So a new `tests/*.m` needs no registration, and deleting one takes its
assertions with it. A module's name has to match its filename, which is the
only rule to remember when adding a file.

Builds run in `/cache/build` on the container's cache volume. `mmc` has no flag
for where its `Mercury/` interface and object directories go — it writes them
beside the module it is compiling — so the runner builds somewhere else
entirely and points `Mercury.modules` back at your source. The project
directory stays clean, and `git status` after `make test` is empty.

## There is no formatter

Mercury ships nothing that reformats source and nothing third-party is
packaged, so `make fmt` prints a line saying so and changes nothing. The target
exists because every project here has the same six, not because there is work
for it to do. `.editorconfig` carries the four-space indent instead.

`make lint` is a real check despite that. It runs `mmc --make <module>.check`,
which is the build system's spelling of `--errorcheck-only`: it builds the
interface files the check needs, then type, mode and determinism checks every
module and writes no code. `--halt-at-warn` makes a singleton variable or an
unused import fail too. What it cannot tell you is anything about layout.

## Adding a dependency

Mercury has no package manager. A library is a directory of `.m` files, and the
way to use one is to put it where `mmc` can find it: add it under `src/` and it
goes into the module mapping with everything else.

For something larger, `mmc --make lib<module>` builds an installable library
and `mmc --install-prefix <dir> --make lib<module>.install` installs it; a
Dockerfile `RUN` is the right place for that, so the image carries it and
`make test` does not rebuild it.

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
3. [Reverse lookup](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/modes-and-determinism.md) — one predicate, two directions, both declared

Then, when the group wants more: [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md) → [Eight queens](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/eight-queens.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
