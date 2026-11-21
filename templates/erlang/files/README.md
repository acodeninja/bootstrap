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
