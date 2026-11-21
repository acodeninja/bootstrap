# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need OCaml or opam. The compiler, dune, alcotest and ocamlformat
live in the container, pinned by the `Dockerfile`, so a green suite here is a
green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the library and the tests
$ make shell   # open a shell in the container
```

`make lint` checks formatting and nothing else. OCaml's own type checker is
what catches the rest, and `make build` is where you see it.

## Adding a test

Any file under `test/` whose name ends in `_test.ml` and which exposes

```ocaml
val suite : unit Alcotest.test_case list
```

is picked up and run. `test/dune` names no suite, so nothing needs editing
when you add one or delete one.

## Adding a dependency

```console
$ make shell
$ opam install some-package
```

That lasts as long as the container. To keep it, add the package to the
`opam install` line in the `Dockerfile` with an exact version and run
`docker compose build`.

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

## Licence

MIT — see [LICENSE](LICENSE).
