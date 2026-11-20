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
green test, so that is exactly what CI does, for every template — and then publishes the
image it just tested.

One workflow, in this order:

```
templates ─┐
changed   ─┼─> image-amd64 ─────> image-arm64 ─────> manifest
lint      ─┘   26 legs            25 legs            26 legs
               build, test, push  build, test, push  merge :main

contract, remote                                     (independent)
```

Each `image` leg is one template on one architecture:

```yaml
      - run: ./bootstrap.sh ${{ matrix.template }} ../scaffold --no-pull
      - name: push what the tests passed
        if: ${{ needs.changed.outputs.templates == 'true' && needs.lint.result == 'success' }}
        run: |
          image=$(sed -n 's/^ *image: *//p' ../scaffold/compose.yaml)
          docker tag "$image" "${image}-amd64"
          docker push "${image}-amd64"
```

That is the whole idea: **the bootstrap builds it, the bootstrap tests it, and the thing
that passed is the thing that ships.** `--no-pull` because the point is the `Dockerfile`;
pulling the published image would test the previous commit's toolchain against this
commit's templates, and a broken `Dockerfile` would go green.

It used to be two workflows that did not know about each other. `ci` built twenty-six
images, tested them and threw them away; `publish` built fifty-one more and pushed those,
untested. Seventy-seven builds to ship fifty-one images, and the fifty-one that shipped
were not the ones that passed. Merging them removes twenty-six builds from every push.

`fail-fast: false` matters: when an upstream image bumps and breaks three languages, you
want all three in one run.

The image name is read out of the scaffold's `compose.yaml` rather than rebuilt from the
template id — the same reason `bootstrap.sh` reads it back instead of composing it, so the
tag pushed here cannot drift from the one `compose` will pull.

### What gates what

- **A template gates itself.** One red test stops that template's push and nothing else.
  Gating the whole matrix was the objection to testing before publishing at all — it would
  put the slowest template in front of every other template's release — and a per-template
  gate answers it, because `manifest` was already per-template.
- **`lint` gates publishing, not testing.** It is in `needs`, so the image jobs wait for
  it, but they run under `!cancelled()` and only the push steps require
  `needs.lint.result == 'success'`. A shellcheck nit should not stop twenty-six templates
  being tested; it should stop a release.
- **`changed` gates publishing by path.** A docs-only commit cannot change an image, and
  rebuilding all fifty-one for one of those is what answered `429` once already. This was
  a `paths` filter on the old publish workflow's trigger; merged, it has to be a job,
  because a trigger filter would skip the tests too. It diffs
  `github.event.before..github.sha` under `templates/`, and answers "publish" whenever the
  question cannot be asked — a new branch, a force push.
- **Nothing publishes from a pull request.** `changed` returns `false` for any event that
  is not a push, so a PR builds and tests amd64 and stops there.

`packages: write` is granted to the three jobs that push, never at workflow level, so the
`lint`, `contract` and `remote` jobs keep read-only tokens.

### The commit path

A runner has no `user.name` or `user.email`, and `bootstrap.sh` treats that as
non-fatal — it initialises the repository, skips the commit, says so, and still exits
`0`. Left alone, CI would prove the fallback and never the normal path, so every job that
runs the bootstrap configures an identity first.

The `contract` job then asserts what the commit contains: one commit, on `main`, with a
clean tree afterwards. It also asserts that `.env` exists and is **not** tracked. That
file is generated rather than templated — it carries the host's uid and gid so the
container writes files you own — and committing one machine's ids into a project is the
kind of bug that survives review.

The bootstrap's own build and test steps are what assert the generated project works.
CI does not re-run them — a non-zero exit from `bootstrap.sh` with code `4` or `5`
already says which half failed.

### Two architectures, in series

Containers are Linux whatever the host is, so running the matrix on three operating
systems would test Docker Desktop, not the templates. There is no Windows or macOS leg.

There are two *architectures*, on native runners rather than under QEMU: emulating a
toolchain build costs more than the whole matrix, and public repositories get
`ubuntu-24.04-arm` free. They run in series — all of amd64, then all of arm64 — which
holds concurrent `FROM` resolutions at `max-parallel: 8` rather than sixteen, and means
amd64 is published before an arm runner starts.

