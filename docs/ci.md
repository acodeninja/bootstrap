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
    env:
      dockerhub_username: ${{ secrets.DOCKERHUB_USERNAME }}
    steps:
      - uses: actions/checkout@v7
      - if: env.dockerhub_username != ''
        uses: docker/login-action@v4
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - run: docker compose build
      - run: make lint
      - run: make test
```

Deliberately minimal. It is a starting point the project owner will edit, not a
framework. No matrix, no release job.

**It builds rather than pulls, on purpose.** The published image would be faster, but a
generated project's CI exists to test that project's own `Dockerfile`; pulling would
test the upstream image instead and quietly ignore every edit the owner had made to it.

That is also why the `docker/login-action` step survives: building resolves the base
image from Docker Hub, which rate-limits — see [rate limits](#rate-limits). It is
guarded on the secret rather than required, so a project that never hits the limit needs
no setup at all and one that does has somewhere to put credentials. The secrets context
is not available to an `if`, which is why the value goes through `env` first.

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
      - uses: actions/checkout@v7
      - name: git identity
        run: |
          git config --global user.name 'bootstrap ci'
          git config --global user.email 'ci@example.invalid'
      - uses: docker/login-action@v4
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/setup-buildx-action@v4
      - run: ./bootstrap.sh ${{ matrix.template }} ../out
```

`fail-fast: false` matters: when an upstream image bumps and breaks three languages, you
want all three in one run.

### The commit path

A runner has no `user.name` or `user.email`, and `bootstrap.sh` treats that as
non-fatal — it initialises the repository, skips the commit, says so, and still exits
`0`. Left alone, CI would prove the fallback and never the normal path, so both jobs
configure an identity first.

The `contract` job then asserts what the commit contains: one commit, on `main`, with a
clean tree afterwards. It also asserts that `.env` exists and is **not** tracked. That
file is generated rather than templated — it carries the host's uid and gid so the
container writes files you own — and committing one machine's ids into a project is the
kind of bug that survives review.

The bootstrap's own build and test steps are what assert the generated project works.
CI does not re-run them — a non-zero exit from `bootstrap.sh` with code `4` or `5`
already says which half failed.

### One platform

Containers are Linux whatever the host is, so running the matrix on three operating
systems would test Docker Desktop, not the templates. The matrix is `ubuntu-latest`
only.

The template list is **generated**, not written out: a `templates` job globs
`templates/*/template.env` into a JSON array and the matrix consumes it via `fromJSON`.
That is the same glob `bootstrap.sh` discovers templates with, so adding a language needs
no CI edit — which is what the contract's "no registry to update" promise requires.

### Layer caching

Twenty-six cold image builds per run is a real cost, and it is **not implemented**. What
follows is what it would take, because the obvious approach does not fit the code.

The build does not happen in the workflow. `bootstrap.sh` runs `docker compose build
--progress plain` in the target directory, and it offers no hook for extra flags — no
passthrough variable, and the flag string is a literal. `docker compose build` has no
`--cache-from`/`--cache-to`; those are compose-file keys, and every template's
`compose.yaml` uses the scalar short form `build: .`, which has no room for sub-keys. So
there are only two honest routes:

1. **Add `cache_from`/`cache_to` to every template's `compose.yaml`.** Twenty-six edits,
   and it puts CI-specific configuration into the generated project, which the user then
   has to understand or delete.
2. **Give `bootstrap.sh` a documented way to pass build flags through** — one variable it
   reads and appends — and set it from CI. One edit to the script, none to the templates,
   and the generated project stays clean.

Route 2 is the one to take. Whoever does it should note that CI bootstraps into
`../scaffold` for every template, so the compose project and image tag are `scaffold` and
`scaffold-dev` regardless of language — a per-template cache scope has to come from
`matrix.template`, not from the tag.

The sting has also mostly been drawn: `haskell` was the one leg that made this urgent, and
installing its linters from apt took it from never finishing to 99s. The slowest leg is now
`ocaml` at about four minutes.

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
    env:
      sha: ${{ github.sha }}
    steps:
      - run: |
          BOOTSTRAP_REF=$sha /bin/bash -c \
            "$(curl -fsSL "https://raw.githubusercontent.com/acodeninja/bootstrap/$sha/bootstrap.sh")" \
            -- javascript ../out --no-git --no-build
          test -f ../out/package.json
```

Pinning both URLs to `github.sha` tests the commit under review rather than whatever is
on `main`, and proves the two refs stay in step — the bug where a script served from one
ref fetches templates from another.

A second step asserts the failure path, which is the half with something to clean up: a
`BOOTSTRAP_REF` naming no branch must exit `6`, write nothing to the target, and leave no
temporary directory behind.

This covers `bootstrap.sh` only. `bootstrap.ps1` implements the same contract and is
hand-tested — see [what is not covered](#what-is-not-covered).

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

## Publishing images

`publish.yml`, on every push to `main`. It is the only workflow here with write scope of
any kind, and it writes `packages` only.

Two architectures, on native runners rather than under QEMU: emulating a toolchain build
costs more than the whole matrix, and public repositories get `ubuntu-24.04-arm` free.
Each of the 52 jobs pushes its own `:main-<arch>` tag and a per-template `manifest` job
merges them into the `:main` index `compose.yaml` names. The merge takes whichever
architectures it finds rather than naming both, because `nim` has no `arm64` base — see
[languages.md](languages.md).

The build context is a **scaffold**, not `templates/<id>/files`. The raw template
directory is not buildable: the manifests the priming layers read still carry
`{{TOKEN}}` placeholders — `elixir`'s `mix.exs` declares `app: :{{PROJECT_SNAKE}}`, which
is not valid Elixir — and `haskell`'s cabal file is *named* with one. Five of the
twenty-six failed this way on the first run. Scaffolding first also means the published
image is exactly what a developer's own first build would have produced.

It is deliberately **not** gated on the `bootstrap` matrix. Publishing cannot make a
broken template worse: the `Dockerfile` that fails to build is in the repository either
way, and the bootstrap falls back to building it. Gating would put the slowest template's
test run in front of every push. The images are a cache, not a release — see
[containers.md](containers.md#published-images-are-a-cache-not-the-pin).

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
failure. This repository's `bootstrap` job authenticates first with
`docker/login-action`; a generated project's does the same when the secrets are set.

The publish workflow logs in to both, for opposite reasons: ghcr with `GITHUB_TOKEN`
because that is where the image goes, Docker Hub because every `FROM` comes from there
and fifty-two parallel builds off shared runner IPs are well past the anonymous limit.
