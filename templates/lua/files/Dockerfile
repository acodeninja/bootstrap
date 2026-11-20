# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS stylua

# No official Lua image exists, and stylua ships no apt package either, so it
# comes from the release tarball. The debian image is multi-arch and the zip
# is not, so the architecture buildkit is targeting chooses both the download
# and its checksum.
ARG TARGETARCH
ARG STYLUA_VERSION=2.6.0

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) stylua_arch=x86_64; stylua_sha=a485f72bbfa22e4642e77a84b5edc2611a5cab7477b34e2e709dd8f78e919895 ;; \
         arm64) stylua_arch=aarch64; stylua_sha=8e67539e5fdf7a81cd03cf592b0df18d3bb96ee17a5ea5d9bf67b86387b903b0 ;; \
         *) echo "no stylua release for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/stylua.zip \
         "https://github.com/JohnnyMorganz/StyLua/releases/download/v${STYLUA_VERSION}/stylua-linux-${stylua_arch}.zip" \
    && printf '%s  /tmp/stylua.zip\n' "$stylua_sha" > /tmp/stylua.sha256 \
    && sha256sum -c /tmp/stylua.sha256 \
    && mkdir -p /opt/stylua \
    && unzip -q /tmp/stylua.zip -d /opt/stylua \
    && rm /tmp/stylua.zip /tmp/stylua.sha256

FROM debian:trixie-20261104-slim

COPY --from=stylua /opt/stylua/stylua /usr/local/bin/stylua

# Debian's luarocks package pulls in lua5.1 as a dependency, which claims
# /usr/bin/lua. Pin lua5.4 explicitly and re-point `lua` at it.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         lua5.4 liblua5.4-dev luarocks build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/lua5.4 /usr/local/bin/lua

ENV HOME=/cache/home
ENV PATH=/cache/luarocks/bin:$PATH

# busted and luacheck are rocks, not apt packages, and installing either pulls
# in a handful of C extensions that take a few seconds to compile. --lua-dir
# makes luarocks resolve the 5.4 headers; without it, the --tree below leaves
# LUA_INCDIR undetected. --tree lands the whole tree in /cache so the named
# volume seeds from the image and `make test`/`make lint` never touch the
# network.
WORKDIR /prime
RUN mkdir -p /cache/luarocks \
    && luarocks --lua-dir=/usr --tree=/cache/luarocks install busted 2.3.0 \
    && luarocks --lua-dir=/usr --tree=/cache/luarocks install luacheck 1.2.0

# /cache is world-writable so the service runs as any host uid without
# needing a passwd entry or a writable $HOME. See docs/containers.md "File
# ownership".
WORKDIR /work
RUN rm -rf /prime && mkdir -p /cache/home && chmod -R 777 /cache
