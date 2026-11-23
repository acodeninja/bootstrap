# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

ARG CFUNGE_VERSION=1,001
ARG CFUNGE_SHA256=631f61abaeaf03a15a33c01cd98e8c4887087c16360084d45bf65feb60996f89

# Nobody packages a Befunge-98 interpreter, so cfunge comes from its release
# tarball and is built here. Three things about that build are not guessable:
#
#   * The release tag is literally "1,001", and GitHub turns the comma into a
#     hyphen in the archive's top directory -- hence --strip-components.
#   * cmake's top-level CMakeLists refuses an in-tree build, so -S and -B are
#     mandatory rather than tidiness.
#   * cfunge compiles with -D_POSIX_C_SOURCE=200112L, which hides glibc's
#     strlcpy from string.h while cmake's own probe still finds it in libc.
#     Without _DEFAULT_SOURCE the result is an implicit declaration, which gcc
#     14 treats as an error, and lib/genx fails to compile.
#
# Nothing here reaches the image below, which needs only libc to run cfunge.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         cmake \
         curl \
         gcc \
         libc6-dev \
         make \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /tmp/cfunge.tar.gz \
         "https://github.com/VorpalBlade/cfunge/archive/refs/tags/${CFUNGE_VERSION}.tar.gz" \
    && printf '%s  /tmp/cfunge.tar.gz\n' "$CFUNGE_SHA256" > /tmp/cfunge.sha256 \
    && sha256sum -c /tmp/cfunge.sha256 \
    && rm /tmp/cfunge.sha256 \
    && mkdir -p /tmp/cfunge \
    && tar -xzf /tmp/cfunge.tar.gz -C /tmp/cfunge --strip-components=1 \
    && cmake -S /tmp/cfunge -B /tmp/build \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_C_FLAGS=-D_DEFAULT_SOURCE \
         -DUSE_NCURSES=OFF \
    && make -C /tmp/build

FROM debian:trixie-20261104-slim

COPY --from=toolchain /tmp/build/cfunge /usr/local/bin/cfunge

# Each test prints its own TAP, which cfunge cannot be talked out of: there is
# no assertion library and no way to make the interpreter fail on a wrong
# answer. So this checks the three things the program can get wrong -- a plan
# that does not match the results, a "not ok", and a non-zero exit, which in
# Befunge-98 is the count of failed assertions handed to `q`.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

status=0
found=no

for test in $(find tests -name '*.b98' 2>/dev/null | sort); do
  found=yes

  if output=$(cfunge "$test"); then
    code=0
  else
    code=$?
  fi
  printf '%s\n' "$output"

  if [ "$code" -ne 0 ]; then
    echo "tap: $test exited $code" >&2
    status=1
  fi

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

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
