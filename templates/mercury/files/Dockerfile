# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No Mercury image exists, official or otherwise, and Debian dropped the
# package before trixie, so the compiler is bootstrapped from the source
# distribution. The version is the newest release listed at
# https://dl.mercurylang.org/release/, which is also where the digest comes
# from: upstream publishes the sha512 of each tarball beside it as
# <tarball>.sha512, so there is a published digest to check rather than a
# hand-computed one. One tarball serves every architecture.
ARG MERCURY_VERSION=22.01.9
ARG MERCURY_SHA512=35f10827c42f70c39d84e2948b378da10671f6ac41a7dddffdb7b1abb06d6f10bd02e24d0ad781cc4b75839aa23017af0137d2d20fe8df7c4ebb48b76586241b

# gcc, libc6-dev and make stay in the finished image rather than a builder
# stage: Mercury compiles through C, so mmc shells out to the C compiler and
# the linker on every build. flex and bison are needed too, however much
# pre-generated C the source distribution ships -- configure refuses to run
# without them ("configure: error: You need flex to build Mercury").
#
# curl and ca-certificates are here for the same reason the download is in the
# bootstrap layer below rather than a builder stage: the unpacked source tree
# is 407MB, so anything that leaves it in a layer of its own costs more than
# curl does, and a COPY --from would put the install out of reach of the
# inline build cache, which records only the final stage. See
# docs/containers.md "Published images are a cache, not the pin".
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         bison \
         ca-certificates \
         curl \
         flex \
         gcc \
         libc6-dev \
         make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/mercury

# Four to six minutes, once, and then the published image carries it. The
# install phase is the long half, not the compile.
#
# --enable-libgrades builds one grade instead of the dozen the installer
# offers, and each one costs minutes and tens of megabytes. --with-default-grade
# is the half that is easy to miss: without it the compiler still *defaults* to
# asm_fast.gc on x86_64, so every later compile fails with "the Mercury standard
# library cannot be found in grade 'asm_fast.gc'". Setting the default here
# keeps --grade out of every recipe and helper script below. aarch64 already
# defaults to hlc.gc, so this is the one line that makes the two architectures
# behave the same.
RUN curl -fsSL -o /tmp/mercury.tar.gz \
      "https://dl.mercurylang.org/release/mercury-srcdist-${MERCURY_VERSION}.tar.gz" \
    && printf '%s  /tmp/mercury.tar.gz\n' "$MERCURY_SHA512" > /tmp/mercury.sha512 \
    && sha512sum -c /tmp/mercury.sha512 \
    && tar -xzf /tmp/mercury.tar.gz --strip-components=1 \
    && ./configure --prefix=/opt/mercury \
         --enable-libgrades=hlc.gc \
         --with-default-grade=hlc.gc \
    && make PARALLEL=-j"$(nproc)" \
    && make install PARALLEL=-j"$(nproc)" \
    && rm -rf /tmp/mercury.tar.gz /tmp/mercury.sha512 /usr/src/mercury

ENV PATH=/opt/mercury/bin:$PATH

# Mercury has no test framework, so a test is a module with main/2 that prints
# TAP, and this compiles and runs each one: a "not ok", a plan that does not
# match the results, or a non-zero exit all fail the run. Same shape as cobol,
# forth and ats.
#
# Discovery has two halves, because mmc works in module names rather than
# paths. `mmc -f` writes Mercury.modules, the mapping from module name to
# source path that lets a build from somewhere else reach src/ and tests/ at
# all -- every .m file goes into it. Then a *test* is a module under tests/
# that declares main/2, because that is what mmc --make can link into an
# executable; anything else there is a library module the tests import, which
# is what keeps tests/tap.m from being run as a test of its own. Nothing names
# the kitchen sink, so deleting it leaves a suite that still runs.
#
# Every build runs from /cache/build. mmc has no flag for where its Mercury/
# interface and object directories go -- it writes them next to the module it
# is building -- so the remedy is to build somewhere else entirely and let
# Mercury.modules point back at the bind mount, which leaves the project clean.
COPY --chmod=0755 <<'SH' /usr/local/bin/mercury-tap
#!/bin/sh
set -eu

