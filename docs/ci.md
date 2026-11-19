# CI

Two separate things, easily conflated:

1. the workflow a **generated project** ships with
2. the workflow **this repo** runs to prove the generator works

## Generated project CI

`files/.github/workflows/ci.yml` in every template. It builds the image and runs the two
tasks — the same two commands the developer runs locally, which is the point:

```yaml
name: ci

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - run: docker compose build
      - run: make lint
      - run: make test
```

Deliberately minimal. It is a starting point the project owner will edit, not a
framework. No matrix, no release job.

The login step is not optional ceremony — see [rate limits](#rate-limits) below. A
template's README must say that the two secrets are needed, and that CI will fail
confusingly without them.

## This repo's CI

The real proof. A template is only correct if a cold machine can bootstrap it and get a
green test, so that is exactly what CI does, for every template.

```yaml
jobs:
  bootstrap:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        template: [javascript, zig, go, rust, python, ...]
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/setup-buildx-action@v3
      - run: ./bootstrap.sh ${{ matrix.template }} ../out
```

`fail-fast: false` matters: when an upstream image bumps and breaks three languages, you
want all three in one run.

The bootstrap's own build and test steps are what assert the generated project works.
CI does not re-run them — a non-zero exit from `bootstrap.sh` with code `4` or `5`
already says which half failed.

### One platform

Containers are Linux whatever the host is, so running the matrix on three operating
systems would test Docker Desktop, not the templates. The matrix is `ubuntu-latest`
only.

The template list is written out in the workflow rather than generated. With one
platform and no `PLATFORMS` key left to consult, a matrix-generation job would be an
indirection around a list of 26 strings.

### Layer caching

Twenty-six cold image builds per run is unacceptable. Use buildx with the GitHub Actions
cache backend so unchanged Dockerfiles restore rather than rebuild:

```yaml
      - run: |
          docker buildx build \
            --cache-from type=gha,scope=${{ matrix.template }} \
            --cache-to   type=gha,scope=${{ matrix.template }},mode=max \
            --load -t ${{ matrix.template }}-dev ../out
```

Scope per template, or they evict each other.

### Script quality

Separate job, Linux only:

- `shellcheck bootstrap.sh`
- `actionlint` over this repo's workflows and every template's `files/.github/workflows/`
- `hadolint` over every template's `Dockerfile`

### The remote path

The matrix above exercises clone mode. Remote mode — the documented one-liner — has its
own failure surface and needs its own job: the ref-pinning logic, the archive download,
the extract, and the temp-directory cleanup.

```yaml
  remote:
    runs-on: ubuntu-latest
    steps:
      - run: |
          BOOTSTRAP_REF=${{ github.sha }} /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/${{ github.sha }}/bootstrap.sh)" \
            -- javascript ../out
```

Pinning both URLs to `github.sha` tests the commit under review rather than whatever is
on `main`, and proves the two refs stay in step — the bug where a script served from one
ref fetches templates from another.

This job cannot run until the repository is public; `raw.githubusercontent.com` serves
nothing for a private repo. Until then the remote path is untested, alongside the gaps
in [what is not covered](#what-is-not-covered).

### Failure-mode assertions

Negative tests asserting the exit codes in [cli.md](cli.md) rather than just "it failed":

| Command                                                     | Expect               |
| ----------------------------------------------------------- | -------------------- |
| `bootstrap.sh`                                              | `1`                  |
| `bootstrap.sh nosuchlang ../out`                            | `2`                  |
| `bootstrap.sh zig .` (non-empty)                            | `3`                  |
| `bootstrap.sh zig ../out --dry-run` then `test ! -e ../out` | `0`, nothing written |
| `BOOTSTRAP_REF=refs/heads/no-such-branch` remote run        | `6`                  |

Codes `4` and `5` are not asserted — faking an absent Docker daemon or a failing
generated test costs more than it proves.

## What is not covered

Stated plainly, because the gaps are real:

- **`bootstrap.ps1` has no CI at all.** Linux-only CI means nothing exercises the
  PowerShell script. A regression surfaces when a Windows user hits it. Any change to
  `bootstrap.sh` is a change to both, and the PowerShell side must be tested by hand.
- **The Windows `make` path is untested**, including the `cmd.exe`-shell constraint that
  bans `grep`/`awk`/`sed` from Makefile targets. Nothing will catch a violation
  automatically; it is a review responsibility.
- **macOS is untested.** Lower risk, since it runs the same Linux containers through the
  same POSIX scripts.

These follow from choosing a single-platform matrix. The alternative was 54 jobs mostly
re-proving that Docker is Docker.

## Rate limits

Docker Hub limits anonymous pulls, and GitHub Actions runners share IP addresses, so
unauthenticated CI hits the limit routinely and reports it as an unrelated-looking build
failure. Every workflow that builds an image — in this repo and in every template —
authenticates first with `docker/login-action`.

Combined with layer caching, most runs then pull nothing at all.
