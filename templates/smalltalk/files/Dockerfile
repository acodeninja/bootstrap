# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

ARG SMALLTALK_VERSION=3.2.5
ARG SMALLTALK_SHA256=819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc

# Debian dropped gnu-smalltalk after bullseye and there is no trixie package, so
# the interpreter comes from upstream's last release and is built here. It is
# 2010 C, and gcc 14 has promoted one of the warnings it was written against
# into an error: gnulib's iconv wrapper hands iconv a pointer type glibc stopped
# agreeing with. The -Wno-error below is the whole of what that costs. gawk and
# zip are not optional -- configure refuses to run without GNU awk, and the
# .star packages the kernel ships are zip archives built during make.
#
# None of this reaches the image below, which carries the six shared libraries
# gst links against and nothing that can compile anything.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         curl \
         gawk \
         gcc \
         libffi-dev \
         libgmp-dev \
         libltdl-dev \
         libreadline-dev \
         libsigsegv-dev \
         make \
         pkg-config \
         xz-utils \
         zip \
         zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL -o /tmp/smalltalk.tar.xz \
         "https://ftp.gnu.org/gnu/smalltalk/smalltalk-${SMALLTALK_VERSION}.tar.xz" \
    && printf '%s  /tmp/smalltalk.tar.xz\n' "$SMALLTALK_SHA256" > /tmp/smalltalk.sha256 \
    && sha256sum -c /tmp/smalltalk.sha256 \
    && rm /tmp/smalltalk.sha256 \
    && tar -xJf /tmp/smalltalk.tar.xz -C /tmp

WORKDIR /tmp/smalltalk-${SMALLTALK_VERSION}

RUN CFLAGS="-g -O2 -Wno-error=incompatible-pointer-types" \
      ./configure \
        --prefix=/usr/local \
        --disable-gtk \
        --without-emacs \
        --without-tcl \
        --without-tk \
    && make -j"$(nproc)" \
    && make install DESTDIR=/out

FROM debian:trixie-20261104-slim

# unzip because a .star package is a zip archive and gst's VFS shells out to
# read one, which is how a stack trace reaches the source of a kernel method.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         libffi8 \
         libgmp10 \
         libltdl7 \
         libreadline8 \
         libsigsegv2 \
         unzip \
         zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=toolchain /out/usr/local /usr/local

# Smalltalk is image-oriented: a VM starts from a snapshot of a live object
# memory rather than from source. Loading SUnit costs a second, so it is loaded
# once here and snapshotted into an image of its own, which every later run
# starts from. -I needs the file to exist already, hence the copy.
#
# This is also what keeps snapshots out of the project: nothing at run time is
# ever passed -S, so the only writable image a user has is the one make build
# creates under /cache.
RUN ldconfig \
    && cp /usr/local/var/lib/smalltalk/gst.im /usr/local/var/lib/smalltalk/sunit.im \
    && printf "PackageLoader fileInPackage: 'SUnit'\n" > /tmp/boot.st \
    && gst -g -S --no-user-files -I /usr/local/var/lib/smalltalk/sunit.im /tmp/boot.st \
    && rm /tmp/boot.st

# SUnit discovers nothing by itself: gst-sunit wants either test class names on
# the command line or a package declaration listing them, and both would name
# the kitchen sink, which is meant to be deleted. TestCase allSubclasses is the
# discovery instead -- the snapshot above has no subclasses of its own, so
# whatever tests/ filed in is the whole suite.
#
# The exit status comes from the result and not from gst, which exits 0 whatever
# the tests did.
COPY <<'ST' /usr/local/lib/smalltalk-suite.st
| suite result |
suite := TestSuite new.
suite name: 'tests'.
(TestCase allSubclasses asSortedCollection: [:a :b | a name <= b name])
    do: [:each | each isAbstract ifFalse: [suite addTest: each suite]].

suite tests isEmpty ifTrue: [
    Transcript showCr: 'no tests found under tests/'.
    ObjectMemory quit: 0].

result := suite run.
Transcript showCr: result printString.
ObjectMemory quit: (result hasPassed ifTrue: [0] ifFalse: [1])
ST

# src/ before tests/ because a test names the class src/ defines, and an
# undefined variable is reported where it is read.
#
# A file that fails to compile is the trap this guards: gst reports the error on
# stderr, skips the statement and carries on, so a test class that never came
# into existence would otherwise be a suite that passed by being empty.
COPY --chmod=0755 <<'SH' /usr/local/bin/gst-test
#!/bin/sh
set -eu

sources=$(find src -name '*.st' 2>/dev/null | sort)
tests=$(find tests -name '*.st' 2>/dev/null | sort)

complaints=$(mktemp)
trap 'rm -f "$complaints"' EXIT

status=0
gst -g --no-user-files -I /usr/local/var/lib/smalltalk/sunit.im \
  $sources $tests /usr/local/lib/smalltalk-suite.st 2>"$complaints" || status=$?

if [ -s "$complaints" ]; then
  cat "$complaints" >&2
  echo "gst-test: the files above did not compile" >&2
  status=1
fi

exit $status
SH

# Filing a class in is a compile, so this is a real check: a parse error and a
# reference to a name nothing declares are both reported. Neither changes gst's
# exit status, so stderr is the verdict.
#
# Only class bodies are compiled rather than run, which is what keeps lint from
# running the suite -- a method is not executed by being defined.
COPY --chmod=0755 <<'SH' /usr/local/bin/gst-check
#!/bin/sh
set -eu

sources=$(find src -name '*.st' 2>/dev/null | sort)
tests=$(find tests -name '*.st' 2>/dev/null | sort)

# gst with no file to read falls back to its interactive prompt and waits.
if [ -z "$sources$tests" ]; then
  echo "nothing to compile: no .st files under src/ or tests/"
  exit 0
fi

complaints=$(mktemp)
trap 'rm -f "$complaints"' EXIT

gst -g --no-user-files -I /usr/local/var/lib/smalltalk/sunit.im \
  $sources $tests 2>"$complaints"

if [ -s "$complaints" ]; then
  cat "$complaints" >&2
  exit 1
fi

echo "every file compiled"
SH

# The build output of an image-oriented language is an image: src/ filed into a
# fresh object memory and snapshotted, which `gst -I` then starts in one step
# with the project already loaded. It lands under /cache because a snapshot in
# the bind mount is three megabytes of binary in somebody's git status.
COPY --chmod=0755 <<'SH' /usr/local/bin/gst-build
#!/bin/sh
set -eu

sources=$(find src -name '*.st' 2>/dev/null | sort)

# gst with no file to read falls back to its interactive prompt and waits.
if [ -z "$sources" ]; then
  echo "nothing to build: no .st files under src/"
  exit 0
fi

image=/cache/image/project.im

# Unlinked rather than overwritten: the cache volume outlives the uid that
# filled it, and cp cannot reopen a file somebody else owns.
rm -f "$image"
cp /usr/local/var/lib/smalltalk/sunit.im "$image"
gst -g -S --no-user-files -I "$image" $sources

echo "wrote $image"
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/image && chmod -R 777 /cache

WORKDIR /work
