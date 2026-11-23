# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# No official Lean image exists, and elan -- Lean's version manager -- would put
# a second, unpinned toolchain inside a pinned image, so the toolchain comes
# from the release tarball. The debian image is multi-arch and the tarball is
# not, so the architecture buildkit is targeting chooses both the download and
# its checksum.
ARG TARGETARCH
ARG LEAN_VERSION=4.36.0

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots. zstd is
# what the release is compressed with; tar cannot do it alone.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl zstd \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) lean_arch=linux; lean_sha=2b7ab1ed8b92d2e6abfaf41344823b510064dbc9c0260cac73eb496ab2dea6eb ;; \
         arm64) lean_arch=linux_aarch64; lean_sha=35471998152191ef809418ce5bf61f8fc5f209e5e3be05b48bdc4949fdb3e726 ;; \
         *) echo "no lean release tarball for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/lean.tar.zst \
         "https://github.com/leanprover/lean4/releases/download/v${LEAN_VERSION}/lean-${LEAN_VERSION}-${lean_arch}.tar.zst" \
    && printf '%s  /tmp/lean.tar.zst\n' "$lean_sha" > /tmp/lean.sha256 \
    && sha256sum -c /tmp/lean.sha256 \
    && mkdir -p /opt/lean \
    && tar --zstd -xf /tmp/lean.tar.zst -C /opt/lean --strip-components=1 \
    && rm /tmp/lean.tar.zst /tmp/lean.sha256

FROM debian:trixie-20261104-slim

COPY --from=toolchain /opt/lean /opt/lean

# Lean compiles to C and links it, but the release carries its own clang and
# ld.lld, and ldd on bin/lean and bin/clang resolves everything else from the
# base image's glibc -- so no C toolchain is installed here and the suite still
# builds. These three are for `lake update` alone: Lake shells out to curl for
# a Reservoir lookup and to git for the checkout, and without them it stops
# with "could not execute external process". Nothing the template ships needs
# the network.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/lean/bin:$PATH
ENV HOME=/cache/home

# Lake writes every artefact under the project's own .lake and has no flag or
# environment variable to move it, so compose mounts a volume there. Both
# directories are empty and world-writable so the volumes seed with a mode any
# host uid can write. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /work/.lake && chmod -R 777 /cache /work/.lake

WORKDIR /work
