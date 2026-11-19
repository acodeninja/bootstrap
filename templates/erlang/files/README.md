# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Erlang or rebar3. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting and types
$ make fmt     # reformat in place
$ make build   # compile to .beam files
$ make shell   # open a shell in the container
```

## Tests

`rebar3 eunit` runs every `test/*_tests.erl`, so a new test file needs no
declaration anywhere — add it and run `make test`.

## Adding a dependency

This project ships a `rebar.lock` that locks nothing, because it has no
dependencies beyond the `erlfmt` plugin used by `make fmt` and `make lint`.
Add a runtime dependency to the `{deps, [...]}` entry in `rebar.config` and
run `make shell` once to let rebar3 regenerate the lock.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error
that looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
