# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# binutils rather than gcc-arm-none-eabi: pure assembly needs an assembler and
# a linker, and the compiler package is an order of magnitude larger for a C
# compiler nothing here invokes. qemu-system-arm is what runs the result,
# because the host is not a Cortex-M.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         binutils-arm-none-eabi qemu-system-arm \
    && rm -rf /var/lib/apt/lists/*

# Each test is a whole program: src/start.S supplies the vector table and the
# reset handler, the test supplies main, and the project's linker script says
# where both land. Nothing is shared at run time because there is no loader --
# every test is its own firmware image.
COPY --chmod=0755 <<'SH' /usr/local/bin/arm32-run
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

script=$(find . -maxdepth 1 -name '*.ld' | sort | head -1)
if [ -z "$script" ]; then
  echo "no linker script found beside the project" >&2
  exit 1
fi

status=0
found=no

for test in $(find tests -name '*.S' 2>/dev/null | sort); do
  found=yes
  name=$(basename "$test" .S)

  objs=
  broke=no
  for src in $(find src -name '*.S' 2>/dev/null | sort) "$test"; do
    object="$build/$(basename "$src" .S).o"
    if arm-none-eabi-as -mcpu=cortex-m3 -mthumb -o "$object" "$src"; then
      objs="$objs $object"
    else
      broke=yes
    fi
  done

  if [ "$broke" = yes ]; then
    echo "tap: $test did not assemble; make lint says why" >&2
    status=1
    continue
  fi

  # shellcheck disable=SC2086
  if arm-none-eabi-ld -T "$script" -o "$build/$name.elf" $objs; then :; else
    echo "tap: $test did not link; a test defines main and nothing else" >&2
    status=1
    continue
  fi

  # The timeout is this template's crash signal. Assembly's characteristic
  # failure is a branch to itself, and a chip spinning forever reports nothing
  # at all -- no exit status, no output, no fault.
  if output=$(timeout 10 qemu-system-arm -M mps2-an385 -cpu cortex-m3 \
                -monitor none -serial none -nographic \
                -semihosting-config enable=on,target=native \
                -kernel "$build/$name.elf" 2>&1); then :; else
    echo "tap: $test exited $? (a timeout here means it never reached SYS_EXIT)" >&2
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

# Assembling without writing an object is a real check: a bad mnemonic, a
# register a Cortex-M does not have, or ARM encoding where Thumb was meant all
# fail here. --fatal-warnings because a warning from an assembler is a bug.
COPY --chmod=0755 <<'SH' /usr/local/bin/arm32-check
#!/bin/sh
set -eu

for src in $(find src tests -name '*.S' 2>/dev/null | sort); do
  echo "== $src"
  arm-none-eabi-as -mcpu=cortex-m3 -mthumb --fatal-warnings -o /dev/null "$src"
done
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/arm32-build
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

for src in $(find src -name '*.S' 2>/dev/null | sort); do
  echo "== $src"
  arm-none-eabi-as -mcpu=cortex-m3 -mthumb -o "$build/$(basename "$src" .S).o" "$src"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
