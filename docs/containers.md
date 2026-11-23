# Containers

Every generated project runs its toolchain inside Docker. The host needs **Docker** and
**make**, and that answer is the same for all 64 templates.

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

In practice this means `help` is a list of literal lines rather than something clever
that parses `##` comments out of `$(MAKEFILE_LIST)`.

`@echo` is not safe enough either, which took a while to notice. `cmd.exe` does not
strip the quotes `sh` needs around a run of spaces, so it printed them —
`"make test    Run the kitchen sink suite"`. Dropping the quotes fixes Windows and
breaks the alignment on Linux, where the shell collapses the run instead. `$(info)` is
make's own and reaches the text without a shell at all, so both print the same thing:

```make
.DEFAULT_GOAL := help

help:
	$(info make test    Run the kitchen sink suite)
	$(info make lint    Check formatting)
	$(info make fmt     Reformat in place)
	$(info make shell   Open a shell in the container)
	@cd .
```

`@cd .` is a no-op in either shell and is there for one reason: a recipe of nothing but
`$(info)` runs no command, and make then prints "Nothing to be done for 'help'" under
the text it just gave you.

It repeats the target names. That is the cost of working everywhere, and it is seven
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
| swift                  | `swift:6.4-trixie`                      | official    |
| dart                   | `dart:3.14-sdk`                              | official    |
| c, cpp                 | `gcc:16-trixie`                              | official    |
| erlang                 | `erlang:29-slim`                             | official    |
| clojure                | `clojure:temurin-25-tools-deps-trixie-slim`  | official    |
| haskell                | `haskell:9.14-slim-bookworm`                 | official    |
| prolog                 | `swipl:11.0`                                 | official    |
| kotlin, java, groovy   | `gradle:9.9-jdk25`                           | official    |
| nim                    | `nim:2.2`                                    | official    |
| julia                  | `julia:1.13-trixie`                          | official    |
| flix                   | `eclipse-temurin:25-jdk-noble` + flix 0.80   | official    |
| haxe                   | `haxe:4.3-trixie` + utest, formatter         | official    |
| raku                   | `rakudo-star:2026.09-trixie`                 | official    |
| perl                   | `perl:5.44-slim-trixie` + 2 CPAN tools       | official    |
| fortran                | `gcc:16-trixie` + fpm 0.14                   | official    |
| fsharp, csharp, visualbasic | `mcr.microsoft.com/dotnet/sdk:10.0`     | vendor      |
| ocaml                  | `ocaml/opam:debian-13-ocaml-5.5`             | vendor      |
| gleam                  | `ghcr.io/gleam-lang/gleam:v1.19-erlang-slim` | vendor      |
| lua                    | `debian:trixie-slim` + lua, luarocks         | hand-rolled |
| zig                    | `debian:trixie-slim` + release tarball       | hand-rolled |
| elm                    | `node:26-trixie-slim` + elm, elm-test        | hand-rolled |
| pascal                 | `debian:trixie-slim` + fpc 3.2.2             | hand-rolled |
| cobol                  | `debian:trixie-slim` + GnuCOBOL 3.2          | hand-rolled |
| basic                  | `debian:trixie-slim` + bwbasic 2.20          | hand-rolled |
| lolcode                | `debian:trixie-slim` + lci 1.3 from source   | hand-rolled |
| intercal               | `debian:trixie-slim` + C-INTERCAL 0.30       | hand-rolled |
| r                      | `debian:trixie-slim` + R 4.5, 3 r-cran pkgs  | hand-rolled |
| ada                    | `debian:trixie-slim` + GNAT 14, AUnit        | hand-rolled |
| forth                  | `debian:bookworm-slim` + gforth 0.7.3        | hand-rolled |
| arm32                  | `debian:trixie-slim` + binutils, qemu-arm    | hand-rolled |
| d                      | `debian:trixie-slim` + LDC 1.40, dub 1.40    | hand-rolled |
| objc                   | `debian:trixie-slim` + gobjc, GNUstep Base   | hand-rolled |
| asp                    | `debian:trixie-slim` + clingo 5.6            | hand-rolled |
| ats                    | `debian:trixie-slim` + ATS2 0.4.2            | hand-rolled |
| commonlisp             | `debian:trixie-slim` + SBCL 2.5, cl-fiveam   | hand-rolled |
| koka                   | `debian:trixie-slim` + Koka 3.2              | hand-rolled |
| lean                   | `debian:trixie-slim` + Lean 4.36             | hand-rolled |
| mercury                | `debian:trixie-slim` + Mercury 22.01 source  | hand-rolled |
| tcl                    | `debian:trixie-slim` + tcl 8.6.16            | hand-rolled |
| sql                    | `debian:trixie-slim` + sqlite3 3.46, sqlfluff | hand-rolled |
| scheme                 | `debian:trixie-slim` + Guile 3.0.10          | hand-rolled |
| racket                 | `debian:trixie-slim` + Racket 8.16           | hand-rolled |
| scala                  | `eclipse-temurin:25-jdk-noble` + scala-cli 1.19 | official    |
| qsharp                 | `python:3.15-slim-trixie` + QDK 1.34          | official    |
| pony                   | `debian:trixie-slim` + ponyc 0.78.2           | hand-rolled |
| bqn                    | `debian:trixie-slim` + CBQN 0.12.0 source     | hand-rolled |
| befunge                | `debian:trixie-slim` + cfunge 1,001 source    | hand-rolled |
| smalltalk              | `debian:trixie-slim` + GNU Smalltalk 3.2.5 source | hand-rolled |
| bash                   | `debian:trixie-slim` + bats, shellcheck, shfmt | hand-rolled |
| powershell             | `debian:trixie-slim` + PowerShell 7.7.0 tarball | hand-rolled |
| octave                 | `debian:trixie-slim` + Octave 9.4, MISS_HIT  | hand-rolled |

