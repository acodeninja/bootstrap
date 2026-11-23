# syntax=docker/dockerfile:1
FROM rakudo-star:2026.09-trixie

# Rakudo Star is the distribution rather than the bare compiler, so zef and
# App::Prove6 are already here and no run needs the network. Debian's `rakudo`
# package carries neither, which would cost a package manager and a pin.

# raku -c takes one file, so lint globs inside the container where there is a
# real shell. -Isrc is what lets a test file's `use` of the module resolve
# while it is only being compiled.
COPY --chmod=0755 <<'SH' /usr/local/bin/raku-check-all
#!/bin/sh
set -eu

for file in $(find src t -name '*.rakumod' -o -name '*.rakutest' | sort); do
  raku -Isrc -c "$file"
done
SH

# Compiling a module means loading it: Rakudo precompiles on `use` and there is
# no flag that only writes the bytecode. The glob is what keeps build from
# naming a module, so adding one needs no edit here.
COPY --chmod=0755 <<'SH' /usr/local/bin/raku-precompile
#!/bin/sh
set -eu

for file in $(find src -name '*.rakumod' | sort); do
  raku -Isrc -e "use $(basename "$file" .rakumod);"
done
SH

ENV HOME=/cache/home

# Rakudo writes a module's bytecode to a .precomp directory beside the source
# and has no flag or environment variable to move it, so compose mounts a named
# volume over src/.precomp and this is the mount point it takes its mode from.
#
# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /work/src/.precomp \
    && chmod -R 777 /cache /work/src/.precomp

WORKDIR /work
