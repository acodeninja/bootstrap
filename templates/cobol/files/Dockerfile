# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official GnuCOBOL image exists. Debian carries the compiler and its
# runtime, which is the whole toolchain: there is nothing else to install,
# because no maintained unit-test framework for COBOL exists to install.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnucobol3 \
    && rm -rf /var/lib/apt/lists/*

# The two COBOL unit-test libraries that exist are a GPL-2 copybook that would
# compile into the program under test, and an archived Apache-2 project whose
# last release was 2021 and which needs a JVM. So a test here is a program that
# exercises the code and reports in TAP, which is a protocol rather than a
# dependency, and this runs them: compile each one against every module in src,
# run it, and fail on a "not ok", a plan that does not match, or a non-zero exit.
#
# Each test also sets RETURN-CODE, so its exit status is right even when it is
# run by hand without this.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

modules=$(find src -name '*.cbl' | sort | tr '\n' ' ')
status=0
found=no

for test in $(find tests -name '*.cbl' 2>/dev/null | sort); do
  found=yes
  name=$(basename "$test" .cbl)

  # shellcheck disable=SC2086
  cobc -x -Wall -o "$build/$name" "$test" $modules

  if output=$("$build/$name"); then :; else
    echo "tap: $test exited $?" >&2
    status=1
  fi
  printf '%s\n' "$output"

  plan=$(printf '%s\n' "$output" | sed -n 's/^1\.\.\([0-9][0-9]*\)$/\1/p')
  ran=$(printf '%s\n' "$output" | grep -c '^\(not \)\{0,1\}ok ' || true)

  if printf '%s\n' "$output" | grep -q '^not ok'; then
    status=1
  fi

  if [ "${plan:-none}" != "$ran" ]; then
    echo "tap: $test planned ${plan:-no} tests and reported $ran" >&2
    status=1
  fi
done

[ "$found" = yes ] || echo "no tests found under tests/"
exit $status
SH

# cobc takes one file at a time, so lint globs inside the container. The
# compiler is the only checker COBOL has here, and -fsyntax-only means it
# answers without writing anything.
COPY --chmod=0755 <<'SH' /usr/local/bin/cobc-check-all
#!/bin/sh
set -eu

for file in $(find src tests -name '*.cbl' | sort); do
  cobc -fsyntax-only -Wall "$file"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
