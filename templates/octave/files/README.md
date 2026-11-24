# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Octave. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check style with mh_style, then semantics with mh_lint
$ make fmt     # reformat in place with mh_style --fix
$ make build   # a no-op: Octave runs from source
$ make shell   # open a shell in the container
```

## Tests

Octave keeps a function's tests inside the function's own file, as `%!` blocks
the interpreter reads as comments and the `test` command reads back out. There
is no separate test framework to install and nothing to declare:

```matlab
function out = {{PROJECT_SNAKE}} (name)
  out = sprintf ("Hello, %s!", name);
end

%!test
%! assert ({{PROJECT_SNAKE}} ("world"), "Hello, world!");
```

`assert` is the whole assertion vocabulary. It compares values of any shape,
takes a tolerance as a third argument for floating point, and `fail` is there
for the cases a comparison does not express.

Two other block types are worth knowing. `%!error` demands a raise and matches
what comes out of it:

```matlab
%!error id={{PROJECT_SNAKE}}:notEven halve (7)
%!error <not even> halve (7)
```

`id=` matches the error's identifier and `<...>` matches its message as a
regular expression. `%!shared` declares variables several blocks reuse, and
`%!function` defines a fixture local to the file.

`make test` runs every `.m` file under `src/` and `tests/`, so a file is found
by being there — add one and it runs, delete one and nothing refers to it. The
counts are summed and the target fails if any block fell short.

### What `make test` cannot tell you

Octave's own directory runner is `oruntests`, and this project does not use it:
it prints a summary and returns nothing, so a failing block would leave
`make test` green. `runtests` is MATLAB's name for it and does not exist here
at all.

There is one gap worth knowing about. A file carrying no `%!` blocks that also
does not parse reports zero blocks of zero — the same as an honestly empty
file — so `make test` passes it. `make lint` is what catches that, because
MISS_HIT parses every file whether it has tests or not, and CI runs lint first.

## Lint

[MISS_HIT](https://florianschanda.github.io/miss_hit/) is both the linter and
the formatter, and `make lint` runs its two halves. `mh_style` checks layout —
indentation, line length, whitespace — and `mh_lint` checks semantics, which is
where a shadowed built-in or an unreachable branch turns up. Both parse the
`%!` blocks too, so the suite is held to the same standard as `src/`.

`--octave latest` is not optional: MISS_HIT defaults to MATLAB, and the two
languages disagree about `#` comments, `endfunction`, `unwind_protect` and the
`%!` blocks this project's tests are written in.

`miss_hit.cfg` turns three rules off, each for a reason worth keeping:
`copyright_notice` because the project ships one `LICENSE` rather than a header
in every file, and the two naming rules because this project's entry point is
named after the project — and a project name is whatever was typed on the
command line, not something a regular expression should be allowed to reject.

## Adding a dependency

Octave's own answer is `pkg install`, and Octave Forge packages are what it
installs. Add one in the `Dockerfile` so the container stays the pin, then
`pkg load` it where it is used.

Nothing here needs one yet: the standard library covers arrays, strings,
structs, regular expressions and the whole of the testing vocabulary above.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`.github/workflows/actions.lock` pins the actions that workflow uses to exact
commits, so a tag that moves upstream cannot change what runs. It is
machine-generated: after you add a workflow or edit a `uses:` line, install the
tool once with `gh extension install github/gh-actions-lock` and run
`gh actions-lock` to rebuild it. Turning on Dependabot for `github-actions`
keeps the workflow and the lockfile in step without that.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Course

Five katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself
4. [Game of Life](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/game-of-life.md) — a grid, and a generation computed from the last one
5. [Diamond](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/diamond.md) — symmetry, padding, and an output whose shape is the requirement

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
