# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need an interpreter. [cfunge](https://github.com/VorpalBlade/cfunge)
is built from source inside the container, pinned by the `Dockerfile`, so a
green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # a no-op: every byte is a valid Befunge cell
$ make fmt     # a no-op: moving a cell changes the program
$ make build   # a no-op: Befunge is interpreted
$ make shell   # open a shell in the container
```

## Formatting a Befunge program would change what it means

**The source is a grid, and a column position is as much a part of the program
as the characters are.** A space is the no-op instruction, so trimming the end
of a line deletes code; re-indenting a line moves every instruction on it to a
different cell; wrapping a long line turns one program into two. There is
nothing a formatter could safely do, which is why `make fmt` prints a sentence
and exits.

The same reasoning rules out `{{PROJECT_NAME}}` inside a `.b98` file. The
substitution would change the width of the row it landed on, and the rows here
line up: a `v` in column 78 only works because the row below it has a `<`
there. Tokens go in this file and in `LICENSE`, where they cost nothing.

Two files guard the grid against a well-meaning editor:

- `.gitattributes` forces LF line endings. A CRLF checkout on Windows would put
  a carriage return in every rightmost cell, and the pointer would execute it.
- `.editorconfig` turns `trim_trailing_whitespace` off for `*.b98`.

## Befunge-98, not Befunge-93

`q` pops a value and exits the process with it. Befunge-93 has no exit
instruction at all, so a suite written in it could never report a failure to
`make`. Every test here ends by handing its count of failed assertions to `q`.

cfunge defaults to 98; nothing passes `-s`.

## Tests

Each `tests/*.b98` prints its own [TAP](https://testanything.org) — the plan,
then one `ok N - name` or `not ok N - name` line per assertion — and `make test`
checks the three things the program can still get wrong: a plan that does not
match the results, a `not ok`, and a non-zero exit.

There is no assertion library, and there could not be one, so each assertion is
two rows of the grid. The first pushes its whole TAP line, right to left,
because the pointer reads cells in the order it visits them and `,` pops from
the top — so a string traversed westwards comes off forwards:

```befunge
v"not ok 7 - a character and its code are the same value"0<<<<<<<<<<<<<<<<<<<<<
>"0"68*-!!:01-0g+01-0p4*j$$$$>:#,_a,$                                         v
```

The second row leaves a difference that is zero when the assertion holds, adds
the verdict to a failure count in cell `(-1,0)`, uses `j` to skip the four `$`
that drop `not ` when it passed, prints the line with `>:#,_`, and turns south
into the next assertion.

Those twenty-nine cells are repeated on every assertion, because Befunge has no
functions and no way to invent one. That repetition is not an oversight; it is
what the language is.

### Scratch cells go at negative coordinates

The failure count lives at `(-1,0)` and not at some empty-looking cell below the
program, because **the playfield is the program**. It started at `(0,50)`, and
the first time a comment block was added at the top of the kitchen sink, row 50
became a line of code, and `p` overwrote it. The suite then hung. A negative
coordinate is the only address a growing program can never grow over.

## There is no import, and no splice either

Two `.b98` files cannot be combined. Other languages with no import get away
with concatenation — the runner glues the files together and the result is one
program — but a Befunge program is a position in a plane, so gluing two of them
means deciding which coordinates each one occupies, and then there is still no
call and no return: nothing in the language stores a return address.

`i` loads a file into the playfield at a vector you choose, which is the nearest
thing to an import the language has, and it still gives you no way to run the
loaded grid and come back.

So `src/{{PROJECT_SNAKE}}.b98` is a program you run on its own:

```console
$ make shell
$ cfunge src/{{PROJECT_SNAKE}}.b98
```

and every test under `tests/` is self-contained.

## Comments

Befunge-98 has `;`, which skips to the next `;` on the same line. The files here
use something cheaper: the pointer starts at `(0,0)`, and a `v` there sends it
down column zero, where a space is a no-op. **Every comment line therefore
begins with a space**, and the pointer falls past all of them to the first `>`.

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

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [Leap years](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/leap-years.md) — arithmetic and branching, no strings needed
3. [The counter in the grid](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/the-playfield-is-the-program.md) — storage, source and control flow in one grid

Then, when the group wants more: [Langton's Ant](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/langtons-ant.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).

cfunge is GPL-3.0-or-later. It is built into the container image and never
linked into or shipped with your code, so it imposes nothing on this project.
