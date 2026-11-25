# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Gleam or Erlang. The toolchain lives in the container, pinned
by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting and types
$ make fmt     # reformat in place
$ make build   # compile to BEAM bytecode
$ make shell   # open a shell in the container
```

## Tests

`gleam test` runs `main` in `test/{{PROJECT_SNAKE}}_test.gleam`, and
`gleeunit.main()` there globs `test/` at run time for every function whose name
ends in `_test`. A new test file needs no declaration anywhere — add it and run
`make test`.

## Adding a dependency

```console
$ make shell
$ gleam add some_package
```

That updates `gleam.toml` and `manifest.toml`, which pins the exact version and
checksum of every package. The compiled result lives in the `build` named
volume rather than in your project, so `build/` on the host stays empty.

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
3. [Run length](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/no-loops-only-recursion.md) — a fold, in a language with no loop to reach for

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
