# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official BASIC image exists, and Bywater is the dialect Debian carries:
# line numbers, GOSUB, and an interpreter that is also its own shell.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends bwbasic \
    && rm -rf /var/lib/apt/lists/*

# bwbasic cannot report failure any other way: a program that fails an
# assertion still exits 0, and so does one that dies half way through. So a
# test prints its results as TAP and this reads them -- and the plan line is
# what makes a program that stopped early detectable, because the results it
# never printed are missing from the count.
#
# The interpreter prints a four-line banner before the program and the TAP
# lines are the only ones that match, so the banner needs no suppressing.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

status=0
found=no

for test in $(find tests -name '*.bas' 2>/dev/null | sort); do
  found=yes
  output=$(bwbasic "$test")
  printf '%s\n' "$output"

  plan=$(printf '%s\n' "$output" | sed -n 's/^1\.\.\([0-9][0-9]*\)$/\1/p')
  ran=$(printf '%s\n' "$output" | grep -c '^\(not \)\{0,1\}ok ' || true)

  if printf '%s\n' "$output" | grep -q '^not ok'; then
    status=1
  fi

  if printf '%s\n' "$output" | grep -q '^ERROR in line'; then
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

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
