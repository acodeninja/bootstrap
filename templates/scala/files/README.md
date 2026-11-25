# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a JDK, Scala or sbt. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile both scopes with warnings fatal, and check formatting
$ make fmt     # reformat in place
$ make build   # compile the module into a library jar
$ make shell   # open a shell in the container
```

## Layout

The module is `src/{{PROJECT_SNAKE}}.scala` and the tests are in `test/`.
`scala-cli` finds both for itself: every `.scala` file under the project root is
a source, and anything under `test/` belongs to the test scope.

`project.scala` is the build definition — the Scala version, the compiler
options and the test dependencies, as `//> using` directives. There is no
`build.sbt`, and nothing names an individual test file.

`.scala-build/` and the compiled output go to `/cache` in the container rather
than into this directory, so the project stays as you left it.

## Adding a dependency

```console
$ make shell
$ vi project.scala
```

A `//> using dep org.group::artifact::version` line is all it takes, and
`//> using test.dep` for one only the tests need. It is resolved on the next
`make test`; the download cache lives in the container's `/cache` volume.

## Linting

`make lint` is the compiler. `project.scala` turns on `-Wunused:all` and
`-Werror`, so an unused import or an unreachable case is an error rather than a
warning nobody reads. `make test` compiles with the same options but will not
stop on one: `-Werror` still writes class files, and the compile server it goes
through does not count that as a failed run.

`make fmt` is scalafmt, which ships inside `scala-cli`. `.scalafmt.conf` pins
its version and dialect — without that file it would pick both for itself, and
the choice would move under you.

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
3. [Describe anything](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/typeclasses-by-given.md) — a capability that travels separately from the type

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
