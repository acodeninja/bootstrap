# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official Free Pascal image exists. Debian carries the compiler and the Free
# Component Library, which is where fpcunit lives.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         fp-compiler-3.2.2 \
         fp-units-fcl \
    && rm -rf /var/lib/apt/lists/*

# fpcunit finds the tests inside a unit by itself, through the RTTI of its
# published methods, but the program that runs them has to name every unit in a
# uses clause. Generating that clause from the test directory is what keeps the
# kitchen sink unnamed, so deleting it leaves a suite that still runs.
COPY --chmod=0755 <<'SH' /usr/local/bin/fpcunit-run
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

uses=consoletestrunner
for unit in $(find tests -name '*.pas' 2>/dev/null | sed 's|.*/||; s|\.pas$||' | sort); do
  uses="$uses, $unit"
done

{
  echo 'program runner;'
  echo
  echo 'uses'
  echo "  $uses;"
  echo
  echo 'var'
  echo '  app: TTestRunner;'
  echo
  echo 'begin'
  echo '  app := TTestRunner.Create(nil);'
  echo '  app.Initialize;'
  echo '  app.Run;'
  echo '  app.Free;'
  echo 'end.'
} > "$build/runner.pas"

fpc -Mobjfpc -Sh -Sew -Fusrc -Futests -FU"$build" -o"$build/test-runner" "$build/runner.pas"
exec "$build/test-runner" --all --format=plain
SH

# fpc takes one file at a time and compiles units wherever -FU points, so lint
# globs inside the container and throws the output away. -Sew is the whole point:
# an unused variable or an uninitialised managed result is a warning, and a
# warning is the kind of thing lint exists to refuse.
COPY --chmod=0755 <<'SH' /usr/local/bin/fpc-check-all
#!/bin/sh
set -eu

check=$(mktemp -d)
trap 'rm -rf "$check"' EXIT

for file in $(find src tests -name '*.pas' | sort); do
  fpc -Mobjfpc -Sh -Sew -Fusrc -Futests -FU"$check" "$file"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
