# syntax=docker/dockerfile:1
FROM eclipse-temurin:25.0.5.1_2-jdk-noble

ARG SCALA_CLI_VERSION=1.19.0
ARG TARGETARCH

# scala-cli is one native binary per architecture, so the archive name and its
# checksum both depend on which one buildkit is targeting. The JDK image ships
# no downloader, and git is not optional either: scala-cli shells out to it
# while formatting, and without it every `make fmt` prints a stack trace before
# carrying on regardless.
#
# An apt version pin on curl only breaks the build when Ubuntu rotates its
# archive, and the binary it fetches is pinned by digest either way.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) archive=scala-cli-x86_64-pc-linux.gz; \
                sha=a1abc4164543937b9eb98b640983d4d3084aee989ffa03286a926b1a2fe14254 ;; \
         arm64) archive=scala-cli-aarch64-pc-linux.gz; \
                sha=dda8a8a277e202cea7a44d0bbb272c0bf67619c94e1c983359e9f244ea0d9e15 ;; \
         *) echo "no scala-cli release for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/scala-cli.gz "https://github.com/VirtusLab/scala-cli/releases/download/v${SCALA_CLI_VERSION}/${archive}" \
    && printf '%s  /tmp/scala-cli.gz\n' "$sha" > /tmp/scala-cli.sha256 \
    && sha256sum -c /tmp/scala-cli.sha256 \
    && gunzip -c /tmp/scala-cli.gz > /usr/local/bin/scala-cli \
    && chmod 0755 /usr/local/bin/scala-cli \
    && rm /tmp/scala-cli.gz /tmp/scala-cli.sha256

# The uid Compose maps in has no passwd entry, so $HOME is / and anything that
# falls back to it has nowhere to write.
ENV HOME=/cache/home
ENV COURSIER_CACHE=/cache/coursier

# The archive cache -- where the scalafmt binary is unpacked -- is a separate
# setting with its own default, and coursier resolves that default from the
# passwd entry rather than from $HOME. A uid without one gets a literal "?",
# which it then creates in the working directory.
ENV COURSIER_ARCHIVE_CACHE=/cache/coursier-archives

# scala-cli takes its own home from the passwd entry rather than from $HOME, so
# this is the only way to move it: without it the compile server's incremental
# state lands in the container's writable layer and dies with the container,
# making every run a cold one.
ENV SCALA_CLI_HOME=/cache/scala-cli

# A cold run fetches the Scala compiler, munit, the compile server and scalafmt
# before it reaches a line of test code. Priming them here seeds the cache
# volume from the image, so the first `make test` downloads nothing. The
# versions come from the project's own directives, which is why they are copied
# in rather than restated.
COPY project.scala .scalafmt.conf /opt/prime/
COPY <<'SCALA' /opt/prime/test/PrimeSuite.scala
class PrimeSuite extends munit.FunSuite:
  test("the image carries a working compiler and test runner") {
    assertEquals(List(1, 2).sum, 3)
  }
SCALA

# The compile server has to be stopped by hand -- it outlives the command that
# started it, and a build step does not finish while a child still holds the
# pipe. Its daemon directory then has to go: it refuses to start against one
# that is group- or world-accessible, which is what the chmod makes everything
# under /cache.
#
# The directories are empty and everything is world-writable so the service runs
# as any host uid without a passwd entry or a writable $HOME. See
# docs/containers.md "File ownership". The chmod shares this layer deliberately:
# run separately it rewrites the mode of every jar just cached, and overlayfs
# then copies all 240MB of it again.
RUN scala-cli test --workspace /opt/prime-workspace /opt/prime \
    && scala-cli fmt --check --workspace /opt/prime-workspace \
         --scalafmt-conf /opt/prime/.scalafmt.conf /opt/prime \
    && scala-cli --power bloop exit \
    && rm -rf /opt/prime /opt/prime-workspace /cache/scala-cli/data-local/bloop/daemon \
    && mkdir -p /cache/home /cache/coursier /cache/coursier-archives /cache/scala-cli \
                /cache/workspace /cache/build \
    && chmod -R 777 /cache

WORKDIR /work