Across 64 templates that is **28 official, 5 vendor, 31 hand-rolled**. Hand-rolled held
at three — zig, lua and elm — from 18 templates to 26, because every language added in
between built on an official image and merely added a package. Wave 4 added nine, wave 5
eight and wave 6 eight, which are the languages with no official image to build on at
all. Wave 7 added three more: `bash` and `octave` because Debian carries the whole
toolchain and no vendor publishes an image for either, and `powershell` because the one
Microsoft publishes has no arm64. Under mise, six languages had no usable pin.

### One image, several templates

Seven images cover forty-five templates. This is deliberate; do not "tidy up" by giving
each language its own.

| Image                                 | Templates                                                         |
| ------------------------------------- | ----------------------------------------------------------------- |
| `node:26-trixie-slim`                 | javascript, typescript, elm                                       |
| `gradle:9.9-jdk25`                    | kotlin, java, groovy                                              |
| `mcr.microsoft.com/dotnet/sdk:10.0`   | fsharp, csharp, visualbasic                                       |
| `gcc:16-trixie`                       | c, cpp, fortran                                                   |
| `debian:trixie-slim`                  | zig, lua, pascal, cobol, basic, lolcode, intercal, r, ada, arm32, d, objc, asp, ats, commonlisp, koka, lean, mercury, tcl, sql, scheme, racket, pony, bqn, befunge, smalltalk, bash, powershell, octave |
| `eclipse-temurin:25-jdk-noble`        | flix, scala                                                       |
| `python:3.15-slim-trixie`             | python, qsharp                                                    |

Sharing a base image does not mean sharing a template. Each still has its own
Dockerfile, Makefile and kitchen sink, because the image is the toolchain and the
template is the idiom.

### Images needing a package on top

Five cases, recorded here so they are not rediscovered per template:

- **php** — `php:8.6-cli-trixie` ships no Composer. Take it from the official image in a
  multi-stage copy rather than piping an installer script:
  `COPY --from=composer:2 /usr/bin/composer /usr/bin/composer`.
- **c, cpp** — `gcc:16-trixie` ships no `clang-format`; one `apt-get install`.
- **fortran** — the same `gcc:16-trixie`, which carries `gfortran` but neither a package
  manager nor a formatter. fpm comes from its release binary, per architecture, and
  fprettify from PyPI, which costs a `python3-pip` install for one tool.
