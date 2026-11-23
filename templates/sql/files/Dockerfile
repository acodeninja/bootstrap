# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# sqlfluff is both the linter and the formatter, and it is a Python package
# rather than anything Debian ships. The wheel is py3-none-any, so one pin
# covers both architectures.
# https://github.com/sqlfluff/sqlfluff/releases/tag/${SQLFLUFF_VERSION}
ARG SQLFLUFF_VERSION=4.5.0

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         python3 \
         python3-venv \
         sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# A venv rather than --break-system-packages: trixie marks its interpreter
# externally managed, and overriding that to install one tool is the thing the
# marker exists to stop.
RUN python3 -m venv /opt/sqlfluff \
    && /opt/sqlfluff/bin/pip install --no-cache-dir "sqlfluff==${SQLFLUFF_VERSION}" \
    && ln -s /opt/sqlfluff/bin/sqlfluff /usr/local/bin/sqlfluff

# SQLite has no test framework, and sqlite3 exits 0 for a query that returns
# the string "not ok" like it does for any other string. So the tests print
# TAP and this compares the plan against the results, which is what tells a
# failed assertion from a script that stopped half way through. Same shape as
# forth, cobol, basic, lolcode and intercal.
#
# Every file under src/ is read into a fresh in-memory database first, so a
# test sees the schema without naming the file it came from.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

status=0
found=no

for test in $(find tests -name '*.sql' 2>/dev/null | sort); do
  found=yes

  set -- -batch ':memory:'
  for schema in $(find src -name '*.sql' 2>/dev/null | sort); do
    set -- "$@" ".read $schema"
  done
  set -- "$@" ".read $test"

  if output=$(sqlite3 "$@" 2>&1); then :; else
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

# The only thing /cache holds. sqlfluff keeps no on-disk cache, and the venv
# above ships the bytecode pip compiled, so PYTHONPYCACHEPREFIX would make
# python ignore it and recompile -- measured at 600ms added to the first run.
ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
