# syntax=docker/dockerfile:1
FROM haxe:4.3.7-trixie

# Haxe 4 removed haxe.unit and put nothing in its place, so the test runner is
# the third-party exception docs/languages.md allows. It comes from its own tag
# rather than from lib.haxe.org, which publishes no version endpoint pins.yml
# can read -- a GitHub tag in the install URL is something it already resolves.
ARG UTEST_VERSION=1.13.2

# The formatter has to come from lib.haxe.org instead: its git tree carries no
# run script, because that is compiled against a nightly Haxe at release time,
# and its releases attach no asset. The tag pins.yml compares the version
# against is https://github.com/HaxeCheckstyle/haxe-formatter/releases/tag/v${FORMATTER_VERSION}
ARG FORMATTER_VERSION=1.18.0

ENV HOME=/cache/home
ENV HAXELIB_PATH=/cache/haxelib

# Both libraries land in /cache so the named volume seeds warm from the image
# and no run reaches the network. /cache is world-writable so the service runs
# as any host uid; the chmod shares this layer deliberately, because run
# separately it rewrites the mode of every file just installed and overlayfs
# then copies all of it again. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/haxelib /cache/home \
    && haxelib --never git utest https://github.com/haxe-utest/utest/ "${UTEST_VERSION}" \
    && haxelib --never install formatter "${FORMATTER_VERSION}" \
    && chmod -R 777 /cache

# utest finds the tests inside a class by itself, through a build macro over
# the methods named test*, but something has to hand it the classes. Generating
# that list from the test directory is what keeps the kitchen sink unnamed, so
# deleting it leaves a suite that still runs. The compiler flags stay in
# test.hxml, where a reader can change them without rebuilding this image.
COPY --chmod=0755 <<'SH' /usr/local/bin/utest-run
#!/bin/sh
set -eu

cases=
for name in $(find test -maxdepth 1 -name '*.hx' 2>/dev/null | sed 's|.*/||; s|\.hx$||' | sort); do
  cases="${cases:+$cases, }new $name()"
done

if [ -z "$cases" ]; then
  echo "no tests found under test/"
  exit 0
fi

{
  echo 'class Runner {'
  echo '	public static function main() {'
  echo "		utest.UTest.run([$cases]);"
  echo '	}'
  echo '}'
} > /cache/build/Runner.hx

exec haxe test.hxml "$@"
SH

WORKDIR /work
