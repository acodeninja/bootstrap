# syntax=docker/dockerfile:1
FROM rust:1.100.0-slim-trixie

RUN rustup component add clippy rustfmt

ENV CARGO_HOME=/cache/cargo
ENV CARGO_TARGET_DIR=/cache/target

# World-writable so the service runs as any host uid. See
# docs/containers.md "File ownership".
RUN mkdir -p /cache && chmod -R 777 /cache

WORKDIR /work
