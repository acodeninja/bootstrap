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

| Language               | Image                                    | Status      |
| ---------------------- | ---------------------------------------- | ----------- |
| javascript, typescript | `node:24-bookworm-slim`                  | official    |
| python                 | `python:3.13-slim`                       | official    |
| go                     | `golang:1.23-bookworm`                   | official    |
| rust                   | `rust:1.83-slim`                         | official    |
| ruby                   | `ruby:3.3-slim`                          | official    |
| elixir                 | `elixir:1.17-otp-27`                     | official    |
| php                    | `php:8.3-cli` + `composer:2`             | official    |
| swift                  | `swift:6.0`                              | official    |
| dart                   | `dart:3.5`                               | official    |
| c, cpp                 | `gcc:14`                                 | official    |
| erlang                 | `erlang:27-slim`                         | official    |
| clojure                | `clojure:temurin-21-tools-deps`          | official    |
| haskell                | `haskell:9.6.6`                          | official    |
| prolog                 | `swipl:9.2.9`                            | official    |
| kotlin, java           | `gradle:8.10-jdk21`                      | official    |
| nim                    | `nim:2.2.0`                              | official    |
| fsharp, csharp         | `mcr.microsoft.com/dotnet/sdk:9.0`       | vendor      |
| ocaml                  | `ocaml/opam:debian-12`                   | vendor      |
| gleam                  | `ghcr.io/gleam-lang/gleam:v1.9.1-erlang` | vendor      |
| lua                    | `debian:bookworm-slim` + lua, luarocks   | hand-rolled |
| zig                    | `debian:bookworm-slim` + release tarball | hand-rolled |
| elm                    | `node:24-bookworm-slim` + elm, elm-test  | hand-rolled |

Across 26 templates that is **19 official, 4 vendor, 3 hand-rolled**. The hand-rolled
set — zig, lua, elm — is the same three it was at 18 templates, because every language
added since builds on an official image and merely adds a package. Under mise, six
languages had no usable pin at all.

### One image, several templates

Five images cover eleven templates. This is deliberate; do not "tidy up" by giving each
language its own.

| Image                              | Templates                   |
| ---------------------------------- | --------------------------- |
| `node:24-bookworm-slim`            | javascript, typescript, elm |
| `gradle:8.10-jdk21`                | kotlin, java                |
| `mcr.microsoft.com/dotnet/sdk:9.0` | fsharp, csharp              |
| `gcc:14`                           | c, cpp                      |
| `debian:bookworm-slim`             | zig, lua                    |

Sharing a base image does not mean sharing a template. Each still has its own
Dockerfile, Makefile and kitchen sink, because the image is the toolchain and the
template is the idiom.

### Images needing a package on top

Three cases, recorded here so they are not rediscovered per template:

- **php** — `php:8.3-cli` ships no Composer. Take it from the official image in a
  multi-stage copy rather than piping an installer script:
  `COPY --from=composer:2 /usr/bin/composer /usr/bin/composer`.
- **c, cpp** — `gcc:14` ships no `clang-format`; one `apt-get install`.
- **swift** — `swift format` became a toolchain subcommand in Swift 6.0. Confirm it is
  actually present in `swift:6.0` before writing the lint task, and fall back to
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
FROM node:24.11-bookworm-slim
```

Not `node`, not `node:latest`, not `node:24`. A floating tag means a green suite can go
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
`node_modules`, `~/.cargo` and `target`, `_build`, `zig-cache`, `.stack-work`,
`~/.m2`. Getting this wrong is not a subtle performance problem: it is the difference
between a two-second loop and a ninety-second one.

**The check:** a second `make test` with no edits must be materially faster than the
first. It is part of the definition of done for every template.

## File ownership

Bind mounts on Linux write root-owned files unless the container runs as the calling
user, which leaves a project the user cannot edit without `sudo`. The service declares:

```yaml
    user: "${DOCKER_UID:-1000}:${DOCKER_GID:-1000}"
```

The values come from a generated `.env`, which Compose loads automatically from the
project directory. `bootstrap.sh` writes it with the real values; `bootstrap.ps1` omits
it, since Docker Desktop handles ownership itself and the defaults are never used there.

```sh
DOCKER_UID=1000
DOCKER_GID=1000
```

`.env` is generated, not templated, and is listed in the project's `.gitignore` — it
describes the machine, not the project. This keeps the Makefile free of `$(shell id -u)`,
which would break on Windows for the reason given above.

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
