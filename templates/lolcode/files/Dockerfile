# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

ARG LCI_VERSION=1.3
ARG LCI_SHA256=56a77f8a19e6284868e609dad0e4f1d7c9fe59a61398e338726b58016c1eecef

# Nobody packages a LOLCODE interpreter, so lci comes from its release tarball
# and is built here. g++ is in this list only because lci's `project(lci)` asks
# cmake for a C++ compiler it then never uses. None of this reaches the image
# below, which needs nothing but libc and libm to run the interpreter.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         cmake \
         curl \
         g++ \
         gcc \
         libc6-dev \
         make \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /tmp/lci.tar.gz \
         "https://github.com/justinmeza/lci/archive/refs/tags/v${LCI_VERSION}.tar.gz" \
    && printf '%s  /tmp/lci.tar.gz\n' "$LCI_SHA256" > /tmp/lci.sha256 \
    && sha256sum -c /tmp/lci.sha256 \
    && rm /tmp/lci.sha256 \
    && tar -xzf /tmp/lci.tar.gz -C /tmp \
    && cmake -S "/tmp/lci-${LCI_VERSION}" -B /tmp/build -DCMAKE_BUILD_TYPE=Release \
    && make -C /tmp/build

FROM debian:trixie-20261104-slim

COPY --from=toolchain /tmp/build/lci /usr/local/bin/lci

# LOLCODE has no import of any kind: CAN HAS takes a library name and not a
# path, and two files on one command line are two separate programs. So the
# only way a test can reach src/ is to *be* the same program as it. Each file's
# HAI and KTHXBYE come off, the bodies are spliced with the modules first, and
# the result goes to lci through stdin.
#
# A test reports its results in TAP. lci does exit non-zero when it hits a
# runtime error, so that is checked too, but nothing in LOLCODE can be caught
# and nothing else distinguishes a failed assertion from a passed one.
COPY --chmod=0755 <<'SH' /usr/local/bin/tap-run
#!/bin/sh
set -eu

body() {
  sed -e '/^[[:space:]]*HAI /d' -e '/^[[:space:]]*KTHXBYE[[:space:]]*$/d' "$1"
}

program=$(mktemp)
trap 'rm -f "$program"' EXIT

status=0
found=no

for test in $(find tests -name '*.lol' 2>/dev/null | sort); do
  found=yes

  {
    echo 'HAI 1.2'
    for module in $(find src -name '*.lol' | sort); do
      body "$module"
    done
    body "$test"
    echo 'KTHXBYE'
  } > "$program"

  if output=$(lci - < "$program"); then :; else
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

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
