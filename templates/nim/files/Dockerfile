# syntax=docker/dockerfile:1
FROM nim:2.4.0

ENV NIMBLE_DIR=/cache/nimble
ENV HOME=/cache/home

# nimble test and nim check both compile through the C backend, so the first
# real run pays for a nimble package-list download and a cold nimcache. Prime
# both here so the named volume seeds from the image instead.
WORKDIR /prime
RUN mkdir -p src tests \
    && printf 'proc greet*(name: string): string =\n  "Hello, " & name & "!"\n' > src/prime.nim \
    && printf 'version = "0.1.0"\nauthor = "prime"\ndescription = "prime"\nlicense = "MIT"\nsrcDir = "src"\n' > prime.nimble \
    && printf 'import std/unittest\nimport ../src/prime\n\ntest "prime":\n  check greet("x") == "Hello, x!"\n' > tests/tprime.nim \
    && nimble test -y --nimcache:/cache/nimcache \
    && nim check --nimcache:/cache/nimcache src/prime.nim

WORKDIR /work
# nimble builds through a scratch directory under /tmp named by a hash that
# is the same on every run, so a root-owned leftover here blocks any other
# uid from recreating it.
RUN rm -rf /prime /tmp/* && mkdir -p /cache/home && chmod -R 777 /cache

# nim check takes one file and nimpretty has no check mode, so neither can be
# pointed at a directory. These glob inside the container, where a real shell
# is available, so every .nim file is covered as files come and go.
# hadolint ignore=SC2016
RUN printf '#!/bin/sh\nfor f in $(find /work/src /work/tests -name "*.nim"); do nim check --nimcache:/cache/nimcache "$f" || exit 1; done\n' \
      > /usr/local/bin/nim-check-all \
    && printf '#!/bin/sh\nfor f in $(find /work/src /work/tests -name "*.nim"); do nimpretty "$f" || exit 1; done\n' \
      > /usr/local/bin/nim-pretty-all \
    && chmod +x /usr/local/bin/nim-check-all /usr/local/bin/nim-pretty-all
