# syntax=docker/dockerfile:1
FROM gcc:16.2.0-trixie

RUN apt-get update \
    && apt-get install --no-install-recommends --yes clang-format=1:19.0-63 \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
