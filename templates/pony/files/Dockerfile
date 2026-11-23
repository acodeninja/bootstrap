# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# No official Pony image exists, so the toolchain comes from the release
# tarball. The debian image is multi-arch and the tarball is not, so the
# architecture buildkit is targeting chooses both the download and its
# checksum. Upstream publishes a .sha512 beside each archive; these are the
# sha256 of the same bytes, which is what every other template pins.
ARG TARGETARCH
ARG PONYC_VERSION=0.78.2

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
#
# Four fifths of the unpacked tarball is libponyc-standalone.a and the five
# binaries statically linked against it: a language server, a doc generator, a
# dependency reporter, an agent server, and pony-lint, whose style rules want
# one public type per file named after it and so cannot be run over a
# single-file suite. Dropping them takes /opt/ponyc from 1.5G to 283M and
# leaves ponyc, the linker it calls, the runtime archives and the packages.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) ponyc_arch=x86-64; ponyc_sha=7cf588a03ec498f481a11ebea76fff068efbee1e77f046399fc5b139a521ed73 ;; \
         arm64) ponyc_arch=arm64; ponyc_sha=706562f42e8760d9786cd9b386d4c5c48150f8cc79d0bc6c2dfeb2cc7cb50ae9 ;; \
         *) echo "no ponyc release tarball for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/ponyc.tar.gz \
         "https://github.com/ponylang/ponyc/releases/download/${PONYC_VERSION}/ponyc-${ponyc_arch}-unknown-linux-ubuntu24.04.tar.gz" \
    && printf '%s  /tmp/ponyc.tar.gz\n' "$ponyc_sha" > /tmp/ponyc.sha256 \
    && sha256sum -c /tmp/ponyc.sha256 \
    && mkdir -p /opt/ponyc \
    && tar -xzf /tmp/ponyc.tar.gz -C /opt/ponyc --strip-components=1 \
    && rm -f /opt/ponyc/lib/*/libponyc.a /opt/ponyc/lib/*/libponyc-standalone.a \
    && rm -f /opt/ponyc/bin/pony-agent-server /opt/ponyc/bin/pony-dep \
         /opt/ponyc/bin/pony-doc /opt/ponyc/bin/pony-lint /opt/ponyc/bin/pony-lsp \
    && rm /tmp/ponyc.tar.gz /tmp/ponyc.sha256

FROM debian:trixie-20261104-slim

COPY --from=toolchain /opt/ponyc /opt/ponyc

# ponyc carries its own LLVM and LLD, so no C or C++ compiler is needed. Its
# link line still names libc's CRT objects and gcc's support libraries, so
# -lc, -latomic, -lgcc and -lgcc_s have to resolve: libc6-dev and
# libgcc-14-dev between them are what provides those four. The tarballs target
# Ubuntu 24.04 and glibc 2.39; trixie's 2.41 runs them forwards without
# complaint.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends libc6-dev libgcc-14-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/ponyc/bin:$PATH

# PonyTest has no discovery: a TestList names every test class, and the
# idiomatic place for it is the suite's own Main actor. Naming the suite is the
# one thing a deletable kitchen sink cannot afford, so the list is generated
# instead -- here, from the public `class iso Test... is UnitTest` declarations
# the tests/ package exports.
#
# The generated Main is a package of its own under /cache and reaches the
# tests through `use "tests"`, which keeps every compiler message pointing at
# the file the reader actually has. Zero test classes is a deliberate case: the
# use line is dropped as well, because `use` on a directory with no .pony files
# in it is an error, and a project whose tests have all been deleted still has
# to compile.
COPY --chmod=0755 <<'SH' /usr/local/bin/pony-harness
#!/bin/sh
set -eu

into=$1

classes=$(find tests -name '*.pony' 2>/dev/null | sort \
  | xargs -r sed -n 's/^class iso \(Test[A-Za-z0-9_]*\) is UnitTest.*/\1/p' | sort -u)

mkdir -p "$into"

{
  echo 'use "pony_test"'
  [ -z "$classes" ] || echo 'use "tests"'
  echo
  echo 'actor Main is TestList'
  echo '  new create(env: Env) =>'
  echo '    PonyTest(env, this)'
  echo
  echo '  new make() =>'
  echo '    None'
  echo
  echo '  fun tag tests(test: PonyTest) =>'
  if [ -n "$classes" ]; then
    # shellcheck disable=SC2086
    printf '    test(%s)\n' $classes
  else
    echo '    None'
  fi
} > "$into/_harness.pony"
SH

# ponyc has no incremental mode: every invocation reaches LLVM for the whole
# reachable program, which is six seconds here however little changed. So the
# harness binary is kept in the cache volume beside a record of the sources it
# was built from, and an unchanged tree runs it rather than building it again.
COPY --chmod=0755 <<'SH' /usr/local/bin/pony-test
#!/bin/sh
set -eu

build=/cache/test
stamp=/cache/test.inputs

inputs=$(find src tests -name '*.pony' -printf '%p %T@ %s\n' 2>/dev/null | sort)

if [ -x "$build/harness" ] && [ "$inputs" = "$(cat "$stamp" 2>/dev/null)" ]; then
  exec "$build/harness" --sequential --noprog
fi

pony-harness "$build"

if ! ponyc --path "$PWD" --output "$build" --bin-name harness "$build" \
     >/tmp/ponyc.log 2>&1; then
  cat /tmp/ponyc.log >&2
  exit 1
fi

printf '%s\n' "$inputs" > "$stamp"
exec "$build/harness" --sequential --noprog
SH

# --pass verify stops after the pass that checks reference capabilities, so it
# type-checks the whole reachable program -- src and every test class, whether
# the list names it or not -- and writes no object code. It is the strongest
# check ponyc can be asked for short of a build.
COPY --chmod=0755 <<'SH' /usr/local/bin/pony-verify
#!/bin/sh
set -eu

build=/cache/lint

pony-harness "$build"
ponyc --pass verify --path "$PWD" --output "$build" "$build"
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/pony-build
#!/bin/sh
set -eu

ponyc --output /cache/program --bin-name "$1" src
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/lint /cache/program /cache/test && chmod -R 777 /cache

WORKDIR /work
