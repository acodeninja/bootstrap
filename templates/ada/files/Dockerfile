# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official Ada image exists. Debian carries GNAT, gprbuild and AUnit, which
# is the whole toolchain -- and AUnit is a real xUnit rather than something
# this template had to invent.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         gnat \
         gprbuild \
         libaunit-dev \
    && rm -rf /var/lib/apt/lists/*

# Every file under tests/ is a whole program: it declares its fixture, its test
# procedures and its suite inside one procedure body, then runs them. That is
# what keeps a test to a single file with no package spec beside it, and it is
# why nothing has to be generated to find them -- gprbuild is told which main
# to build, one at a time.
COPY --chmod=0755 <<'SH' /usr/local/bin/aunit-run
#!/bin/sh
set -eu

set -- ./*.gpr
project=$1

status=0
found=no

for test in $(find tests -name '*.adb' 2>/dev/null | sort); do
  found=yes
  gprbuild -q -P "$project" "$test"
  if "/cache/build/bin/$(basename "$test" .adb)"; then :; else
    status=1
  fi
done

[ "$found" = yes ] || echo "no tests found under tests/"
exit $status
SH

# -gnatc checks without generating code, which is what makes this lint rather
# than a build, and -gnatwae turns every warning into an error. Ada says most
# of what a linter elsewhere would: an unused variable, a missing case arm, a
# subprogram with no body.
#
# -f because gprbuild is incremental and make test compiles the same sources
# with different switches: without it, lint reuses objects that were never
# checked and passes by saying nothing.
#
# -gnatwC because a suite asserts things the compiler can often prove, and
# "condition is always True" is noise about a test rather than a fault in it.
# Everything else stays an error.
COPY --chmod=0755 <<'SH' /usr/local/bin/gnat-check-all
#!/bin/sh
set -eu

set -- ./*.gpr
exec gprbuild -q -f -c -P "$1" -cargs -gnatc -gnatwae -gnatwC
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build/bin /cache/build/obj /cache/home && chmod -R 777 /cache

WORKDIR /work
