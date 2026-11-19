# Template contract

A template is a directory under `templates/`. The directory name is the template ID.
Adding language number 27 means satisfying this contract and nothing else — no
registry to update, no script to edit, no case statement to extend.

## Layout

```
templates/<id>/
  template.env      manifest: one key
  files/            copied into the target, with tokens substituted
```

`files/` is copied wholesale. Anything you want in the generated project goes there,
including dotfiles. Nothing outside `files/` is copied.

There is no per-template `INSTALL.md`. The prerequisites are Docker and make for every
template, so there is nothing per-language left to say — see [containers.md](containers.md).

## `template.env`

Flat `KEY=value`, double-quoted. Bash sources it; PowerShell splits it on the first `=`.
One key:

```sh
DISPLAY_NAME="Zig"
```

| Key            | Meaning                                                       |
| -------------- | ------------------------------------------------------------- |
| `DISPLAY_NAME` | Human label, shown by `--list` and in the `==> template` line |

It had four keys until containers replaced mise. `TOOLCHAIN_TIER` and `PREFLIGHT_BIN`
died with the tier system; `PLATFORMS` died because the container is Linux regardless of
host. The file survives because `--list` still needs a label and because a manifest is
the obvious place for the next thing that varies per template.

Everything else a template needs to say, it says in its `Dockerfile` and `Makefile`.
There is deliberately no `TEST_CMD`: the test command is `make test` in every template,
and that uniformity is a feature of the tool, so it is a contract rather than a
configurable.

## `files/` requirements

Every template's `files/` must contain:

| Path                       | Purpose                                                            |
| -------------------------- | ------------------------------------------------------------------ |
| `Dockerfile`               | `FROM` a pinned image, dependencies installed, `WORKDIR /work`     |
| `compose.yaml`             | the `dev` service: bind mount, cache volumes, `user`               |
| `Makefile`                 | `test`, `lint`, `fmt`, `build`, `shell`, `help`                    |
| `.dockerignore`            | `.git`, build output, `.env`                                       |
| `README.md`                | What this is, how to run it, the prerequisites                     |
| `KITCHEN-SINK.md`          | What the kitchen sink is, and the kata list to apply it to         |
| `kitchen-sink/`            | The ten themed test files — see [kitchen-sink.md](kitchen-sink.md) |
| `.gitignore`               | Build artefacts for this language, plus `.env`                     |
| `.editorconfig`            | Indentation and line endings matching the language's convention    |
| `LICENSE`                  | MIT, with `{{AUTHOR}}` and `{{YEAR}}` substituted                  |
| `.github/workflows/ci.yml` | `docker compose build`, then `make lint` and `make test`           |
| `vendor/`                  | Optional — third-party source, where there is no alternative       |

`.env` is **not** in `files/`. The bootstrap script generates it — see
[containers.md](containers.md#file-ownership).

### The Makefile targets

All six, in every template, even where two are the same command:

| Target  | Must                                                           |
| ------- | -------------------------------------------------------------- |
| `test`  | Run the kitchen sink suite                                     |
| `lint`  | Be non-mutating, and exit non-zero on a violation — CI runs it |
| `fmt`   | Reformat in place                                              |
| `build` | Compile, or be a documented no-op for interpreted languages    |
| `shell` | Drop into an interactive shell in the container                |
| `help`  | List the targets; the default goal                             |

A language with no separate linter uses its formatter in check mode for `lint`.

Targets must not call host shell tools beyond `docker` — no `grep`, `awk`, `sed` or
`id`. Windows `make` runs through `cmd.exe` and has none of them. The reasoning and the
`help` pattern that follows from it are in [containers.md](containers.md#the-makefile-may-not-use-host-shell-tools).

## Vendored code

Test runners are chosen stdlib-first. Two languages have no stdlib runner and no package
manager worth adding one through: `c` vendors **Unity**, `cpp` vendors **doctest**. They
are currently the only templates that do this, and the bar for a third is high — reach
for the language's package manager first, every time.

Where it is unavoidable:

- **It lives in `vendor/`, and nothing else does.** One directory, obvious to delete,
  obvious to update.
- **Pin the version** in a comment at the top of each vendored file, with the upstream
  URL. A vendored file of unknown provenance is worse than a dependency.
- **Exclude it from `make lint` and `make fmt`.** It is not our code; reformatting it
  turns the next upstream update into a merge conflict for no benefit.
- **Attribute the licence.** Unity and doctest are both MIT, which sits fine inside an
  MIT project — but the generated `README.md` must say what is vendored and under what
  terms. A `LICENSE` that silently appears to cover someone else's code is the thing to
  avoid, and it costs two lines to avoid it.

## Token substitution

A closed set of five tokens, replaced by literal string substitution in **file contents
and in file and directory names**:

| Token               | Value                                              | Example    |
| ------------------- | -------------------------------------------------- | ---------- |
| `{{PROJECT_NAME}}`  | `--name`, or the target dir basename               | `My Zig`   |
| `{{PROJECT_SLUG}}`  | lowercased, non-alphanumeric runs collapsed to `-` | `my-zig`   |
| `{{PROJECT_SNAKE}}` | lowercased, non-alphanumeric runs collapsed to `_` | `my_zig`   |
| `{{AUTHOR}}`        | `git config user.name`, else `Your Name`           | `Lawrence` |
| `{{YEAR}}`          | current year                                       | `2026`     |

`PROJECT_SNAKE` exists because Python, Erlang, Gleam and Nim module names cannot contain
a hyphen. Use the slug for package names and URLs, the snake for module and file names.

**There is no templating engine, and there will not be one.** No conditionals, no loops,
no partials. If a template needs logic, it needs to be two templates. This is the
constraint that keeps `bootstrap.sh` short enough to be obviously correct.

Substitution is applied to every file in `files/`. Binary files are not expected; if one
is ever needed, the contract gains an exclusion list and not before.

## Adding a template

1. `mkdir -p templates/<id>/files`.
2. Write `template.env` — one line.
3. Pick the base image. Check for an official one first:
   `docker search --filter is-official=true <lang>`. See [containers.md](containers.md#base-images).
4. Write the `Dockerfile` with a pinned tag, and `compose.yaml` with cache volumes
   targeting the directories this toolchain actually writes to.
5. Build `files/` by hand, as a real working project. Write it in the target directory
   first, get `make test` green, *then* copy it into `files/` and tokenise.
6. Write all ten `kitchen-sink/` files against [kitchen-sink.md](kitchen-sink.md), using
   the language's real idiom rather than a port of another template's.
7. Write `KITCHEN-SINK.md`, and confirm `rm -r kitchen-sink KITCHEN-SINK.md` leaves a
   project that still builds and passes.
8. Add the row to [languages.md](languages.md).
9. `./bootstrap.sh <id> /tmp/check` from a cold image and confirm `make test` is green.
10. Run `make test` a second time. It must be materially faster — if it isn't, the cache
    volumes are pointed at the wrong directory.
11. Confirm `--dry-run` lists what you expect and that no `{{TOKEN}}` survives:
    `grep -r '{{' /tmp/check` must find nothing.
12. One commit: `feat: add <id> template`.
