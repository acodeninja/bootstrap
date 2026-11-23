# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# bats is the de-facto shell test runner and Debian carries it, so nothing here
# is vendored or fetched. shellcheck and shfmt are packaged too, which makes
# this the one row where the whole toolchain is three apt packages.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         bats \
         shellcheck \
         shfmt \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