Each leg pushes its own `:main-<arch>` tag and a per-template `manifest` job merges them
into the `:main` index `compose.yaml` names. The merge takes whichever architectures it
finds rather than naming both, because `nim` has no `arm64` base — see
[languages.md](languages.md) — and because a template whose tests failed has no new tag
to merge. The edge that follows: if a template's amd64 leg fails and its arm64 leg passes,
`:main` indexes a fresh arm64 beside the previous commit's amd64. That was already true of
a failed *build* and is now also true of a failed test; the run is red either way.

Running arm64 only when publishing is deliberate. It is the architecture nothing had ever
tested, it is in the pipeline to validate what is about to ship, and a pull request should
not pay for it.

The template list is **generated**, not written out: a `templates` job globs
`templates/*/template.env` into a JSON array and all three matrices consume it via
`fromJSON`. That is the same glob `bootstrap.sh` discovers templates with, so adding a
language needs no CI edit — which is what the contract's "no registry to update" promise
requires.

### Layer caching

There is none, and that is a choice rather than an omission.

The build happens inside `bootstrap.sh`, which runs `docker compose build` in the target
directory and offers no hook for extra flags. `docker compose build` has no
`--cache-from`/`--cache-to` either; those are compose-file keys, and every template's
`compose.yaml` uses the scalar short form `build: .`, which has no room for sub-keys. So
caching would mean one of:

1. **`cache_from`/`cache_to` in every template's `compose.yaml`.** Twenty-six edits, and
   it puts CI-specific configuration into the generated project, which the user then has
   to understand or delete.
2. **A documented build-flag passthrough in `bootstrap.sh`** — one variable it reads and
   appends — set from CI. One edit to the script, none to the templates, and the generated
   project stays clean.

Route 2 is the way in if it is wanted, and it is not obviously worth taking. The old
publish workflow did cache — `type=gha`, `mode=max`, scoped per template and
architecture — against an Actions cache that is 10 GB for the whole repository. `haskell`
alone is 6.4 GB, so the large legs evicted each other and the legs that hit were the fast
ones anyway.

The sting has also mostly been drawn: `haskell` was the one leg that made this urgent, and
installing its linters from apt took it from never finishing to 99s. The slowest leg is now
`ocaml` at about four minutes.

### Script quality

Separate job, Linux only, and a gate on publishing:

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

Not a workflow of its own any more — the last three steps of each `image` leg, and the
`manifest` job after them. What gets published and when is covered in
[what gates what](#what-gates-what) above; what follows is the shape of the artefact.

Four things keep the pipeline inside Docker Hub's limit, which is counted **per account**
and shared by every leg in flight. The first three were added after a run answered `429`:

- `changed`, because a docs-only commit cannot change an image and was rebuilding all
  fifty-one
- a `concurrency` group, because successive pushes stacked whole matrices
- `max-parallel: 8`, because every build resolves its `FROM` and fifty-one at once is past
  the limit however well authenticated
- the amd64 wave finishing before the arm64 wave starts, which is what keeps that eight
  from becoming sixteen

Nothing here is urgent, so spreading it out costs nothing that matters.

The build context is a **scaffold**, not `templates/<id>/files`, because the build happens
where the bootstrap put the project. The raw template directory is not buildable anyway:
the manifests the priming layers read still carry `{{TOKEN}}` placeholders — `elixir`'s
`mix.exs` declares `app: :{{PROJECT_SNAKE}}`, which is not valid Elixir — and `haskell`'s
cabal file is *named* with one. Five of the twenty-six failed this way on the first run.
It also means the published image is exactly what a developer's own first build produces,
which is now literally true: it is the same build, by the same script, in the same place.

The images are still a cache rather than a release — see
[containers.md](containers.md#published-images-are-a-cache-not-the-pin). Publishing is
gated on tests because the gate is cheap and per-template, not because a published image
is a promise.

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

These follow from running one operating system. The alternative was 54 jobs mostly
re-proving that Docker is Docker.

## Rate limits

Docker Hub limits anonymous pulls, and GitHub Actions runners share IP addresses, so
unauthenticated CI hits the limit routinely and reports it as an unrelated-looking build
failure. This repository's `image` jobs authenticate first with `docker/login-action`; a
generated project's CI does the same when the secrets are set.

Each leg logs in to both registries, for opposite reasons: Docker Hub because every
`FROM` comes from there and fifty-one builds off shared runner IPs are well past the
anonymous limit, ghcr with `GITHUB_TOKEN` because that is where the image goes.
