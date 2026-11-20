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

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
