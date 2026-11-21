# syntax=docker/dockerfile:1
FROM debian:bookworm-20261104-slim

# gforth is not in trixie -- it was dropped before the release and is back in
# testing -- so bookworm is where a packaged Forth lives, and haskell already
# bases on bookworm so this is not a new exception. Upstream's 1.0.2 does build
# from source in about forty seconds, but its make install fights libtool over
# a video4linux wrapper nothing here wants, and 0.7.3 has every word this
# template uses.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends gforth \
    && rm -rf /var/lib/apt/lists/*

# Forth has no test framework, and a word that underflows the stack stops where
# it stands. So the tests print TAP and this compares the plan against the
# results, which is what tells a failed assertion from a program that died
# half way through. Same shape as cobol, basic, lolcode and intercal.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

status=0
found=no

for test in $(find tests -name '*.fs' 2>/dev/null | sort); do
  # tester.fs is the vocabulary the tests are written in, not a test.
  case $test in */tester.fs) continue ;; esac
  found=yes

  if output=$(gforth "$test" 2>&1); then :; else
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

# Compiling a file is the whole check: an undefined word is an error at compile
# time and gforth exits 1. The test bodies are left out on purpose, because
# requiring one runs it, and running them is what make test is for.
COPY --chmod=0755 <<'SH' /usr/local/bin/forth-check
#!/bin/sh
set -eu

for file in $(find src -name '*.fs' 2>/dev/null | sort) tests/tester.fs; do
  [ -f "$file" ] || continue
  echo "== $file"
  gforth -e "require $file bye"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
