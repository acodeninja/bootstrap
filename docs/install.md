# Running it

The bootstrap runs two ways from the same script: straight off the internet with no
clone, or out of a local checkout. The remote form is the headline — one line, nothing
installed, nothing left behind.

> **Pending the repo going public.** `raw.githubusercontent.com` serves nothing for a
> private repository, so every command on this page returns 404 until
> `acodeninja/bootstrap` is public — which is planned, not a blocker on the design. Use
> the [clone form](#from-a-clone) until then; it exercises the same code path minus the
> download.

## macOS and Linux

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh)" -- zig ../my-zig
```

The `--` is load-bearing. `bash -c <script> <name> <args...>` assigns `$0` from the first
word after the script, so without it `zig` would be consumed as `$0` and the template
argument would be lost. `--` takes that slot and the real arguments land in `$1`, `$2`.

With no arguments it prompts for template and target directory:

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh)"
```

That prompt is also why the form is `bash -c "$(curl ...)"` and never
`curl ... | bash`. Piping makes the script's stdin the pipe itself, so it cannot read an
answer from the keyboard; passing the script as an argument leaves stdin attached to the
terminal. The pipe form is shorter, commonly seen, and would quietly break the
no-argument path — so it is not documented anywhere here.

## Windows

```powershell
PS> & ([scriptblock]::Create((irm https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.ps1))) zig ..\my-zig
```

`iex` cannot pass arguments to the code it runs, so the argument form compiles the text
into a script block and invokes it. The bare `iex` form works and prompts, the same way
the no-argument bash form does:

```powershell
PS> iex (irm https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.ps1)
```

Two Windows PowerShell 5.1 details the script must handle itself, because a user hitting
either of them has no way to know what went wrong:

- **`$ProgressPreference = 'SilentlyContinue'`** before any download. The default
  progress bar makes `Invoke-WebRequest` roughly an order of magnitude slower on 5.1.
- **TLS 1.2** is not the default on older 5.1 configurations, and GitHub serves nothing
  below it. Set `[Net.ServicePointManager]::SecurityProtocol` before the first request.

## From a clone

Identical behaviour, no download:

```console
$ git clone git@github.com:acodeninja/bootstrap.git
$ cd bootstrap
$ ./bootstrap.sh zig ../my-zig
```

## How the two modes work

One script, not two. It decides which mode it is in by asking whether it exists on disk:

| Mode   | Detection                                    | Templates come from    |
| ------ | -------------------------------------------- | ---------------------- |
| Local  | `${BASH_SOURCE[0]}` / `$PSScriptRoot` is set | `templates/` beside it |
| Remote | neither is set — the script is a string      | downloaded archive     |

Piped through `bash -c` or `[scriptblock]::Create`, the script has no path, because it
was never a file. That absence is the signal, and it needs no flag or environment
variable to be set by the caller.

### Fetching templates

A single archive, not per-file requests:

| Platform     | URL                                                           | Extract                         |
| ------------ | ------------------------------------------------------------- | ------------------------------- |
| macOS, Linux | `https://github.com/acodeninja/bootstrap/archive/$REF.tar.gz` | `tar -xzf --strip-components=1` |
| Windows      | `https://github.com/acodeninja/bootstrap/archive/$REF.zip`    | `Expand-Archive`                |

Reasons for one archive over fetching `templates/<id>/files/` file by file:

- **Raw HTTP cannot list a directory.** Per-file fetching needs either a checked-in
  manifest of every file in every template — a thing to forget to update — or the GitHub
  contents API, which rate-limits unauthenticated callers to 60 requests an hour.
- One request is faster than thirty, and fails cleanly rather than halfway through.

Each platform uses its native format so neither needs an external binary: `tar` is
everywhere on POSIX, and `Expand-Archive` is built into PowerShell 5.1. Windows 10 does
ship `tar.exe`, but there is no reason to depend on it.

The archive goes to a temporary directory and is deleted on exit, including on failure.
Nothing is written outside the target directory and that temp directory.

### Pinning a version

`$REF` defaults to a value baked into the script. On `main` it is `refs/heads/main`; on
a release tag it is that tag, so **the script always fetches templates from the same ref
it was itself served from.** A script downloaded from `v1.2.0` that pulled `main`
templates would be a genuinely confusing bug.

Keeping those in step is a release step: when tagging, the tag's copy of both scripts
carries its own tag as the default ref.

Override for testing:

```console
$ BOOTSTRAP_REF=refs/heads/my-branch /bin/bash -c "$(curl -fsSL .../bootstrap.sh)" -- zig ../out
```

Pin the whole thing by using a tag in the URL, which is the recommended form for anything
repeatable — CI, a workshop, a README someone else follows:

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/v1.2.0/bootstrap.sh)" -- zig ../my-zig
```

Note that `raw.githubusercontent.com` caches branch URLs for about five minutes. A push
to `main` is not visible to the one-liner immediately; tag URLs are immutable and have
no such lag.

## Prerequisites

| Need           | Remote | Clone | Notes                                       |
| -------------- | ------ | ----- | ------------------------------------------- |
| Docker         | yes    | yes   | daemon running                              |
| make           | yes    | yes   | `winget install ezwinports.make` on Windows |
| git            | yes    | yes   | for `git init` in the generated project     |
| curl, tar      | yes    | no    | both present by default on macOS and Linux  |
| PowerShell 5.1 | yes    | no    | in-box on Windows                           |

## On piping the internet into a shell

This page tells you to execute code fetched over HTTPS without reading it, which is
worth being straight about rather than quiet about.

- **Read it first if you want to.** It is one file, and swapping `bash -c "$(...)"` for
  a pager shows exactly what would run:
  `curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh | less`
- **Pin a tag** for anything that matters. A branch URL is whatever was pushed most
  recently; a tag is fixed.
- **The script's own fetches use HTTPS and a pinned ref**, so it cannot be redirected to
  a different repository by anything short of compromising GitHub.
- It does not need and does not ask for elevation. If something prompts you for `sudo` or
  an administrator shell, that is not this.
