# syntax=docker/dockerfile:1
FROM gcc:16.2.0-trixie

# No official Fortran image exists and none is needed: the gcc image that c and
# cpp already pin is built --enable-languages=c,c++,fortran,go, so gfortran is
# here. Only the package manager and the formatter are missing.
ARG TARGETARCH
ARG FPM_VERSION=0.14.0

# fpm ships one static binary per architecture, so the architecture buildkit is
# targeting chooses both the download and its checksum.
RUN case "$TARGETARCH" in \
      amd64) fpm_arch=x86_64; fpm_sha=8dbc48ce5491cb862cfc1ec8740dcb2da0ec1555db079ace31a01b3a6e6f3437 ;; \
      arm64) fpm_arch=arm64; fpm_sha=dbd9905d968ce1968acd2ef54766bb55ffa759b0e083c77510098a4a0c4f4e29 ;; \
      *) echo "no fpm release binary for architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/fpm \
         "https://github.com/fortran-lang/fpm/releases/download/v${FPM_VERSION}/fpm-${FPM_VERSION}-linux-${fpm_arch}-gcc-14" \
    && printf '%s  /usr/local/bin/fpm\n' "$fpm_sha" > /tmp/fpm.sha256 \
    && sha256sum -c /tmp/fpm.sha256 \
    && rm /tmp/fpm.sha256 \
    && chmod +x /usr/local/bin/fpm

# fprettify is the fortran-lang formatter and is published to PyPI only. python3
# is already in the image; pip is not, and Debian's python3 refuses an install
# outside apt without the override.
RUN apt-get update \
    && apt-get install --no-install-recommends --yes python3-pip=25.1.1+dfsg-1 \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir --break-system-packages fprettify==0.3.7

# fprettify --diff prints a diff and still exits 0, so on its own it cannot
# answer lint. Comparing its output against nothing is the check.
COPY --chmod=0755 <<'SH' /usr/local/bin/fprettify-check
#!/bin/sh
set -eu

diff=$(fprettify --recursive --diff src test)
[ -z "$diff" ] || { printf '%s\n' "$diff"; exit 1; }
SH

ENV HOME=/cache/home

# fpm has no flag for the build directory: it is always ./build, so compose
# mounts a named volume there. This layer leaves the resolved dependency at that
# path for the volume to seed from, so a first run needs no network, and the
# sources go away again so nothing project-specific is baked in.
WORKDIR /work
COPY fpm.toml ./
RUN mkdir -p src test \
    && printf 'module prime\nend module prime\n' > src/prime.f90 \
    && fpm build --tests \
    && rm -rf /work/fpm.toml /work/src /work/test

# World-writable so the service runs as any host uid without needing a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache /work/build
