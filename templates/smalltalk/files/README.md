# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need GNU Smalltalk. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every file, which is the whole check
$ make fmt     # a no-op: Smalltalk has no formatter
$ make build   # snapshot an image with the project loaded
$ make shell   # open a shell in the container
```

## Tests

Tests are [SUnit](https://en.wikipedia.org/wiki/SUnit) `TestCase` subclasses —
the original xUnit, which every other one is a port of. A method whose name
starts with `test` is a test.

```smalltalk
TestCase subclass: GreeterTest [

    testAGreetingAddressesTheNameItIsGiven [
        | name greeting |
        name := 'world'.

        greeting := Greeter greet: name.

        self assert: greeting = 'Hello, world!'
    ]
]
```

Every `.st` file under `src/` is filed in, then every one under `tests/`, and
the suite is `TestCase allSubclasses` — so nothing anywhere names a test, a
class or a file. Add a file and it runs; delete one and nothing refers to it.

`gst-sunit` ships with GNU Smalltalk and is deliberately unused: it takes test
class names on the command line, or a package declaration that lists them, and
either would name the suite.

`self assert:` takes a boolean, `self deny:` its negation, and
`self should: [...] raise: SomeError` asserts a refusal. There is no
`assert:equals:` in this SUnit — `self assert: actual = expected` is the
spelling.

**A file that does not compile fails the run.** `gst` reports a parse error or
an undefined name on stderr, skips the statement and carries on with an exit
status of 0, so a test class that never came into existence would otherwise read
as a suite that passed by being empty. `make test` treats anything on stderr as
a failure.

## Lint is the compiler

`make lint` files in `src/` and `tests/` without running anything, which in
Smalltalk is a real check: a parse error and a reference to a name nothing
declares are both reported as the class is compiled. Defining a method does not
run it, so the suite stays `make test`'s job.

## There is no formatter

Nothing packaged formats Smalltalk. `gst-convert` rewrites source between the
bang-separated chunk format and the bracket syntax used here, which is a
conversion rather than a formatting pass, so `make fmt` says so and does
nothing. `.editorconfig` is what keeps the layout consistent.

## Images, and where they go

Smalltalk is image-oriented: the VM starts from a snapshot of a live object
memory rather than from source files. The container holds two snapshots — the
kernel image a bare `gst` starts from, and one with SUnit already loaded that
`make test` and `make lint` start from, so no run pays to load it.

`make build` is the image-oriented build: `src/` filed into a fresh object
memory and snapshotted, so

```console
$ gst -I /cache/image/project.im
```

starts with the project already loaded and nothing left to compile.

**A snapshot is three megabytes of binary, and it belongs under `/cache`.**
Nothing in `make test` or `make lint` is ever passed `-S`, which is the flag
that writes one, and `make build` writes only into the cache volume — so
`git status` stays clean. `.gitignore` covers `*.im` for the one you take by
hand.

## Syntax, in one paragraph

Everything is a message sent to an object, including control flow: `ifTrue:`,
`ifFalse:`, `do:` and `timesRepeat:` are methods on `Boolean`, `Collection` and
`Integer` rather than keywords, and each of them takes a block — `[:each | ...]`
— as an argument. `^` returns, `:=` assigns, `.` ends a statement and `;`
cascades another message to the same receiver. `tests/kitchen_sink.st` is
fifteen passing assertions that are the rest of the tour.

This template uses GNU Smalltalk's bracket syntax, where a class and its
methods are one nested declaration. The older chunk format, with `!` separating
each piece, is still accepted and is what most Smalltalk source on the internet
looks like.

## Adding a dependency

GNU Smalltalk ships its libraries as `.star` packages, already in the image
under `/usr/local/share/smalltalk`. Load one at the top of a file:

```smalltalk
PackageLoader fileInPackage: 'XML-DOM'.
```

`make shell` then `ls /usr/local/share/smalltalk/*.star` is the catalogue.
There is no package manager and no index to fetch from, which is the whole
reason the toolchain is pinned to the image rather than to the network.

## The interpreter is built from source

Debian dropped `gnu-smalltalk` after bullseye and trixie has no package, so the
`Dockerfile` builds GNU Smalltalk 3.2.5 — upstream's last release — from the
tarball on `ftp.gnu.org`, pinned by sha256. That happens in a stage of its own,
so the compiler and the development headers never reach the image you run.

It is 2010 C, and one `-Wno-error` puts back a warning gcc has since promoted
to an error. Changing `SMALLTALK_VERSION` means changing `SMALLTALK_SHA256`
with it.

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
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Shouted](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/messages-not-calls.md) — a message looked up when it is sent, not when it is compiled

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Test framework](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/test-framework.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
