# syntax=docker/dockerfile:1
FROM node:26.13.1-trixie-slim

# elm links its own TLS stack and the slim image carries no root certificates,
# so without these every package fetch dies on "certificate has unknown CA".
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The toolchain installs to /node_modules, outside /work, for the same reason
# templates/javascript does: npm refuses to run with cwd=/, and the bind mount
# over /work would shadow anything installed under it.
WORKDIR /deps
COPY package.json ./
RUN npm install --no-audit --no-fund \
    && mv /deps/node_modules /node_modules \
    && rm -rf /deps /root/.npm

ENV PATH=/node_modules/.bin:$PATH
ENV NPM_CONFIG_CACHE=/cache/npm
ENV NPM_CONFIG_UPDATE_NOTIFIER=false
ENV ELM_HOME=/cache/elm

# A cold run downloads the whole published-package index and then compiles
# every dependency into ELM_HOME before it reaches a line of test code. This
# throwaway project pays for both, so the named volume seeds already warm.
COPY <<'JSON' /prime/elm.json
{
    "type": "application",
    "source-directories": [
        "src"
    ],
    "elm-version": "0.19.3",
    "dependencies": {
        "direct": {
            "elm/core": "1.0.5",
            "elm/json": "1.1.4"
        },
        "indirect": {}
    },
    "test-dependencies": {
        "direct": {
            "elm-explorations/test": "2.2.1"
        },
        "indirect": {
            "elm/bytes": "1.0.8",
            "elm/html": "1.0.1",
            "elm/random": "1.0.0",
            "elm/time": "1.0.0",
            "elm/virtual-dom": "1.0.6"
        }
    }
}
JSON

COPY <<'ELM' /prime/tests/PrimeTest.elm
module PrimeTest exposing (theToolchainCompilesAndRunsATest)

import Expect
import Test exposing (Test, test)


theToolchainCompilesAndRunsATest : Test
theToolchainCompilesAndRunsATest =
    test "the toolchain compiles and runs a test" <|
        \_ ->
            Expect.equal 2 (1 + 1)
ELM

WORKDIR /prime
# /cache and the elm-stuff mount point are world-writable so the service runs
# as any host uid without a passwd entry or a writable $HOME. See
# docs/containers.md "File ownership".
#
# The chmod shares this layer deliberately: run separately it rewrites the mode
# of every package ELM_HOME just cached, and overlayfs then copies all of it
# again.
RUN mkdir -p src \
    && elm-test \
    && rm -rf /prime \
    && mkdir -p /work/elm-stuff \
    && chmod -R 777 /cache /work/elm-stuff

WORKDIR /work
