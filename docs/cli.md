# CLI contract

This document is the source of truth for both `bootstrap.sh` and `bootstrap.ps1`. Where
an implementation disagrees with this file, the implementation is wrong.

## Usage

```
bootstrap.sh <template-id> <target-dir> [options]
bootstrap.sh --list
bootstrap.sh --help
```

```powershell
.\bootstrap.ps1 <template-id> <target-dir> [options]
```

Both positional arguments are required unless `--list`, `--help`, or no arguments at all
are given. The same contract applies whether the script is run from a clone or piped
from `raw.githubusercontent.com` — see [install.md](install.md) for the one-liners and
how the two modes are told apart.

### No arguments

Running with no arguments is not a usage error. It prompts for a template and a target
directory, then proceeds normally. This exists because the remote one-liner is the
headline way in, and `iex (irm ...)` cannot pass arguments at all — a bare `iex` that
exited `1` with a usage message would make the documented Windows command look broken.

Prompting requires a TTY. Without one — piped, or in CI — missing arguments are a usage
error and exit `1` as normal.

## Options

| Flag            | Effect                                                               |
| --------------- | -------------------------------------------------------------------- |
| `--name <name>` | Project name. Defaults to the basename of `<target-dir>`.            |
| `--force`       | Scaffold into a non-empty directory, overwriting colliding files.    |
| `--no-git`      | Skip `git init` and the initial commit.                              |
| `--no-build`    | Skip `docker compose build` and the verification test run.           |
| `--dry-run`     | Print the files that would be written and exit `0`. Touches nothing. |
| `--list`        | Print available templates and exit `0`.                              |
| `--help`        | Print usage and exit `0`.                                            |

`--dry-run` implies `--no-git` and `--no-build`. Flags may appear before or after the
positional arguments. `--` ends flag parsing.

PowerShell accepts the same spellings. Do not add `-Force`-style aliases: one spelling
per flag keeps the docs, the tests and the two implementations honest.

## Exit codes

| Code | Meaning                                                               |
| ---- | --------------------------------------------------------------------- |
| `0`  | Success                                                               |
| `1`  | Usage error — bad flag, missing argument                              |
| `2`  | Unknown template ID                                                   |
| `3`  | Target directory exists and is non-empty, and `--force` was not given |
| `4`  | Docker unavailable, or the image build failed                         |
| `5`  | Generated project's test run failed                                   |
| `6`  | Could not download or extract the template archive (remote mode only) |

Distinct codes exist so CI can assert *which* failure happened. A test asserting
"non-zero" passes for the wrong reason too easily.

`6` is raised before the target directory is touched, and the temporary download
directory is removed on the way out. `1`–`3` are raised before anything is written to
disk. `4` is raised either at preflight
(no `docker`, no `make`, daemon unreachable) or at build time; when it is raised after
scaffolding, the files are left in place — they are valid, they just haven't built yet.

Preflight is skipped entirely under `--no-build` and `--dry-run`. Neither tool is needed
to produce a valid project, and demanding them would make `--dry-run` exit `4` on a
machine that has neither — contradicting both its "touches nothing, exits `0`" contract
above and the assertion in [ci.md](ci.md#failure-mode-assertions).

A `4` from the build step must say what is actually wrong. The most common cause is
Docker Hub rate-limiting an anonymous pull, which looks nothing like a broken template:

```
error: image build failed for 'zig'
       the registry reported: toomanyrequests
       Docker Hub limits anonymous pulls. Run `docker login` and try again.
```

## Output

Progress goes to stdout, one line per step, labelled:

```
==> fetch        acodeninja/bootstrap @ main (26 templates)
==> template     Zig
==> preflight    docker 29.9.3, make 4.4.1
==> scaffold     21 files -> ../my-zig
==> git          initialised, 1 commit
==> image        built my-zig-dev (debian:bookworm-slim + zig 0.17.1)
==> test         All 61 tests passed.
```

Errors go to stderr, prefixed `error:`, and say what to do next:

```
error: no template 'ziglang'
       did you mean: zig
       run --list to see all 26 templates
```

Subprocess output (`docker compose build`, the test run) is streamed through unmodified.
Do not capture and re-print it — a failing test's own output is the most useful thing on
the screen at that moment. The one exception is the rate-limit case above, where the
script adds a line of explanation after passing the original error through.

One qualification, because it cannot be met literally: reading the build output at all
costs buildkit its TTY renderer. The build therefore streams line-buffered under
`--progress plain`. The test run is never piped, so a failing test keeps its TTY and its
colour — which is the case the rule exists to protect.

### `--list` format

One template per line, tab-separated, sorted by ID:

```
<id>\t<DISPLAY_NAME>
```

Keep the format machine-readable and stable.

## Parity rules

The two scripts are separate implementations of this document, not a port of one into
the other. They must agree on:

- flag names and their effects
- exit codes
- `--list` output, byte for byte
- the set of files produced for a given template and `--name`

They are free to differ in how they do it.

**Nothing enforces this.** CI runs on Linux only, so `bootstrap.ps1` has no automated
coverage at all — a regression there surfaces when a Windows user hits it. Treat any
change to one script as a change to both, and test the PowerShell side by hand. See
[ci.md](ci.md#what-is-not-covered).

## Explicit implementation constraints

- **No TOML or YAML parsing in bash.** The template manifest is flat `KEY=value` for
  exactly this reason. See [template-contract.md](template-contract.md).
- **No dependency beyond the documented prerequisites.** `bootstrap.sh` uses **bash 3.2
  or newer** — the version macOS ships, and what the documented one-liner invokes —
  plus `git`, `docker`, `make`, `date`, and — in remote mode — `curl` and `tar`;
  `bootstrap.ps1` uses Windows PowerShell 5.1 built-ins plus the same. No `jq`, no
  `node`, no `python`, and no `sed` — bash does literal substitution itself with
  `${v//pat/rep}`, which is also why an `&` or a `` in an author name needs no escaping.
- **Both scripts must survive being executed as a string.** Under
  `bash -c "$(curl ...)"` and `[scriptblock]::Create(...)` the script was never a file,
  so neither may rely on its own path or assume `$0` names it. That absence is how
  remote mode is detected — see [install.md](install.md#how-the-two-modes-work).
- **stdin stays attached to the terminal, and that is why these forms are documented.**
  `curl ... | bash` would hand the script's stdin to the pipe and make the no-argument
  prompt impossible; `bash -c "$(...)"` passes the script as an argument instead, leaving
  stdin on the TTY. Never document the pipe form.
- **Shell out, don't parse.** The scripts invoke `docker` and `make` and read nothing
  from them but the exit code, except for detecting `toomanyrequests` in build output.
- **`bootstrap.sh` is shellcheck-clean**, `bootstrap.ps1` is PSScriptAnalyzer-clean.
