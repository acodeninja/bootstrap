# syntax=docker/dockerfile:1
FROM perl:5.44.0-slim-trixie AS tools

# Perl::Critic's dependency tree reaches two XS modules, Clone and Params::Util,
# so building it needs a compiler the slim image does not carry. The compiler is
# needed to build and never to run, so it stays in this stage and the modules
# are copied out -- the same shape as php taking Composer from another image.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libc6-dev make \
    && rm -rf /var/lib/apt/lists/* \
    && cpanm --quiet --notest Perl::Critic@1.156 Perl::Tidy@20260826

FROM perl:5.44.0-slim-trixie

# The whole tree rather than site_perl alone: Pod::Parser is an old dual-life
# distribution that installs into the core library path, so Perl::Critic's
# dependencies end up either side of the line. Both stages are the same image,
# so this adds modules and replaces nothing.
COPY --from=tools /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=tools /usr/local/bin/perlcritic /usr/local/bin/perltidy /usr/local/bin/

# perltidy takes files rather than directories, so both tasks glob inside the
# container where there is a real shell. --assert-tidy is a real check mode, so
# lint needs no diffing of its own, and -se keeps a complaint on stderr instead
# of writing a .ERR file into the project.
#
# The formatter writes through a temporary file rather than using its own -b:
# in-place mode sets the output file's permissions and mtime, which a bind mount
# from a Windows host refuses, and perltidy treats that refusal as failure.
COPY --chmod=0755 <<'SH' /usr/local/bin/perltidy-all
#!/bin/sh
set -eu

tidied=$(mktemp)
trap 'rm -f "$tidied"' EXIT

find src t -name '*.pm' -o -name '*.t' | sort | while read -r file; do
  perltidy --standard-error-output --outfile="$tidied" "$file"
  cat "$tidied" > "$file"
done
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/perltidy-check-all
#!/bin/sh
set -eu

find src t -name '*.pm' -o -name '*.t' | sort | while read -r file; do
  perltidy --standard-error-output --assert-tidy --outfile=/dev/null "$file"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