- **perl** — `perl:5.44-slim-trixie` has `cpanm` but no compiler, and Perl::Critic's
  dependency tree reaches two XS modules. Build it in a stage that installs `gcc`, then
  copy `/usr/local/lib/perl5` out: one old dual-life dependency installs into the core
  library path rather than `site_perl`, so copying only the latter leaves it behind.
- **swift** — `swift format` is a toolchain subcommand since Swift 6.0, and it **is**
  present in `swift:6.4-trixie`, reporting the compiler's own version, with
  `/usr/bin/swift-format` alongside it. No separate install is needed. Use the full image:
  the `-slim` tags are runtime-only and carry no `swift` binary at all.

Every reference above was resolved against the registry on 2026-11-19, tags included, and
each wave 4 row on the day it landed. None of `zig`, `lua`, `elm`, `pascal`, `cobol`,
`basic`, `lolcode`, `intercal`, `ada`, `octave` or `powershell` has a Docker Official
Image at all — Microsoft's `powershell` image is a vendor one, and has no arm64. `r` and
`bash` each have one and do not use it, for the reasons their rows give. Either way,
**re-check before writing one**:

```console
$ docker search --filter is-official=true lua
```

Tags will go stale faster than the table. Treat the versions as the starting point they
were verified at, not as a standing claim about what is current.

### Debian variants, and the four exceptions

Where an image publishes several OS variants, take the **Debian** one — `-slim` or
`-trixie-slim` where published, the plain Debian tag otherwise. Alpine was considered and
rejected: it is unavailable for seven of the languages here, it is not reliably smaller
(`rust:1.100.0-alpine3.24` is *larger* than `rust:1.100.0-slim`), and musl costs
correctness — Python on Alpine loses manylinux wheels. The measured saving across the rows
that could use it was about 400 MB compressed, against a build cache that routinely holds
ten times that.

Four rows cannot follow the rule:

- **`haskell`** publishes no `slim-trixie`, so it pins `9.14.1-slim-bookworm`. Re-check
  when touching it.
- **`forth`** is on `debian:bookworm-20261104-slim` because gforth is not in trixie: it
  was dropped before the release and is back in testing. Same datestamp as every other
  Debian base here, one generation back. Re-check when trixie or forky carries it again.
- **`fsharp`, `csharp` and `visualbasic`** are on `mcr.microsoft.com/dotnet/sdk`, which is
  **Ubuntu 24.04**. Microsoft publishes no Debian default tag for the 10.0 SDK, so there is
  nothing to switch to.
- **`swift`** must use the *full* `swift:<ver>-trixie` image. Its `-slim` tags are
  runtime-only and carry no `swift` binary at all, so applying the `-slim` preference here
  produces an image that cannot compile anything.

### Pin the tag, never `latest`

The image tag is now the version pin. It is the only thing making a local run match CI,
so it does the job `mise.toml` used to:

```dockerfile
FROM node:26.13.1-trixie-slim
```

Not `node`, not `node:latest`, not `node:26`. A floating tag means a green suite can go
red with no commit in between.

