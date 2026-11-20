# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need GHC or cabal. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # compile the library and the executable
$ make shell   # open a shell in the container
```

## Tests

`hspec-discover` generates the test suite's `main` by scanning `test/` for
files ending in `Spec.hs`, so a new one needs no declaration anywhere. Each
exports `spec :: Spec`, and `test/Spec.hs` is the one-line pragma that drives
the scan.

## Adding a dependency

Add it to the `build-depends` of the stanza that needs it in
`{{PROJECT_SLUG}}.cabal`, then rebuild so the image's primed cabal store picks
it up:

```console
$ docker compose build
```

Builds go to `/cache/dist` in the container's named volume rather than
`dist-newstyle/` beside the source, which is why `make test` leaves the project
clean.

`hlint` and `ormolu` are not dependencies of this project: they live in the
image, so the `.cabal` file stays down to what the code actually imports. To
change their versions, edit the `Dockerfile` and rebuild.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
