# syntax=docker/dockerfile:1
FROM haskell:9.12.4-slim-bookworm AS hlint

ARG HLINT_VERSION=3.10

# hlint 3.10 pins ghc-lib-parser 9.12, which refuses the base that ships with
# GHC 9.14, so it is built on 9.12 instead. Only the binary and the hint files
# it reads at runtime come forward.
ENV CABAL_DIR=/tmp/cabal
RUN cabal update \
    && cabal install --installdir=/tools --install-method=copy "hlint-${HLINT_VERSION}" \
    && cabal get "hlint-${HLINT_VERSION}" --destdir=/src \
    && mv "/src/hlint-${HLINT_VERSION}/data" /tools/hlint-data

FROM haskell:9.14.1-slim-bookworm AS ormolu

ARG ORMOLU_VERSION=0.9.0.0

# Built in its own stage because compiling ghc-lib-parser leaves a couple of
# gigabytes in the cabal store that the project itself never reads.
ENV CABAL_DIR=/tmp/cabal
RUN cabal update \
    && cabal install --installdir=/tools --install-method=copy "ormolu-${ORMOLU_VERSION}"

FROM haskell:9.14.1-slim-bookworm

COPY --from=hlint /tools/hlint /usr/local/bin/hlint
COPY --from=hlint /tools/hlint-data /opt/hlint
COPY --from=ormolu /tools/ormolu /usr/local/bin/ormolu

# ormolu takes files rather than directories, and the Makefile cannot run find
# for itself: Windows make runs recipes through cmd.exe.
COPY <<'SH' /usr/local/bin/ormolu-tree
#!/bin/sh
exec ormolu "$@" $(find . -name '*.hs')
SH

# Cabal bakes the path of the store it built in into the binary, and that store
# belonged to a stage that no longer exists.
ENV hlint_datadir=/opt/hlint

# The service runs as a uid with no passwd entry, so $HOME is / and cabal has
# nowhere to put its package index or its build store.
ENV CABAL_DIR=/cache/cabal

# cabal update needs the network, and QuickCheck, hspec and hspec-discover are
# several minutes of compilation before a line of test code runs. Priming both
# here seeds the named volume from the image, so the first `make test` pays for
# neither.
WORKDIR /prime
COPY *.cabal ./
RUN chmod +x /usr/local/bin/ormolu-tree \
    && cabal update \
    && cabal build --only-dependencies --enable-tests --builddir=/tmp/prime all

# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
WORKDIR /work
RUN rm -rf /prime /tmp/prime && chmod -R 777 /cache
