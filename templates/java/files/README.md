# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a JDK, Gradle or JUnit. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile and package into a jar
$ make shell   # open a shell in the container
```

## Layout

The module is `src/{{PROJECT_SNAKE}}.java` and the tests are in `test/`,
rather than Gradle's `src/main/java` and `src/test/java`. `build.gradle` sets
the two source roots; move them if you prefer the conventional layout.

The module's class is package-private, not `public` — that is what lets its
filename carry the project name instead of the class name.

Gradle's own output goes to `/cache` in the container rather than `build/`
here, so the project directory stays as you left it.

## Adding a dependency

```console
$ make shell
$ vi build.gradle
```

Gradle resolves it on the next `make test`. Nothing is written to the project —
the download cache lives in the container's `/cache` volume.

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
3. [Shape area](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/records-and-pattern-switch.md) — a closed set of records, and a switch that is checked

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) → [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
