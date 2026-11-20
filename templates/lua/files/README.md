# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Lua. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: Lua runs from source
$ make shell   # open a shell in the container
```

## Tests

Busted looks for `spec/*_spec.lua` on its own, so `make test` names nothing.
Deleting a spec file is enough to remove it from the suite.

## Adding a dependency

```console
$ make shell
$ luarocks --lua-dir=/usr --tree=/cache/luarocks install some-rock
```

That installs into the named cache volume, which every container run shares.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