root=$(pwd)
build=/cache/build
mkdir -p "$build"

programs=""
for test in $(find tests -name '*.m' 2>/dev/null | sort); do
  if grep -q '^:- pred main(' "$test"; then
    programs="$programs $(basename "$test" .m)"
  fi
done

if [ -z "$programs" ]; then
  echo "no tests found under tests/"
  exit 0
fi

sources=""
for source in $(find src tests -name '*.m' 2>/dev/null | sort); do
  sources="$sources $root/$source"
done

cd "$build"
# shellcheck disable=SC2086
mmc -f $sources

status=0

for program in $programs; do
  # The compiler's own output is held back unless the build fails, because it
  # would otherwise land in the middle of the TAP stream -- mmc announces an
  # up-to-date target on every run after the first. Warnings are make lint's
  # job, and it fails on them.
  if log=$(mmc --make --no-verbose-make "$program" 2>&1); then :; else
    echo "not ok - tests/$program.m did not compile"
    printf '%s\n' "$log" | sed 's/^/# /'
    status=1
    continue
  fi

  if output=$("./$program"); then :; else
    echo "tap: tests/$program.m exited $?" >&2
    status=1
  fi
  printf '%s\n' "$output"

  plan=$(printf '%s\n' "$output" | sed -n 's/^1\.\.\([0-9][0-9]*\)$/\1/p')
  ran=$(printf '%s\n' "$output" | grep -c '^\(not \)\{0,1\}ok ' || true)

  if printf '%s\n' "$output" | grep -q '^not ok'; then
    status=1
  fi

  if [ "${plan:-none}" != "$ran" ]; then
    echo "tap: tests/$program.m planned ${plan:-no} tests and reported $ran" >&2
    status=1
  fi
done

exit $status
SH

# .check is the --make target that runs --errorcheck-only: it builds the
# interface files the check needs and then type, mode and determinism checks
# the module, writing a .err file and no target code. --errorcheck-only on its
# own cannot do that, because it wants interface files nobody has built yet.
#
# This is an unusually strong lint. A wrong mode or determinism declaration is
# an error here rather than a warning, so lint catches a predicate that claims
# to be det and is not, and a call that leaves an `in` argument unbound.
# --halt-at-warn adds the rest: a singleton variable, an unused import, a
# determinism declaration looser than the code needs.
#
# It runs in a fresh directory each time, so the answer never depends on what
# an earlier build left behind, and nothing in the project is touched.
COPY --chmod=0755 <<'SH' /usr/local/bin/mercury-check
#!/bin/sh
set -eu

root=$(pwd)
check=$(mktemp -d)
trap 'rm -rf "$check"' EXIT

sources=$(find src tests -name '*.m' 2>/dev/null | sort)
if [ -z "$sources" ]; then
  echo "no modules found under src/ or tests/"
  exit 0
fi

qualified=""
for source in $sources; do
  qualified="$qualified $root/$source"
done

cd "$check"
# shellcheck disable=SC2086
mmc -f $qualified

for source in $sources; do
  echo "== $source"
  mmc --make --no-verbose-make --halt-at-warn \
    --halt-at-warn-make-interface "$(basename "$source" .m).check"
done
SH

# A module with no main/2 is a library, and `mmc --make lib<module>` is how you
# build one: a .a, a .so, the .mh header C callers need and the .init the
# runtime reads. The project's own modules live in src/, so that is what this
# builds; the tests are the only programs here.
COPY --chmod=0755 <<'SH' /usr/local/bin/mercury-build
#!/bin/sh
set -eu

root=$(pwd)
build=/cache/build
mkdir -p "$build"

sources=$(find src tests -name '*.m' 2>/dev/null | sort)
qualified=""
for source in $sources; do
  qualified="$qualified $root/$source"
done

cd "$build"
# shellcheck disable=SC2086
mmc -f $qualified

for source in $(find "$root/src" -name '*.m' 2>/dev/null | sort); do
  module=$(basename "$source" .m)
  echo "== src/$module.m -> $build/lib$module.a"
  mmc --make --no-verbose-make "lib$module"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
