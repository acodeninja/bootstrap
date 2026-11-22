# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No official Objective-C image exists. gobjc is GCC's front end and GNUstep is
# where Foundation lives on Linux; libgnustep-base-dev is the half that carries
# NSString and friends, and it pulls gnustep-make in for gnustep-config.
# gnustep-devel would also work and adds a GUI library, an interface builder
# and an IDE to an image that wants none of them.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         gobjc \
         libgnustep-base-dev \
         clang-format \
    && rm -rf /var/lib/apt/lists/*

# No unit-test framework for Objective-C is packaged anywhere, so a test here is
# a program that exercises the code and reports in TAP, which is a protocol
# rather than a dependency. This compiles each one against every module in src,
# runs it, and fails on a "not ok", a plan that does not match, or a non-zero
# exit. Same shape as cobol and forth.
#
# gnustep-config puts -MMD in the flags, so every invocation below sends the
# dependency file to /dev/null rather than leaving one beside the source, and
# names no C standard, so every invocation asks for one: gcc's Objective-C
# default is C89, where a declaration inside a for statement is an error.
COPY --chmod=0755 <<'SH' /usr/local/bin/objc-tap-run
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

modules=$(find src -name '*.m' | sort | tr '\n' ' ')
status=0
found=no

for test in $(find tests -name '*.m' 2>/dev/null | sort); do
  found=yes
  binary=$build/$(basename "$test" .m)

  # Nothing changed means nothing to compile, which is what makes a second run
  # cost only the container.
  if [ ! -x "$binary" ] || [ -n "$(find src tests -newer "$binary")" ]; then
    # shellcheck disable=SC2046,SC2086
    gcc -std=gnu11 $(gnustep-config --objc-flags) -MF /dev/null -Isrc -Itests \
      -o "$binary" "$test" $modules $(gnustep-config --base-libs)
  fi

  if output=$("$binary"); then :; else
    echo "tap: $test exited $?" >&2
    status=1
  fi
  printf '%s\n' "$output"

  plan=$(printf '%s\n' "$output" | sed -n 's/^1\.\.\([0-9][0-9]*\)$/\1/p')
  ran=$(printf '%s\n' "$output" | grep -c '^\(not \)\{0,1\}ok ' || true)

  if printf '%s\n' "$output" | grep -q '^not ok'; then
    status=1
  fi

  if [ "${plan:-none}" != "$ran" ]; then
    echo "tap: $test planned ${plan:-no} tests and reported $ran" >&2
    status=1
  fi
done

[ "$found" = yes ] || echo "no tests found under tests/"
exit $status
SH

# gcc takes one file at a time, so lint globs inside the container. -Werror is
# the whole point: an unused variable, or a message the receiver's type may not
# answer, is a warning, and a warning is what lint exists to refuse.
COPY --chmod=0755 <<'SH' /usr/local/bin/objc-check-all
#!/bin/sh
set -eu

for file in $(find src tests -name '*.m' | sort); do
  # shellcheck disable=SC2046
  gcc -fsyntax-only -std=gnu11 -Wall -Werror $(gnustep-config --objc-flags) \
    -MF /dev/null -Isrc -Itests "$file"
done
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/objc-format
#!/bin/sh
set -eu

find src tests \( -name '*.m' -o -name '*.h' \) -exec clang-format -i {} +
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/objc-build
#!/bin/sh
set -eu

archive=${1:?usage: objc-build <archive name>}
build=/cache/build
mkdir -p "$build"

objects=''
for file in $(find src -name '*.m' | sort); do
  object=$build/$(basename "$file" .m).o
  # shellcheck disable=SC2046
  gcc -c -std=gnu11 $(gnustep-config --objc-flags) -MF /dev/null -Isrc -o "$object" "$file"
  objects="$objects $object"
done

# shellcheck disable=SC2086
ar rcs "$build/$archive" $objects
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
