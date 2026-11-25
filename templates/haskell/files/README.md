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
3. [The first thousand primes](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/laziness.md) — a definition with no bound in it

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