A pin nobody updates is not reproducible either, it is just old. Dependabot moves the
`FROM` lines and the workflow actions, `pins.yml` reports the `ARG *_VERSION` pins it
cannot see, and `actions-lock.yml` re-resolves the lockfiles nightly — see
[ci.md](ci.md#keeping-the-pins-current).

### Published images are a cache, not the pin

Every template's image is built and pushed to
`ghcr.io/acodeninja/bootstrap/<template-id>:main` for `amd64` and `arm64` whenever a push
to `main` changes a template and that template's tests pass, and again every Monday so
the cache tracks upstream — see [ci.md](ci.md). The weekly run means a tag can move with
no commit behind it, which is the sense in which these are a cache: the `Dockerfile` is
the authority on versions, not the registry.

`compose.yaml` names it twice, once to run it and once to build from it:

```yaml
services:
  dev:
    build:
      context: .
      cache_from:
        - ghcr.io/acodeninja/bootstrap/python:main
      cache_to:
        - type=inline
    image: ghcr.io/acodeninja/bootstrap/python:main
```

`image` and `build` together are what make the two paths interchangeable: `docker compose
pull` fetches it, and `docker compose build` tags a local build with the same name. The
bootstrap tries the pull first and falls back to the build, which turns a first run from a
toolchain compile into a download. The registry is public, so the pull needs no credentials.

`cache_from` makes that same image a *layer* cache for the builds that must not use it as a
substitute. CI builds with `--no-pull` on purpose: the point of that job is the `Dockerfile`,
and running the previous commit's toolchain against this commit's templates would let a
broken one go green. Reusing layers is not that. Buildkit matches a layer only when the
instruction and its inputs are identical, so an edit rebuilds from the edit down.

`cache_to: type=inline` is the half that is easy to leave out. It records the layer manifest
inside the image, which is what makes the pushed `:main` importable as a cache at all;
without it `cache_from` resolves to nothing and caches nothing, quietly. A ref that does not
resolve — a template whose image has never been pushed, a machine with no network — is a
warning rather than an error, which is what makes shipping this in every template safe.

What no cache can do is prove that a build from nothing still works. `--no-cache` is for
that, and the runs that build everything pass it: the Monday schedule and a manual
dispatch.

**The `Dockerfile` is still the pin and still the authority.** Nothing downstream
depends on the package existing: a template with no image yet, an architecture that was
never published, a machine with no network, all degrade to building locally. `--no-pull`
forces that path.

One consequence worth knowing: the tag names the *template*, not the project. Two
projects scaffolded from the same template share it locally, so editing one project's
`Dockerfile` and rebuilding changes the image the other one runs until it builds too.
Project-scoped tags would avoid that but cannot be pulled, since the published name has
to be predictable.

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

Where the toolchain hard-codes a **project-relative** cache path and offers no flag at all,
mount a second named volume *inside* the bind mount. `clojure` needs this: the CLI writes
`./.cpcache` whenever a project `deps.edn` exists and the directory is writable, and
`CLJ_CACHE` is only the fallback for when it cannot — so there is nothing to redirect.

```yaml
    volumes:
      - .:/work
      - cache:/cache
      - cpcache:/work/.cpcache
```

The host is left an empty directory at the mount point, which git does not track, so the
clean-project check passes without gitignoring anything. Reach for this only after
confirming no environment variable or flag exists — it is the least obvious of the three
remedies and the only one that leaves a visible artefact in the user's project. Five
templates need it: `clojure` for `.cpcache`, `gleam` and `fortran` for `build/`, `dart`
for `.dart_tool`, and `elm` for `elm-stuff`.

Where the toolchain reads an environment variable for its cache location, point it
inside the volume rather than letting it write next to the source. Zig does this with
`ZIG_GLOBAL_CACHE_DIR` and `ZIG_LOCAL_CACHE_DIR`, which also keeps `.zig-cache` out of
the bind-mounted project.

**A named volume seeds from the image while it is still empty**, and for an immutable,
content-addressed cache that is a feature rather than the staleness trap it is for
`node_modules`. `zig` uses it: the Dockerfile compiles the project's own build runner so
it is already in `/cache` when the volume is created. That takes the first `make test`
from seventy-two seconds to three — on a machine that built the image itself, which is
not the machine most people are on. See the second rule below.

**Prime what the project will actually ask for.** A content-addressed cache answers only
for the inputs it was filled with, so a prime built from a throwaway project can be an
image layer nothing ever reads. `zig` shipped exactly that for a while: it primed
`zig init`'s build script, the volume seeded from the image correctly, and the first
`make test` still paid its full seventy-two seconds, because the runner it wanted was
compiled from a different `build.zig`. Nothing anywhere reports a miss. The only check is
the first run against the second.

**And prime work that is not about the machine priming it.** The published image is built
on a GitHub runner and run on a developer's laptop, so a cache entry keyed to anything
about the builder cannot be read by the consumer. `zig` cannot win this one: its build
runner has to execute on the host, so it is compiled for the native target, the target is
part of the key, and a runner compiled for a GitHub runner's CPU is unreachable from a
`znver5` laptop — measured, the primed image and no prime at all cost the same 73s.
Dependency downloads, package indexes and bytecode are machine-independent and travel
fine. Compiled native artefacts do not.

**The check:** no run may repeat work an earlier one did.

For a compiled language that shows up directly — a second `make test` with no edits must
be materially faster than the first. For an interpreted one it does not, and should not be
made to: `javascript` measures flat at about a second a run, because the toolchain is
baked into the image and there is no build artefact to cache. Run one is already as fast
as run N, which is the stronger result. The failure this check is really looking for is a
template that reinstalls its dependencies on every run.

Either way it is part of the definition of done for every template.

### What the first run still costs

Measured on the first twenty-six against a pulled image and a fresh volume — the path a
developer actually takes — timing `make test` twice:

| Template | first | second |
| -------- | ----- | ------ |
| zig      | 73.2s | 0.9s   |
| kotlin   | 19.8s | 7.0s   |
| java     | 10.0s | 5.8s   |
| cpp      |  9.5s | 0.9s   |
| haskell  |  7.9s | 1.5s   |
| dart     |  7.1s | 1.5s   |
| csharp   |  5.6s | 2.7s   |
| fsharp   |  5.1s | 2.6s   |
| swift    |  4.6s | 1.9s   |

The other seventeen sit within a second of each other, on a floor of about 0.9s of
container startup.

Two of these gaps have been traced. `zig`'s is the one rule above, and it is the only
entry here that is *not* the project's own work: 71 of those seconds are `std.Build`, and
they are paid because a native artefact cannot cross machines. Built locally the same
template measures 3.0s. `kotlin`'s is three seconds of build-script compilation, which
Gradle caches against the script's contents while `settings.gradle.kts` carries the
project name — so the primed copy is never the one asked for, and keeping the name is
worth three seconds. Its other nine seconds are the project's own first Kotlin compile,
which lands in `/cache/build`; seeding that from the image would mean shipping a foreign
project's outputs at root ownership — see
[seed directories, never files](#seed-directories-never-files).

The rest are untraced, and `cpp` is the one with an obvious lead: its 8.6s is compiling
vendored doctest, byte-identical in every generated project. Priming it needs a compiler
cache rather than a warm directory, because make decides by mtime and a scaffolded file
is always newer than an image layer.

## Lock files land in the project, not the cache

Several toolchains write a lock or generated manifest into the **project root** on first
build — `Cargo.lock`, `package-lock.json`, `Gemfile.lock`, `pubspec.lock`, `mix.lock`,
`composer.lock`, `packages.lock.json`, `cabal.project.freeze`. Redirecting the build
directory does not stop it, so the generated project is dirty the moment the bootstrap runs
its own first `make test`, and the committed scaffold stops matching the working tree.

Three fixes, in order of preference:

1. **Install dependencies outside the project entirely**, so no lock is written there.
   `javascript` does this: `npm install` runs in `/deps` and the result moves to
   `/node_modules`.
2. **Redirect the lock file itself**, where the build tool has an option for it. `elixir`
   does this: `mix.exs` sets `lockfile: "/cache/mix.lock"`, so the lock lives in the cache
   volume beside everything else it writes.
3. **Ship a pre-generated, tokenised lock file** in `files/`, so the first build finds one
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

- **This repository's CI** builds from shared runner IPs — two images per changed
  template, one per architecture, and all 128 of them on the weekly run — and
  `--no-pull` means it really does build them. Authenticate with `docker/login-action`
  before any build. See [ci.md](ci.md).
- **First run on a developer machine** now pulls from ghcr, which has no such limit, so
  the common case never touches Docker Hub at all. It can still happen when the pull
  falls through to a build. The bootstrap's exit `4` message names `toomanyrequests` as
  a likely cause rather than reporting a generic build failure — a user who has just run
  one command deserves to be told the registry rate-limited them, not that "the image
  build failed".
- **A generated project's CI** builds its own `Dockerfile`, because that is the thing it
  exists to test, so it does reach Docker Hub for the base image. Its
  `docker/login-action` step is therefore kept, but guarded on the secret being set:
  projects that never hit the limit need no setup, and projects that do have somewhere
  to put credentials.
