# Containers

Every generated project runs its toolchain inside Docker. The host needs **Docker** and
**make**, and that answer is the same for all 26 templates.

## Why containers

An earlier version of this design used [mise](https://mise.jdx.dev) to install and pin
toolchains. It worked for most languages and fell over for the rest: `clojure`, `nim`,
`swipl`, `ocaml`, `luarocks` and `ghc` have no usable mise pin, so six of the eighteen
templates then planned would have shipped hand-written per-platform install prose and a
preflight that failed with instructions instead of running anything.

Containers delete that whole category. The language's own image installs the language;
there is no tier system, no `PREFLIGHT_BIN`, no per-template `INSTALL.md`, and no
per-platform branch anywhere in the design.

The trade is explicit and worth stating: Docker is a heavier prerequisite than a version
manager, and every test run pays container startup. [Caching](#caching-is-mandatory) is
what makes the second cost bearable, which is why it is a contract requirement rather
than an optimisation.

## The three files

Each template's `files/` contains:

| File           | Job                                                                 |
| -------------- | ------------------------------------------------------------------- |
| `Dockerfile`   | `FROM` the language's image, install dependencies, `WORKDIR /work`  |
| `compose.yaml` | one `dev` service: bind-mounted source, named cache volumes, `user` |
| `Makefile`     | `test`, `lint`, `fmt`, `build`, `shell`, `help`                     |

The Makefile is the only place a real command appears. The image stays generic and the
command is passed in, so there is exactly one source of truth per task:

```make
RUN := docker compose run --rm dev

test:   ## Run the kitchen sink suite
	$(RUN) zig build test --summary all

lint:   ## Check formatting
	$(RUN) zig fmt --check .
```

### The Makefile may not use host shell tools

Beyond `docker` itself, a Makefile target must not call `grep`, `awk`, `sed`, `column`,
`id`, or anything else from a POSIX toolbox. Windows `make` runs targets through
`cmd.exe` and has none of them, and a `help` target that works on Linux and dies on
Windows is worse than no `help` target.

In practice this means `help` is plain `@echo` lines rather than something clever that
parses `##` comments out of `$(MAKEFILE_LIST)`:

```make
.DEFAULT_GOAL := help

help:
	@echo "make test    Run the kitchen sink suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make shell   Open a shell in the container"
```

It repeats the target names. That is the cost of working everywhere, and it is six
lines.

## Base images

Verified against Docker Hub. **Official** means a Docker Official Image
(`docker.io/library/<name>`).

Rows name the image *family*. A template pins a narrower tag than the row shows —
`javascript` is on `node:26.13.1-trixie-slim`, not `node:26-trixie-slim` — per
[Pin the tag, never `latest`](#pin-the-tag-never-latest) below.

| Language               | Image                                        | Status      |
| ---------------------- | -------------------------------------------- | ----------- |
| javascript, typescript | `node:26-trixie-slim`                        | official    |
| python                 | `python:3.15-slim-trixie`                    | official    |
| go                     | `golang:1.27-trixie`                         | official    |
| rust                   | `rust:1.100-slim-trixie`                     | official    |
| ruby                   | `ruby:4.0-slim-trixie`                       | official    |
| elixir                 | `elixir:1.20-otp-29-slim`                    | official    |
| php                    | `php:8.6-cli-trixie` + `composer:2`          | official    |
| swift                  | `swift:6.4-trixie-slim`                      | official    |
| dart                   | `dart:3.14-sdk`                              | official    |
| c, cpp                 | `gcc:16-trixie`                              | official    |
| erlang                 | `erlang:29-slim`                             | official    |
| clojure                | `clojure:temurin-27-tools-deps-trixie`       | official    |
| haskell                | `haskell:9.14-slim-bookworm`                 | official    |
| prolog                 | `swipl:11.0`                                 | official    |
| kotlin, java           | `gradle:9.9-jdk25`                           | official    |
| nim                    | `nim:2.4`                                    | official    |
| fsharp, csharp         | `mcr.microsoft.com/dotnet/sdk:10.0`          | vendor      |
| ocaml                  | `ocaml/opam:debian-13-ocaml-5.6`             | vendor      |
| gleam                  | `ghcr.io/gleam-lang/gleam:v1.19-erlang-slim` | vendor      |
| lua                    | `debian:trixie-slim` + lua, luarocks         | hand-rolled |
| zig                    | `debian:trixie-slim` + release tarball       | hand-rolled |
| elm                    | `node:26-trixie-slim` + elm, elm-test        | hand-rolled |

Across 26 templates that is **19 official, 4 vendor, 3 hand-rolled**. The hand-rolled
set — zig, lua, elm — is the same three it was at 18 templates, because every language
added since builds on an official image and merely adds a package. Under mise, six
languages had no usable pin at all.

### One image, several templates

Five images cover eleven templates. This is deliberate; do not "tidy up" by giving each
language its own.

| Image                                 | Templates                   |
| ------------------------------------- | --------------------------- |
| `node:26-trixie-slim`                 | javascript, typescript, elm |
| `gradle:9.9-jdk25`                    | kotlin, java                |
| `mcr.microsoft.com/dotnet/sdk:10.0`   | fsharp, csharp              |
| `gcc:16-trixie`                       | c, cpp                      |
| `debian:trixie-slim`                  | zig, lua                    |

Sharing a base image does not mean sharing a template. Each still has its own
Dockerfile, Makefile and kitchen sink, because the image is the toolchain and the
template is the idiom.

### Images needing a package on top

Three cases, recorded here so they are not rediscovered per template:

- **php** — `php:8.6-cli-trixie` ships no Composer. Take it from the official image in a
  multi-stage copy rather than piping an installer script:
  `COPY --from=composer:2 /usr/bin/composer /usr/bin/composer`.
- **c, cpp** — `gcc:16-trixie` ships no `clang-format`; one `apt-get install`.
- **swift** — `swift format` became a toolchain subcommand in Swift 6.0. Confirm it is
  actually present in `swift:6.4-trixie-slim` before writing the lint task, and fall back to
  installing `swift-format` separately if not.

Every reference above was resolved against the registry on 2026-11-19, tags included.
`zig`, `lua` and `elm` returned `errors:` — no Docker Official Image exists for any of
them. That is the only reason they are hand-rolled, so **re-check before writing one**:

```console
$ docker search --filter is-official=true lua
```

Tags will go stale faster than the table. Treat the versions as the starting point they
were verified at, not as a standing claim about what is current.

### Pin the tag, never `latest`

The image tag is now the version pin. It is the only thing making a local run match CI,
so it does the job `mise.toml` used to:

```dockerfile
FROM node:26.13.1-trixie-slim
```

Not `node`, not `node:latest`, not `node:26`. A floating tag means a green suite can go
red with no commit in between.

## Caching is mandatory

With no native execution path, the TDD loop runs through a container every time. Source
is bind-mounted so edits need no rebuild; build artefacts go to named volumes so a
second `make test` does not redo the first one's work:

```yaml
services:
  dev:
    build: .
    working_dir: /work
    volumes:
      - .:/work
      - cache:/root/.cache
volumes:
  cache:
```

Per language, the volume targets the directory that actually holds the artefacts —
`node_modules`, `~/.cargo` and `target`, `_build`, `.stack-work`, `~/.m2`. Getting this
wrong is not a subtle performance problem: it is the difference between a two-second
loop and a ninety-second one.

Where the toolchain reads an environment variable for its cache location, point it
inside the volume rather than letting it write next to the source. Zig does this with
`ZIG_GLOBAL_CACHE_DIR` and `ZIG_LOCAL_CACHE_DIR`, which also keeps `.zig-cache` out of
the bind-mounted project.

**A named volume seeds from the image while it is still empty**, and for an immutable,
content-addressed cache that is a feature rather than the staleness trap it is for
`node_modules`. `zig` uses it: the Dockerfile runs a throwaway `zig init && zig build
test` so the compiled build runner is already in `/cache` when the volume is created.
Without it the first `make test` on any machine costs seventy seconds; with it, under
three.

**The check:** no run may repeat work an earlier one did.

For a compiled language that shows up directly — a second `make test` with no edits must
be materially faster than the first. For an interpreted one it does not, and should not be
made to: `javascript` measures flat at about a second a run, because the toolchain is
baked into the image and there is no build artefact to cache. Run one is already as fast
as run N, which is the stronger result. The failure this check is really looking for is a
template that reinstalls its dependencies on every run.

Either way it is part of the definition of done for every template.

## Lock files land in the project, not the cache

Several toolchains write a lock or generated manifest into the **project root** on first
build — `Cargo.lock`, `package-lock.json`, `Gemfile.lock`, `pubspec.lock`, `mix.lock`,
`composer.lock`, `packages.lock.json`, `cabal.project.freeze`. Redirecting the build
directory does not stop it, so the generated project is dirty the moment the bootstrap runs
its own first `make test`, and the committed scaffold stops matching the working tree.

Two fixes, in order of preference:

1. **Install dependencies outside the project entirely**, so no lock is written there.
   `javascript` does this: `npm install` runs in `/deps` and the result moves to
   `/node_modules`.
2. **Ship a pre-generated, tokenised lock file** in `files/`, so the first build finds one
   that already matches. `rust` does this with a two-line `Cargo.lock` whose `name` is
   `{{PROJECT_SLUG}}`.

Gitignoring it is a last resort rather than a fix: it hides a file the toolchain keeps
rewriting, and for a template whose point is a reproducible toolchain that is the wrong
trade. The check either way is that `git status --porcelain` in the generated project is
empty after `make test`.

## File ownership

Bind mounts on Linux write root-owned files unless the container runs as the calling
user, which leaves a project the user cannot edit without `sudo`. The service declares:

```yaml
    user: "${DOCKER_UID:-1000}:${DOCKER_GID:-1000}"
```

The values come from a generated `.env`, which Compose loads automatically from the
project directory. `bootstrap.sh` writes it with the real values on macOS and Linux; `bootstrap.ps1` omits
it, since Docker Desktop handles ownership itself and the defaults are never used there.
`bootstrap.sh` running under Git Bash omits it for the same reason, and for one more:
`$UID` there is a Windows RID that means nothing to a Linux container, so writing it would
leave the container running as an unknown uid whose `$HOME` resolves to `/`.

```sh
DOCKER_UID=1000
DOCKER_GID=1000
```

`.env` is generated, not templated, and is listed in the project's `.gitignore` — it
describes the machine, not the project. This keeps the Makefile free of `$(shell id -u)`,
which would break on Windows for the reason given above.

### Seed directories, never files

The service runs as the host's uid, and that uid is **not** 1000 everywhere — CI's runner
is 1001. A template that bakes files into its cache volume owned by a uid it guessed works
on the machine it was written on and fails everywhere else.

`dart` shipped exactly this bug. Its Dockerfile chowned `.dart_tool` to `1000:1000`, and
`dart pub` refreshes `package_config.json` by setting its mtime — which Linux permits only
to the file's *owner*, not merely to anyone with write permission. Every other uid got
`EPERM`, so it passed locally on Windows, where no `.env` is written and 1000 is the
default, and would have failed CI on the first push.

The rule that falls out: **`chmod 777` an empty directory in the image and let the first
run create the files**, so they are owned by whoever is running. Never `chown` to a
specific uid, and never assume `chmod 777` is enough for an operation that checks
ownership.

One consequence worth knowing, which is not a bug to fix: a cache volume populated by one
uid will refuse a *different* uid later, because the subdirectories the toolchain created
belong to the first one. Per machine the uid is stable, so this only shows up if
`DOCKER_UID` changes under an existing project. The fix is `docker compose down -v`, and it
is generic to every template rather than specific to any.

## `.dockerignore`

Every template ships one. At minimum `.git`, the build output directory, and `.env`, so
the build context stays small and a rebuild is not triggered by an unrelated file.

## Registry rate limits

Docker Hub rate-limits anonymous pulls, and the limit is low enough to hit in normal
use — writing this document exhausted it after three `docker manifest inspect` calls,
before `docker login` cleared it. Two places it matters:

- **CI** runs 26 image pulls per workflow from shared runner IPs. Authenticate with
  `docker/login-action` before any build, and use layer caching so most runs pull
  nothing. See [ci.md](ci.md).
- **First run on a developer machine** can fail with `toomanyrequests` through no fault
  of the project. The bootstrap's exit `4` message names this as a likely cause rather
  than reporting a generic build failure — a user who has just run one command deserves
  to be told the registry rate-limited them, not that "the image build failed".
