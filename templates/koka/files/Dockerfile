# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# No official Koka image exists, so the toolchain comes from the release
# tarball. The debian image is multi-arch and the tarball is not, so the
# architecture buildkit is targeting chooses both the download and its checksum.
ARG TARGETARCH
ARG KOKA_VERSION=3.2.9

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) koka_arch=x64; koka_sha=310459831a7c6fa6a0cd8e0e02d6b5b3b36441d5e7ce24168bda016cd2e95eee ;; \
         arm64) koka_arch=arm64; koka_sha=0cb2c033f57afad475d637fe4c016ff5ba2f5ba3cfa364a89d9c410fbfd5dcd6 ;; \
         *) echo "no koka release tarball for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/koka.tar.gz \
         "https://github.com/koka-lang/koka/releases/download/v${KOKA_VERSION}/koka-v${KOKA_VERSION}-linux-${koka_arch}.tar.gz" \
    && printf '%s  /tmp/koka.tar.gz\n' "$koka_sha" > /tmp/koka.sha256 \
    && sha256sum -c /tmp/koka.sha256 \
    && mkdir -p /opt/koka \
    && tar -xzf /tmp/koka.tar.gz -C /opt/koka \
    && rm /tmp/koka.tar.gz /tmp/koka.sha256

FROM debian:trixie-20261104-slim

COPY --from=toolchain /opt/koka /opt/koka

# Koka has no backend of its own: it emits C and hands it to a C compiler, so
# gcc and the libc headers are the whole of what compiling a Koka program
# takes. Koka's own installer asks for cmake, ninja-build and pkg-config too,
# which are vcpkg's dependencies rather than the compiler's, and for make, tar
# and curl, which only the installer itself used.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libc6-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/koka/bin:$PATH
ENV HOME=/cache/home

# Koka has no test framework, so a test is a program that prints TAP, and this
# compiles and runs each one: a "not ok", a plan that does not match the
# results, or a non-zero exit all fail the run. Same shape as ats and cobol.
#
# The glob is one level deep so test/lib/tap.kk is a module the tests import
# rather than a test of its own. --builddir keeps the generated C and the
# binaries in the cache volume, so the bind-mounted project stays clean.
COPY --chmod=0755 <<'SH' /usr/local/bin/koka-tap
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

status=0
found=no

for test in $(find test -maxdepth 1 -name '*.kk' 2>/dev/null | sort); do
  found=yes
  binary=$build/$(basename "$test" .kk)

  # koka relinks an up-to-date binary rather than skipping it, which is most of
  # a second per test file, so the mtimes decide. 3.2.9 also prints a "vfs:"
  # line per module even at -v0, so the build's output is held back and shown
  # only when it has something to say.
  if [ ! -x "$binary" ] || [ -n "$(find src test -type f -newer "$binary")" ]; then
    if ! log=$(koka -v0 --builddir="$build" -isrc -itest -o "$binary" "$test" 2>&1); then
      printf '%s\n' "$log" >&2
      exit 1
    fi
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

[ "$found" = yes ] || echo "no tests found under test/"
exit $status
SH

# koka takes one module at a time and infers a main entry point unless told the
# file is a library, so lint globs inside the container and passes --library so
# that a module without a main is still checkable. --no-compile stops before
# the C backend: the type and effect check is the whole check, and it writes
# nothing outside the cache. An effect missing from a signature, an effect with
# no handler anywhere above it, and a match missing a constructor are all
# errors here.
COPY --chmod=0755 <<'SH' /usr/local/bin/koka-check-all
#!/bin/sh
set -eu

for file in $(find src test -name '*.kk' | sort); do
  echo "== $file"
  koka -v0 --builddir=/cache/build -isrc -itest --library --no-compile "$file"
done
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/koka-build
#!/bin/sh
set -eu

for module in $(find src -name '*.kk' | sort); do
  echo "== $module"
  koka -v0 --builddir=/cache/build -isrc --library "$module"
done
SH

# kklib is Koka's runtime, mimalloc and all, and the standard library is
# compiled alongside it the first time anything is built: the same ten seconds
# of C in every project, keyed on the compiler's flags rather than on anything
# about this machine, so unlike a compiled project artefact it is still
# readable from the laptop that pulls the image. Building a throwaway module
# here lands it in /cache/build, which the named volume seeds from while it is
# still empty.
#
# The include list and the working directory are *in* that key, which is the
# trap: primed from somewhere else, or with no -i, every object lands in a
# directory `make test` never looks at and the first run pays the full cost
# anyway. So the prime runs from /work with the flags koka-tap and
# koka-check-all use, down to the two empty directories the bind mount covers.
# That is also why WORKDIR comes before this layer rather than after it.
#
# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
# The chmod shares this layer deliberately: run separately it rewrites the mode
# of every object just built, and overlayfs then copies all of it again.
WORKDIR /work
RUN mkdir -p src test \
    && printf 'fun main()\n  ()\n' > prime.kk \
    && koka -v0 --builddir=/cache/build -isrc -itest -o /cache/build/prime prime.kk \
    && rm -rf prime.kk src test /cache/build/prime \
    && mkdir -p /cache/home \
    && chmod -R 777 /cache
