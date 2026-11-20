# syntax=docker/dockerfile:1
FROM ghcr.io/gleam-lang/gleam:v1.19.2-erlang-slim

# The slim image carries no CA bundle, and without one every `gleam` command
# that resolves a dependency dies with "Dependency resolution failed".
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The service runs as a uid with no passwd entry, so $HOME is / and gleam's
# hex download cache has nowhere to live.
ENV HOME=/cache
ENV XDG_CACHE_HOME=/cache

# gleam has no flag or environment variable for the build directory: it is
# always ./build, so compose mounts a named volume there. This layer leaves the
# compiled dependencies at that path for the volume to seed from, and src/ and
# test/ are empty so nothing project-specific is baked in.
WORKDIR /work
COPY gleam.toml manifest.toml ./
RUN mkdir -p src test \
    && gleam build \
    && rm -rf /work/gleam.toml /work/manifest.toml /work/src /work/test

# World-writable so the service runs as any host uid without needing a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership".
RUN chmod -R 777 /cache /work/build
