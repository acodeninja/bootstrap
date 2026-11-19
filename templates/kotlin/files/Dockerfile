# syntax=docker/dockerfile:1
FROM gradle:9.9.1-jdk25

ARG KTLINT_VERSION=1.8.0
ARG KTLINT_SHA256=a3fd620207d5c40da6ca789b95e7f823c54e854b7fade7f613e91096a3706d75

# The standalone CLI, not the Gradle plugin: a plugin is resolved and
# configured on every invocation of every target.
RUN curl -fsSL -o /usr/local/bin/ktlint \
      "https://github.com/ktlint/ktlint/releases/download/${KTLINT_VERSION}/ktlint" \
    && printf '%s  /usr/local/bin/ktlint\n' "$KTLINT_SHA256" > /tmp/ktlint.sha256 \
    && sha256sum -c /tmp/ktlint.sha256 \
    && rm /tmp/ktlint.sha256 \
    && chmod +x /usr/local/bin/ktlint

ENV GRADLE_USER_HOME=/cache/gradle

# Gradle's first run resolves the Kotlin plugin and the test framework and
# compiles the build scripts, which is minutes against a cold cache. Priming it
# on the real build files means the named volume seeds warm from the image.
WORKDIR /prime
COPY settings.gradle.kts build.gradle.kts gradle.properties ./
RUN mkdir -p src test \
    && printf 'fun prime() = Unit\n' > src/prime.kt \
    && printf 'class PrimeTest {\n@kotlin.test.Test fun prime() = Unit\n}\n' > test/PrimeTest.kt \
    && gradle --no-daemon --project-cache-dir /cache/project-cache test

# The daemon registry is the one primed path Gradle chmods rather than writes,
# and chmod needs ownership rather than permission. Dropping it lets the first
# run recreate it as whatever uid Compose maps in.
#
# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
WORKDIR /work
RUN rm -rf /prime /cache/build /cache/gradle/daemon && chmod -R 777 /cache
