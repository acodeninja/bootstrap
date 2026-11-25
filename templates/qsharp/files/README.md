# {{PROJECT_NAME}}

A Q# project. `src/` and `tests/` are Q#; the simulator and compiler come from
Microsoft's QDK, pinned in the `Dockerfile`.

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need the QDK, Python or an Azure account. The toolchain lives in the
container, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every source and test file
$ make fmt     # a no-op: the released QDK ships no formatter
$ make build   # a no-op: the simulator compiles from source
$ make shell   # open a shell in the container
```

## The suite is Python-hosted, and your code is not

The released QDK is a Python wheel and publishes no test runner: `qsc` lives in
Microsoft's own repository and never ships. So `make test` runs a Python script
that lives **in the image**, not in this project: it loads `src/` as a Q#
project, evaluates every `.qs` file under `tests/`, and runs the callables
marked `@Test()`.

Nothing you write here is Python. Add a test by writing a Q# callable with the
`@Test()` attribute in any file under `tests/`; it is found by the attribute,
so no file lists it anywhere. A failing test is named in full, but its location
reads `line_0` rather than a path: the host hands each test source to the
compiler as a fragment, and a fragment has no filename to report.

`qsharp.json` is the project manifest, and the compiler needs it. It may
enumerate files but not directories, so `tests/` deliberately sits outside the
project and is evaluated instead — which is also why a `tests/` with nothing in
it is a green run rather than an error.

Telemetry is off. `qdk` posts a metric to an Azure Monitor endpoint on import
unless told not to, and the `Dockerfile` tells it not to.

## Adding a dependency

Q# dependencies go in `qsharp.json` under `dependencies`. Python-side pins —
the QDK itself — go in the `Dockerfile`, followed by `docker compose build`.

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
2. [Leap years](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/leap-years.md) — arithmetic and branching, no strings needed
3. [A fair bit, and a pair that agree](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/superposition.md) — superposition, entanglement, and an operation run backwards

Then, when the group wants more: [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
