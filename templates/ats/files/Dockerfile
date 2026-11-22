# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official ATS image exists. Debian carries ATS2 0.4.2, and gcc comes with
# it because compiling through C is the only backend patscc has.
#
# Debian's /usr/bin/patscc is a wrapper that exports PATSHOME itself, so
# setting it here would be a second copy of the version number to update.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ats2-lang \
         gcc \
    && rm -rf /var/lib/apt/lists/*

# ATS has no test framework, so a test is a program that prints TAP, and this
# compiles and runs each one: a "not ok", a plan that does not match the
# results, or a non-zero exit all fail the run. Same shape as cobol and forth.
#
# patsopt writes the C it generates into the working directory, so every
# compile runs from the cache volume and the bind-mounted project stays clean.
#
# ATS_MEMALLOC_LIBC is what picks plain malloc over the Boehm collector. It is
# the choice this template is here to make: memory is the programmer's, and
# the typechecker is what holds them to it.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

root=$(pwd)
build=/cache/build
mkdir -p "$build"

modules=""
for module in $(find src -name '*.dats' | sort); do
  modules="$modules $root/$module"
done

status=0
found=no

for test in $(find tests -name '*.dats' 2>/dev/null | sort); do
  found=yes
  binary=$build/$(basename "$test" .dats)

  if [ ! -x "$binary" ] || [ -n "$(find src tests -type f -newer "$binary")" ]; then
    # shellcheck disable=SC2086
    (cd "$build" && patscc -DATS_MEMALLOC_LIBC -o "$binary" "$root/$test" $modules)
  fi

  if output=$("$binary"); then :; else
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

# patsopt takes one file at a time and wants to be told whether it is static
# or dynamic, so lint globs inside the container. Typecheck-only is the whole
# check and it writes nothing: a dropped linear value, an index the solver
# cannot discharge or a case+ missing a constructor are all errors here.
COPY --chmod=0755 <<'SH' /usr/local/bin/patsopt-check-all
#!/bin/sh
set -eu

for file in $(find src tests -name '*.sats' | sort); do
  echo "== $file"
  patsopt --typecheck -s "$file"
done

for file in $(find src tests -name '*.dats' | sort); do
  echo "== $file"
  patsopt --typecheck -d "$file"
done
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/patscc-build
#!/bin/sh
set -eu

root=$(pwd)
build=/cache/build
mkdir -p "$build"

for module in $(find src -name '*.dats' | sort); do
  echo "== $module"
  object=$build/$(basename "$module" .dats).o
  (cd "$build" && patscc -DATS_MEMALLOC_LIBC -c -o "$object" "$root/$module")
done
SH

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build && chmod -R 777 /cache

WORKDIR /work
