# Overview

## The problem

Starting a project in a language you don't write every day costs an afternoon before
you write a line of real code: install the compiler, find the version manager, guess
the layout, pick a test runner, wire a formatter, write a CI workflow. By the time the
first test runs, the thing you actually wanted to try is cold.

`bootstrap` collapses that to one command, for any of its supported languages, with the
same shape of answer every time.

## Goals

- **A passing test in under a minute**, from a machine that has none of the toolchain.
- **Nothing to install, including this.** One line off the internet scaffolds a project;
  there is no clone, no package to add, and nothing left on the machine afterwards. The
  toolchain lives in a container too — you do not install Zig to try Zig, and you do not
  end up with four Node versions on your laptop.
- **One set of commands across every language.** `make test`, `make lint`, `make fmt`
  mean the same thing in all 28 templates. You should not have to remember whether this
  one is `rebar3 eunit` or `dune test`.
- **Idiomatic, not lowest-common-denominator.** The shipped code demonstrates how the
  language actually handles errors, iteration and tests — see [kitchen-sink.md](kitchen-sink.md).
- **The same toolchain everywhere.** The container is Linux whatever the host is, so a
  green suite on your machine means a green suite on mine.

## Non-goals

- **No runtime dependency.** The generated project does not call back into this repo,
  vendor it, or track it. There is no update channel and nothing to eject from. If you
  want the newer template, bootstrap a fresh project and copy what you want across.
- **No scaffolding DSL.** No plugin API, no hooks, no templating engine. Templates are
  directories of real files with a handful of tokens substituted.
- **Not an app framework.** The first cut is languages. Frameworks come later as
  additional template IDs, not as a different mechanism.
- **No native execution path.** Everything runs in the container, deliberately. There is
  no `make test-local` that uses a toolchain you happen to have — one way to run things
  means one way for them to break. The cost is that every red/green loop pays container
  startup, which is why [caching](containers.md#caching-is-mandatory) is a contract
  requirement.

## Prerequisites

The same for every template:

- **Docker**, with the daemon running. Supplies every language toolchain.
- **make**. Present on macOS and most Linux installs; on Windows,
  `winget install ezwinports.make`.
- **git**, for the generated project's first commit.

Remote mode also uses `curl` and `tar` on POSIX, or PowerShell 5.1 on Windows — all
in-box. See [install.md](install.md).

## What happens when you run it

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh)" -- zig ../my-zig
```

or, from a clone, `./bootstrap.sh zig ../my-zig` — the same steps either way.

0. **Find the templates.** In a clone they are beside the script. Run off the internet,
   the script has no path on disk, so it downloads one archive of the repo at its own
   pinned ref into a temp directory and deletes it on the way out. A failure here exits
   `6`, before the target directory is touched. See [install.md](install.md).
1. **Resolve the template.** Look up `templates/zig/`. Unknown ID exits `2` and prints
   the list of valid IDs — never a bare "not found".
2. **Check the target.** Create `../my-zig` if missing. If it exists and is non-empty,
   exit `3` unless `--force`. Nothing has been written yet at this point, so a refusal
   leaves the disk untouched.
3. **Preflight.** Check `docker` is installed and its daemon reachable, and that `make`
   is on `PATH`. Identical for every template — exit `4` with the install command for the
   current platform if either is missing. Skipped under `--no-build` and `--dry-run`,
   which need neither. See [containers.md](containers.md).
4. **Scaffold.** Copy `templates/zig/files/` into the target, substituting a closed set
   of tokens in file contents and filenames, and write `.env` with the caller's uid/gid.
   See [template-contract.md](template-contract.md). `.env` belongs here rather than
   beside the build, so `--no-build` cannot leave a project that later runs as the wrong
   uid.
5. **Initialise git.** `git init`, stage everything, one commit:
   `chore: bootstrap zig project`. Skipped with `--no-git`.
6. **Build the image.** `docker compose build`. This is the slow step on a cold machine; afterwards it is
   cached. A failure exits `4`.
7. **Run the test.** `make test`. This is the whole promise of the tool, so it runs by
   default and a failure exits `5`. Skipped with `--no-build`.
8. **Print next steps.** The test command, the name of the kitchen-sink file, and a link
   to the kata list to apply it to. Nothing is written to the project to say this — see
   [kitchen-sink.md](kitchen-sink.md#it-is-meant-to-be-deleted).

Steps 6 and 7 are the slow ones and the only ones that touch the network.

## Template IDs

IDs are `<language>` or `<language>-<framework>`:

```
javascript            javascript-react
python                python-fastapi
rust                  rust-axum
```

Only the bare-language IDs exist in the first cut. The namespace is reserved now so
that adding `javascript-react` later doesn't force a rename of `javascript`, and so
`--list` stays sorted into obvious families.

An ID is lowercase ASCII, digits and hyphens. It is the directory name under
`templates/`; there is no registry file to keep in sync.
