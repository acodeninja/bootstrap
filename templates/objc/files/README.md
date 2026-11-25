# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need GCC or GNUstep. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every file, warnings included
$ make fmt     # reformat in place
$ make build   # archive the project into /cache
$ make shell   # open a shell in the container
```

## Tests

A test is a **program**, not a class. It plans how many assertions it will
make, reports each one, and exits non-zero if any failed:

```console
1..1
ok 1 - a greeting addresses the name it is given
```

That is [TAP](https://testanything.org), and it is here because no unit-test
framework for Objective-C is packaged anywhere: the ones people use are
XCTest, which is Apple's and ships with Xcode, and SenTestingKit, which GNUstep
retired. TAP is a protocol rather than a dependency, so `tests/tap.h` is twelve
lines of macros and there is nothing to install or pin.

`make test` compiles every `tests/*.m` against every `src/*.m`, runs each one,
and fails on a `not ok`, a plan that does not match, or a non-zero exit. Add a
file to `tests/` and it is picked up; delete one and it stops looking for it.
Nothing names a test file anywhere, which is why deleting
`tests/kitchen_sink.m` leaves a project that still passes.

## Memory is manual

This is GCC's Objective-C front end against the GNU runtime, which has no ARC —
automatic reference counting is a Clang feature and is not available here. So
every `alloc` is matched by a `release`, and an `NSAutoreleasePool` drains what
Foundation's convenience constructors handed back autoreleased:

```objc
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

NSMutableArray *items = [[NSMutableArray alloc] init];  /* yours to release */
NSArray *parts = [text componentsSeparatedByString:@" "];  /* the pool's */

[items release];
[pool release];
```

Without a pool, GNUstep writes an `autorelease called without pool` warning to
stderr for every object and leaks them, so a program that uses Foundation at
all opens one first.

## Adding a dependency

There is no package manager. GNUstep Base is already installed, which is
Foundation — `NSString`, `NSArray`, `NSDictionary`, `NSSet`, `NSException` and
the rest need nothing added.

For anything else, install the Debian package in the `Dockerfile` and run
`docker compose build`. `apt-cache search gnustep` lists what is available. A
library also needs its `-l` flag, which means editing the compile lines in the
`Dockerfile`'s helper scripts: `gnustep-config --base-libs` covers Foundation
and nothing beyond it.

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

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Video store](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/video-store.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
