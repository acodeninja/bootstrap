# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# C-INTERCAL is in Debian stable, for arm64 as well as amd64, which is more
# than most languages manage. It compiles INTERCAL to C and then calls the C
# compiler, so gcc is part of the toolchain rather than an extra.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         gcc \
         intercal \
         libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# INTERCAL has no import: two .i files handed to ick are two separate programs.
# So a test and the modules it uses become one program -- the test first,
# because execution starts at the first statement and stops at its GIVE UP,
# which leaves the modules' subroutines after it, reachable only by NEXT.
#
# All three of test, lint and build need that, so it lives here once.
COPY --chmod=0755 <<'SH' /usr/local/bin/intercal-splice
#!/bin/sh
set -eu

test=$1
into=$2

mkdir -p "$into"
# shellcheck disable=SC2046
cat "$test" $(find src -name '*.i' | sort) > "$into/$(basename "$test")"
SH

# Nothing in the language can print the name of a test: READ OUT writes Roman
# numerals and that is the whole of its output. So a program reads out the
# number of each assertion it survives, and this pairs those numerals in order
# with the "DON'T ok - " lines in the source. A program that fails an assertion
# dies where it stands, so the numerals it never printed come back as "not ok".
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

build=/cache/build
status=0
found=no

for test in $(find tests -name '*.i' 2>/dev/null | sort); do
  found=yes
  name=$(basename "$test" .i)
  intercal-splice "$test" "$build"

  if (cd "$build" && ick -b "$name.i" >/dev/null 2>&1); then :; else
    echo "tap: $test did not compile; make lint says why" >&2
    status=1
    continue
  fi

  survived=$("$build/$name" 2>/dev/null | grep -cE '^[[:space:]]*[IVXLCDM_]+[[:space:]]*$' || true)
  names=$(sed -n "s/^[[:space:]]*DON'T ok - //p" "$test")
  planned=$(printf '%s\n' "$names" | grep -c . || true)

  echo "1..$planned"
  printf '%s\n' "$names" | awk -v survived="$survived" '
    { printf "%s %d - %s\n", (NR <= survived ? "ok" : "not ok"), NR, $0 }
  '

  [ "$survived" = "$planned" ] || status=1
done

[ "$found" = yes ] || echo "no tests found under tests/"
exit $status
SH

# ick -c stops after translating INTERCAL to C, which is what makes lint real:
# it rejects a syntax error, and it rejects a program whose share of PLEASE
# falls outside one fifth to one third of its statements. Without -c it
# produces the executable instead, which is what build wants.
#
# -b is not optional. Without it the compiler inserts a chance of E774 --
# "RANDOM COMPILER BUG" -- on purpose, and a suite that fails once in a while
# for no reason is worse than no suite. One run of fifteen assertions died at
# the sixth before this was added.
COPY --chmod=0755 <<'SH' /usr/local/bin/intercal-compile
#!/bin/sh
set -eu

build=/cache/build

for test in $(find tests -name '*.i' | sort); do
  intercal-splice "$test" "$build"
  (cd "$build" && ick -b "$@" "$(basename "$test")")
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
