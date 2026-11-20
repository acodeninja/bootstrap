# syntax=docker/dockerfile:1
FROM gradle:9.9.1-jdk25

ENV GRADLE_USER_HOME=/cache/gradle

# Gradle's first run resolves the checkstyle and spotless plugins, and compiles
# the test classpath, which is minutes against a cold cache. Priming it on the
# real build files means the named volume seeds warm from the image.
WORKDIR /prime
COPY settings.gradle build.gradle ./
COPY config config
# The daemon registry is the one primed path Gradle chmods rather than writes,
# and chmod needs ownership rather than permission. Dropping it lets the first
# real run recreate it as whatever uid Compose maps in.
#
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# cleanup and the chmod share this layer deliberately: run separately the chmod
# rewrites the mode of every file Gradle just cached, and overlayfs then copies
# all of it again.
RUN mkdir -p src test \
    && printf 'class Prime {\n  static void prime() {}\n}\n' > src/Prime.java \
    && printf 'import org.junit.jupiter.api.Test;\n\nclass PrimeTest {\n  @Test\n  void prime() {}\n}\n' > test/PrimeTest.java \
    && gradle --no-daemon --project-cache-dir /cache/project-cache spotlessApply checkstyleMain checkstyleTest test \
    && rm -rf /prime /cache/build /cache/gradle/daemon \
    && chmod -R 777 /cache

WORKDIR /work
