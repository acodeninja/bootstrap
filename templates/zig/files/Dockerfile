# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# No official Zig image exists, so the toolchain comes from the release
# tarball. The debian image is multi-arch and the tarball is not, so the
# architecture buildkit is targeting chooses both the download and its checksum.
ARG TARGETARCH
ARG ZIG_VERSION=0.17.1

# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) zig_arch=x86_64; zig_sha=3581863e3cbcfd0fce0efc682ce7e9e93da96668a977791d356a26d2a7e9b17a ;; \
         arm64) zig_arch=aarch64; zig_sha=a1546d5646eb184437918d6635ca6b762a0e889eac09cef720ee7a1ed3fe7795 ;; \
         *) echo "no zig release tarball for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/zig.tar.xz \
         "https://ziglang.org/download/${ZIG_VERSION}/zig-${zig_arch}-linux-${ZIG_VERSION}.tar.xz" \
    && printf '%s  /tmp/zig.tar.xz\n' "$zig_sha" > /tmp/zig.sha256 \
    && sha256sum -c /tmp/zig.sha256 \
    && mkdir -p /opt/zig \
    && tar -xJf /tmp/zig.tar.xz -C /opt/zig --strip-components=1 \
    && rm /tmp/zig.tar.xz /tmp/zig.sha256

FROM debian:trixie-20261104-slim

COPY --from=toolchain /opt/zig /opt/zig

# Only so `zig fetch` can reach a registry from `make shell`. Nothing the
# template ships needs the network.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/zig:$PATH
ENV ZIG_GLOBAL_CACHE_DIR=/cache/zig-global
ENV ZIG_LOCAL_CACHE_DIR=/cache/zig-local

# zig build compiles build.zig into a runner executable before it builds anything
# else: seventy seconds of std.Build against a cold cache, and the runner is cached
# against build.zig's own contents. Priming `zig init`'s build.zig therefore cached
# a runner no real project ever asks for, and the first `make test` still measured
# 72s. --help compiles this project's runner and not a line of src, so the image
# build stays independent of the suite -- and .dockerignore excludes src anyway.
WORKDIR /prime
COPY build.zig ./
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# chmod shares this layer deliberately: run separately it rewrites the mode of
# every file the prime just cached, and overlayfs then copies all of it again.
RUN zig build --help >/dev/null \
    && rm -rf /prime \
    && chmod -R 777 /cache

WORKDIR /work
