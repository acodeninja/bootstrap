# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# Nobody packages a BQN, and CBQN publishes tags with no release assets, so the
# toolchain is the tag's source tarball built here. Two tarballs, because
# CBQN's own build system is written in BQN: a build needs a BQN to run it, and
# upstream bootstraps that from precompiled bytecode pulled as a git submodule.
# A source tarball carries no submodules, so the bytecode is fetched separately
# and unpacked at build/bytecodeLocal -- the path README.md documents for
# exactly this, and the one nogit=1 below expects to find already there.
ARG CBQN_VERSION=0.12.0
ARG CBQN_SHA256=41ae3a9a7d6cfe8bd3fafdcdbf9b9823b687ae373297cfe8a6bf59638e0552ca

# dzaima/cbqnBytecode publishes no tags, so this is the commit CBQN v0.12.0
# records for the submodule. pins.yml reads an ARG named *_VERSION and asks
# GitHub for the newest tag, which it cannot do for a bare commit -- so this
# pin is checked by hand whenever CBQN_VERSION moves.
ARG CBQN_BYTECODE_COMMIT=156b47caf895f6706811c5c34bbbbaf192b8018b
ARG CBQN_BYTECODE_SHA256=050acbe9a8d0a104c1739addeaa23a4b9b0bef9bb4dcd48ca613790fb30048d7

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         curl \
         gcc \
         libc6-dev \
         make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/cbqn
RUN curl -fsSL -o /tmp/cbqn.tar.gz \
      "https://github.com/dzaima/CBQN/archive/refs/tags/v${CBQN_VERSION}.tar.gz" \
    && curl -fsSL -o /tmp/bytecode.tar.gz \
      "https://github.com/dzaima/cbqnBytecode/archive/${CBQN_BYTECODE_COMMIT}.tar.gz" \
    && printf '%s  /tmp/cbqn.tar.gz\n' "$CBQN_SHA256" > /tmp/cbqn.sha256 \
    && printf '%s  /tmp/bytecode.tar.gz\n' "$CBQN_BYTECODE_SHA256" >> /tmp/cbqn.sha256 \
    && sha256sum -c /tmp/cbqn.sha256 \
    && tar -xzf /tmp/cbqn.tar.gz -C /tmp/cbqn --strip-components=1 \
    && mkdir -p /tmp/cbqn/build/bytecodeLocal \
    && tar -xzf /tmp/bytecode.tar.gz -C /tmp/cbqn/build/bytecodeLocal --strip-components=1 \
    && rm /tmp/cbqn.tar.gz /tmp/bytecode.tar.gz /tmp/cbqn.sha256

# Each flag was checked by dropping it. Four of them the build refuses without:
#   singeli=0, REPLXX=0  the other two submodules a tarball does not carry
#   FFI=0                drops the libffi dependency, which nothing here uses
#   version=             nogit=1 leaves nothing to read a commit hash from,
#                        and the build refuses rather than guess
#   CC=cc                the default is clang; the amd64 build notices it is
#                        absent and falls back, the aarch64 build exits 127
# nogit=1 is the guard rather than a requirement: it turns every assumption
# about a submodule into an error naming it, instead of a reach for a git that
# is not installed. notui=1 only trades the progress display for plain lines.
RUN make o3 CC=cc singeli=0 REPLXX=0 FFI=0 nogit=1 notui=1 "version=${CBQN_VERSION}"

FROM debian:trixie-20261104-slim

# FFI and replxx off leaves libc and libm, both already here, so the toolchain
# stage and its compiler stay out of the image entirely.
COPY --from=toolchain /tmp/cbqn/BQN /usr/local/bin/bqn

# BQN has no test framework. The tests print TAP and this compares the plan
# against the results, which is what tells a failed assertion from a program
# that stopped part way through -- the suite's own •Exit cannot report an
# error that killed it first. Same shape as forth, cobol, basic and lolcode.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

status=0
found=no

for test in $(find tests -name '*.bqn' 2>/dev/null | sort); do
  # tester.bqn is the vocabulary the tests are written in, not a test.
  case $test in */tester.bqn) continue ;; esac
  found=yes

  if output=$(bqn "$test" 2>&1); then :; else
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

# CBQN has no syntax-only flag, but a file wrapped in a function body is
# compiled where it appears and called nowhere -- so this reports an unknown
# glyph, a malformed train or an undefined name without running a line.
#
# •wdpath because a relative path resolves against the directory of the file
# asking, which for this one is /usr/local/lib/bqn and never the project.
COPY <<'BQN' /usr/local/lib/bqn/compile-check.bqn
Source ← {𝕊 path: •file.Chars •wdpath •file.At path}
Compile ← {𝕊 path: •BQN "{𝕊:" ∾ (Source path) ∾ (@+10) ∾ "}" ⋄ •Out "compiled " ∾ path ⋄ 0}
Report ← {𝕊 path: •Out "failed   " ∾ path ∾ ": " ∾ •CurrentError @ ⋄ 1}

•Exit 0 < +´ (Compile ⎊ Report)¨ •args
BQN

COPY --chmod=0755 <<'SH' /usr/local/bin/bqn-check
#!/bin/sh
set -eu

files=
for file in $(find src tests -name '*.bqn' 2>/dev/null | sort); do
  files="$files $file"
done

if [ -z "$files" ]; then
  echo "no .bqn files found under src/ or tests/"
  exit 0
fi

# Unquoted on purpose: the list is the argument vector.
# shellcheck disable=SC2086
exec bqn /usr/local/lib/bqn/compile-check.bqn $files
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
