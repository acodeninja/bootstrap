# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a JDK, Gradle or Groovy. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check the sources with CodeNarc
$ make fmt     # a no-op: Groovy has no usable formatter
$ make build   # compile and package into a jar
$ make shell   # open a shell in the container
```

## Tests

Tests are [Spock](https://spockframework.org) specifications: a class extending
`Specification`, whose feature methods are named with a quoted sentence and
divided into `given`, `when` and `then` blocks. Spock reports the value of every
expression in a `then` or `expect` block, so a failure needs no message.

Gradle finds them by scanning the test classes it compiled, so nothing names a
spec anywhere. Add a file to `test/` and `make test` runs it; delete one and it
stops looking for it.

The module is `src/{{PROJECT_SNAKE}}.groovy` and the tests are in `test/`,
rather than Gradle's `src/main/groovy` and `src/test/groovy`. `build.gradle`
sets the two source roots; move them if you prefer the conventional layout. A
Groovy file is free to hold a class of any name, which is why `Greeter` can live
in a file named after the project.

Gradle's own output goes to `/cache` in the container rather than `build/` here,
so the project directory stays as you left it.

## There is no formatter

Groovy has no canonical formatter, and the one that exists was tried: Spotless's
`greclipse` step, which drives the Groovy-Eclipse formatter. It runs, and it
deletes the space before every `>` in the file — `n > 1` comes back as `n> 1`,
in a method body or a closure, with or without a config file overriding the JDT
spacing options. Running it would make every comparison in the project worse,
so `make fmt` prints that and exits 0.

`make lint` therefore carries the layout rules as well as the correctness ones.
CodeNarc's `formatting` ruleset checks indentation, spacing and blank lines, and
`.editorconfig` keeps your editor in step with it.

## Adding a dependency

```console
$ make shell
$ vi build.gradle
```

Gradle resolves it on the next `make test`. Nothing is written to the project —
the download cache lives in the container's `/cache` volume.

New CodeNarc rules are a `config/codenarc/codenarc.xml` edit rather than a
dependency. The `convention` and `naming` rulesets are left out on purpose:
they want a declared type on every variable and an identifier for a method name,
which rules out `def` and every Spock feature name in this project.

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
3. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built
4. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself
5. [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md) — records, enums, parsing, and a failure worth reporting

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
