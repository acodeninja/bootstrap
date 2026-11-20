# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need SWI-Prolog. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # load every source file and check it
$ make fmt     # a no-op: SWI-Prolog ships no formatter
$ make build   # compile the project into a saved state in /cache
$ make shell   # open a shell in the container
```

## There is no formatter

SWI-Prolog ships nothing that reformats source, so `make fmt` prints a line
saying so and changes nothing. The target exists because every project here has
the same six, not because there is work for it to do.

`make lint` is a real check despite that. It loads every `.pl` file under `src/`
and `tests/` with `--on-error=status --on-warning=status`, then runs `check/0`,
so a syntax error, a singleton variable or a call to a predicate that does not
exist all fail the build. What it cannot tell you is anything about whitespace.

## Tests

Tests are `plunit` units in `tests/`. `make test` loads every `.pl` file it
finds there and runs whatever `begin_tests/1` blocks turned up, so a new file
needs no registration — and the target still exits 0 when there are none.

## Adding a dependency

```console
$ make shell
$ swipl pack install -y some-pack
```

Packs install to `/cache/packs` on the container's cache volume, so they survive
between runs but not a `docker compose down -v`. Add the install line to the
`Dockerfile` for anything the project should not be able to lose.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
