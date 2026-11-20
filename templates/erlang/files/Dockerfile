# syntax=docker/dockerfile:1
FROM erlang:29.1.2.0-slim

ARG REBAR3_VERSION=3.28.0
ARG REBAR3_SHA256=5a28b1cca082d3b023ec0f5df9d9f9d52557036c6f2a21c1ffa11b93a984dd42

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /usr/local/bin/rebar3 \
         "https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3" \
    && printf '%s  /usr/local/bin/rebar3\n' "${REBAR3_SHA256}" > /tmp/rebar3.sha256 \
    && sha256sum -c /tmp/rebar3.sha256 \
    && rm /tmp/rebar3.sha256 \
    && chmod +x /usr/local/bin/rebar3

# The service runs as a uid with no passwd entry, so $HOME is / and rebar3
# has nowhere to put its caches or the dialyzer PLT.
ENV HOME=/cache
ENV REBAR_BASE_DIR=/cache/rebar3-build
ENV REBAR_CACHE_DIR=/cache/rebar3-cache

# rebar3 dialyzer spends minutes building the base PLT from erts, kernel and
# stdlib before it checks anything project-specific, and erlfmt is a hex
# plugin that needs the network the first time it is fetched. Priming both
# here means the named volume seeds from the image instead of paying for
# this on every `make lint`.
WORKDIR /prime
COPY rebar.config .
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# chmod shares this layer deliberately: run separately it rewrites the mode of
# every file the PLT build just cached, and overlayfs then copies all of it again.
RUN mkdir -p src \
    && printf -- '-module(prime).\n' > src/prime.erl \
    && rebar3 dialyzer \
    && rebar3 fmt --check \
    && rm -rf /prime \
    && mkdir -p /cache \
    && chmod -R 777 /cache

WORKDIR /work
