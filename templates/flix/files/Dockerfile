# syntax=docker/dockerfile:1
FROM eclipse-temurin:25.0.5.1_2-jdk-noble

ARG FLIX_VERSION=0.80.0
ARG FLIX_SHA256=0e9dec1e93071ada5eaba2e187499f0880b574e7e4ef62937d6f31c661c1fda0

# Flix publishes one jar per release, so the same artefact serves amd64 and
# arm64 and there is no per-architecture case to get wrong. The JDK image ships
# no downloader at all, which is what the apt layer is for.
#
# An apt version pin on curl only breaks the build when Ubuntu rotates its
# archive, and the jar it fetches is pinned by digest either way.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/flix \
    && curl -fsSL -o /opt/flix/flix.jar \
         "https://github.com/flix/flix/releases/download/v${FLIX_VERSION}/flix.jar" \
    && printf '%s  /opt/flix/flix.jar\n' "$FLIX_SHA256" > /tmp/flix.sha256 \
    && sha256sum -c /tmp/flix.sha256 \
    && rm /tmp/flix.sha256

# Flix is one self-contained tool -- compiler, build tool, package manager, test
# runner -- but it ships as a jar, so without this every Makefile recipe would
# read as java rather than as the language.
#
# -Xlog:cds=off is not decoration: the run that writes the archive otherwise
# prints a couple of hundred class-skipping notices to stdout, in front of the
# test results.
COPY --chmod=0755 <<'SH' /usr/local/bin/flix
#!/bin/sh
exec java -Xlog:cds=off \
  -XX:+AutoCreateSharedArchive -XX:SharedArchiveFile=/cache/flix.jsa \
  -jar /opt/flix/flix.jar "$@"
SH

# The service runs as a uid with no passwd entry, so $HOME is / and the Maven
# resolver has nowhere to put its cache.
ENV HOME=/cache

# Flix has no incremental build: every invocation recompiles the standard
# library from source, and nothing it writes to disk is read back on the next
# run. The one thing a second run can reuse is the JVM's class-data archive,
# which the launcher above writes into the cache volume on first use. It is not
# primed here: 57MB of metadata keyed to this exact JDK build, dead weight the
# moment the FROM line moves, against the second it saves per run.
#
# lib/ and build/ are project-relative with no flag or variable to move them, so
# compose mounts a named volume over each. These are empty and world-writable so
# the first run creates its files as whoever is calling. See
# docs/containers.md "File ownership".
RUN mkdir -p /cache /work/lib /work/build \
    && chmod -R 777 /cache /work/lib /work/build

WORKDIR /work
