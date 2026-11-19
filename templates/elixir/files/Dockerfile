# syntax=docker/dockerfile:1
FROM elixir:1.20.5-otp-29-slim

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The service runs as a uid with no passwd entry, so $HOME is / and the
# default ~/.mix would be unreadable to it. Fix the location instead.
ENV MIX_HOME=/usr/local/lib/mix
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_DEPS_PATH=/cache/deps
ENV MIX_BUILD_PATH=/cache/_build

# mix.lock would otherwise land in the project root the moment a dependency
# is added; mix.exs points :lockfile at /cache instead. Priming deps here
# means the named volume seeds from the image already fetched and compiled.
WORKDIR /prime
COPY mix.exs ./
RUN mix deps.get && mix deps.compile

# World-writable so the service runs as any host uid. See
# docs/containers.md "File ownership".
WORKDIR /work
RUN rm -rf /prime && chmod -R 777 /cache
