# syntax=docker/dockerfile:1
FROM haskell:9.14.1-slim-bookworm

# Debian carries both, built for every architecture this image is. Installing
# them from Hackage instead costs two ghc-lib-parser compilations -- a whole GHC
# frontend, twice, at versions that cannot share work -- for tools the template
# only ever runs. That measured about forty-five minutes.
RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
         hlint=3.3.6-1+b4 \
         ormolu=0.3.1.0-1+b2 \
    && rm -rf /var/lib/apt/lists/*

# ormolu takes files rather than directories, and the Makefile cannot run find
# for itself: Windows make runs recipes through cmd.exe.
COPY --chmod=0755 <<'SH' /usr/local/bin/ormolu-tree
#!/bin/sh
exec ormolu "$@" $(find . -name '*.hs')
SH

# The service runs as a uid with no passwd entry, so $HOME is / and cabal has
# nowhere to put its package index or its build store.
ENV CABAL_DIR=/cache/cabal

# cabal update needs the network, and QuickCheck, hspec and hspec-discover are
# several minutes of compilation before a line of test code runs. Priming both
# here seeds the named volume from the image, so the first `make test` pays for
# neither.
WORKDIR /prime
COPY *.cabal ./
RUN cabal update \
    && cabal build --only-dependencies --enable-tests --builddir=/tmp/prime all

# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
WORKDIR /work
RUN rm -rf /prime /tmp/prime && chmod -R 777 /cache
