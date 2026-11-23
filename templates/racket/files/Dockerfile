# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# racket/racket on Docker Hub publishes amd64 only, so the arm64 half of this
# repository's matrix has nothing to build from. Debian's racket is the main
# distribution -- rackunit, raco test and raco expand included -- on both
# architectures, and it ships its collections' bytecode in the package, so
# nothing here has to prime a cache the way clojure and commonlisp do.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends racket \
    && rm -rf /var/lib/apt/lists/*

# Racket writes a compiled/ directory beside every source file, and Racket CS
# bytecode carries the machine type it was compiled for. In a bind mount that is
# architecture-specific state in somebody's project: compiled on amd64 and read
# on arm64 it does not fall back to the source, it stops with
# "incompatible fasl-object machine-type". This sends it to the cache volume
# instead, where `docker compose down -v` is the fix.
#
# The trailing colon is load-bearing. It keeps the default roots after ours, and
# Debian's installed bytecode lives under one of them -- /usr/lib/<triplet>,
# whose name differs per architecture. Replace them and every run recompiles the
# whole of rackunit's closure from source.
ENV PLTCOMPILEDROOTS=/cache/zo:
ENV HOME=/cache/home

# Expansion is the half of compilation that resolves identifiers, and it is what
# lint runs rather than raco make: a second raco make reports every file already
# up to date and checks nothing, which is a lint target passing by saying
# nothing.
COPY --chmod=0755 <<'SH' /usr/local/bin/racket-lint
#!/bin/sh
set -eu

status=0

for file in $(find src tests -name '*.rkt' 2>/dev/null | sort); do
  echo "== $file"
  if raco expand "$file" >/dev/null; then :; else
    status=1
  fi
done

exit $status
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/racket-build
#!/bin/sh
set -eu

files=$(find src tests -name '*.rkt' 2>/dev/null | sort)

if [ -z "$files" ]; then
  echo "nothing to compile: no modules under src/ or tests/"
  exit 0
fi

raco make -v $files
SH

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/zo && chmod -R 777 /cache

WORKDIR /work
