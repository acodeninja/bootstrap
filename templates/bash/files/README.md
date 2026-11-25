# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need bash, bats, shellcheck or shfmt. The toolchain lives in the
container, pinned by the `Dockerfile`, so a green suite here is a green suite
anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check every file with shellcheck, then with shfmt
$ make fmt     # reformat in place with shfmt
$ make build   # a no-op: bash runs from source
$ make shell   # open a shell in the container
```

## Tests

[bats](https://bats-core.readthedocs.io/) is the shell test runner Debian
packages, so there is nothing to install. Every `*.bats` file under `tests/` is
found and run; add one and it runs, delete one and nothing refers to it.

```bash
setup() {
  # shellcheck source-path=SCRIPTDIR source=../src/{{PROJECT_SNAKE}}.sh
  . "$BATS_TEST_DIRNAME/../src/{{PROJECT_SNAKE}}.sh"
}

@test "a greeting addresses the name it is given" {
  run greet world

  [ "$status" -eq 0 ]
  [ "$output" = 'Hello, world!' ]
}
```

A `@test` body is an ordinary function, so `local` works inside one and any
command that returns non-zero fails the test. That is the whole assertion
mechanism: `[` is a command like any other, and there is no library to learn.

`run` is bats' own, and it is what lets a test watch something fail. It calls
its argument with errexit suspended and puts the result in `$status` and
`$output`, so a test can assert a refusal instead of being killed by it.

`setup` runs before each test in the file. `$BATS_TEST_DIRNAME` is the
directory of the file being run, so the `.` line resolves against `tests/`
rather than the working directory — which is what lets one file be run alone:

```console
$ make shell
$ bats tests/{{PROJECT_SNAKE}}.bats
```

## Lint

`make lint` runs two tools, and they do not overlap.

`shellcheck -x` is the real linter: it finds quoting that will word-split,
comparisons that read a number as text, and variables modified in a subshell
that the caller will never see. It understands bats files, so the suite is
checked alongside `src/`. `-x` is what makes it follow the `.` into `src/`
instead of reporting an unresolved path.

Two directives in this project exist to make that check possible rather than to
quiet it. `src/{{PROJECT_SNAKE}}.sh` carries `# shellcheck shell=bash` because a sourced
file has no shebang to infer a dialect from, and without it shellcheck declines
to check the file at all. The test files carry
`# shellcheck source-path=SCRIPTDIR` so the followed path resolves against the
test rather than against whatever directory `make` ran in.

`shfmt -d` is the formatter in check mode, and it fails on a diff. It reads
`.editorconfig` — including `switch_case_indent`, which is why the arms of a
`case` are indented here and would not be by default.

## Adding a dependency

Bash has no package manager, and that is the honest answer: a dependency is a
file you source, or a program on `PATH`.

For a file, put it in `src/` and `.` it. For a program, install it in the
`Dockerfile` so the container stays the pin — reaching for something the host
happens to have is how a suite starts passing only on one machine.

The same goes for bats' own helper libraries. `bats-support` and `bats-assert`
are packaged in Debian and give you `assert_output` in place of `[`, but this
project does not install them: `[` is already the assertion, and one less
dependency is one less thing to pin.

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
3. [Tally the lines](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/exit-status-and-the-subshell.md) — a process boundary in the middle of one line

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [String calculator](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/string-calculator.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
