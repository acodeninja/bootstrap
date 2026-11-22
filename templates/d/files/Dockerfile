# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official D image exists. Debian carries LDC and dub; neither depends on a C
# toolchain, and ldc2 shells out to cc for the link step, so gcc is here too.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         curl \
         dub \
         gcc \
         ldc \
    && rm -rf /var/lib/apt/lists/*

# dub picks dmd unless told otherwise, and dmd is not in the image.
ENV DC=ldc2

ARG DSCANNER_VERSION=0.15.2
ARG DSCANNER_SHA256=f9e3efd6f622b0cbccbe1a3558b40e74082b6bd8b2e5ce88282d7e090146cbd2

# Neither linter nor formatter is packaged, and neither publishes a release
# binary, so both are built here with the compiler installed above. Each unpacks
# one level under a directory named <package>-<version>, because a source
# tarball carries no git metadata and that name is where the tool then reads its
# own version from.
RUN src=/tmp/dscanner-${DSCANNER_VERSION}/dscanner \
    && mkdir -p "$src" \
    && curl -fsSL -o /tmp/dscanner.tar.gz \
         "https://github.com/dlang-community/D-Scanner/archive/refs/tags/v${DSCANNER_VERSION}.tar.gz" \
    && printf '%s  /tmp/dscanner.tar.gz\n' "$DSCANNER_SHA256" > /tmp/dscanner.sha256 \
    && sha256sum -c /tmp/dscanner.sha256 \
    && tar -xzf /tmp/dscanner.tar.gz --strip-components=1 -C "$src" \
    && DUB_HOME=/tmp/dub dub build --root="$src" --build=release \
    && mv "$src/bin/dscanner" /usr/local/bin/dscanner \
    && rm -rf /tmp/dscanner-${DSCANNER_VERSION} /tmp/dscanner.tar.gz \
         /tmp/dscanner.sha256 /tmp/dub

ARG DFMT_VERSION=0.15.2
ARG DFMT_SHA256=baf8da47a743b0f4a27629bd42b3389a82e91e4d4f88b4ce9487dc15b1518f1f

RUN src=/tmp/dfmt-${DFMT_VERSION}/dfmt \
    && mkdir -p "$src" \
    && curl -fsSL -o /tmp/dfmt.tar.gz \
         "https://github.com/dlang-community/dfmt/archive/refs/tags/v${DFMT_VERSION}.tar.gz" \
    && printf '%s  /tmp/dfmt.tar.gz\n' "$DFMT_SHA256" > /tmp/dfmt.sha256 \
    && sha256sum -c /tmp/dfmt.sha256 \
    && tar -xzf /tmp/dfmt.tar.gz --strip-components=1 -C "$src" \
    && DUB_HOME=/tmp/dub dub build --root="$src" --build=release \
    && mv "$src/bin/dfmt" /usr/local/bin/dfmt \
    && rm -rf /tmp/dfmt-${DFMT_VERSION} /tmp/dfmt.tar.gz /tmp/dfmt.sha256 /tmp/dub

# dfmt takes files, not directories, so the glob happens in here and the
# Makefile recipe stays one command.
COPY --chmod=0755 <<'SH' /usr/local/bin/dfmt-all
#!/bin/sh
set -eu

find src -name '*.d' -print0 | xargs -0 dfmt --inplace
SH

ENV HOME=/cache/home
ENV DUB_HOME=/cache/dub

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/dub /work/bin && chmod -R 777 /cache /work/bin

WORKDIR /work
