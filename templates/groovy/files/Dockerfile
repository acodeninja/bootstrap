# syntax=docker/dockerfile:1
FROM gradle:9.9.1-jdk25

ENV GRADLE_USER_HOME=/cache/gradle

# Gradle's first run resolves Groovy, Spock and CodeNarc and compiles the test
# classpath, which is minutes against a cold cache. Priming it on the real build
# files means the named volume seeds warm from the image.
#
# The daemon registry is the one primed path Gradle chmods rather than writes,
# and chmod needs ownership rather than permission. Dropping it lets the first
# real run recreate it as whatever uid Compose maps in.
#
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# cleanup and the chmod have to share this layer: run separately the chmod
# rewrites the mode of every file Gradle just cached, and overlayfs then copies
# all of it again -- which cost the kotlin image 223MB.
WORKDIR /prime
COPY settings.gradle build.gradle ./
COPY config config
RUN mkdir -p src test \
    && printf 'class Prime {\n    static String prime() {\n        "primed"\n    }\n}\n' > src/prime.groovy \
    && printf 'import spock.lang.Specification\n\nclass PrimeSpec extends Specification {\n    def prime() {\n        expect:\n        Prime.prime() == "primed"\n    }\n}\n' > test/PrimeSpec.groovy \
    && gradle --no-daemon --project-cache-dir /cache/project-cache codenarcMain codenarcTest test \
    && rm -rf /prime /cache/build /cache/gradle/daemon \
    && chmod -R 777 /cache

WORKDIR /work
