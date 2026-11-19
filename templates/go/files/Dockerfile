# syntax=docker/dockerfile:1
FROM golang:1.27.4-trixie

ENV GOCACHE=/cache/go-build
ENV GOMODCACHE=/cache/go-mod

# go build std compiles the standard library into GOCACHE before anything
# else runs, so the named volume seeds warm and the first `make test` is as
# fast as the second.
RUN go build std && chmod -R 777 /cache

# gofmt -l exits 0 even when it lists files, so make lint cannot rely on its
# exit code. This wraps the same check in a script that actually fails.
# hadolint ignore=SC2016
RUN printf '#!/bin/sh\nout=$(gofmt -l .)\n[ -z "$out" ] || { echo "$out" >&2; exit 1; }\n' \
      > /usr/local/bin/gofmt-check \
    && chmod +x /usr/local/bin/gofmt-check

WORKDIR /work
