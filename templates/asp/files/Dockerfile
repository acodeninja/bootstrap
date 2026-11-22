# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# No clingo image exists, official or otherwise. Debian's gringo package is the
# whole Potassco toolchain in one: /usr/bin/gringo grounds a program and
# /usr/bin/clingo grounds and solves it. The solver needs no clasp package --
# clingo links it in, which is why apt's recommendation of it is skipped here.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends gringo \
    && rm -rf /var/lib/apt/lists/*

# A test is a program that has an answer set only when its expectations hold,
# so the result is clingo's exit status and there is nothing to parse. The
# statuses are not a 0/1 convention and getting them backwards would make the
# suite pass whatever happened:
#
#   10  satisfiable, search not exhausted -- a program with a choice rule
#   30  satisfiable, search exhausted -- a program of plain facts reaches this
#   20  unsatisfiable: an integrity constraint fired, which is a failed test
#   65  clingo refused the file -- a syntax error or an unsafe variable
#
# Tests are discovered rather than named, so deleting the kitchen sink leaves
# a suite that still runs. --outf=3 asks for no output at all, because a
# passing run has nothing to say that the TAP line does not.
COPY --chmod=0755 <<'SH' /usr/local/bin/asp-test
#!/bin/sh
set -eu

tests=$(find tests -name '*.lp' 2>/dev/null | sort)
if [ -z "$tests" ]; then
  echo '1..0'
  echo '# no tests found under tests/'
  exit 0
fi

printf '1..%s\n' "$(printf '%s\n' "$tests" | wc -l | tr -d ' ')"

n=0
status=0
for test in $tests; do
  n=$((n + 1))

  if output=$(clingo --outf=3 "$test" 2>&1); then code=0; else code=$?; fi

  case $code in
    10 | 30)
      echo "ok $n - $test"
      ;;
    20)
      echo "not ok $n - $test"
      echo '# unsatisfiable: an integrity constraint in this file was violated'
      status=1
      ;;
    *)
      echo "not ok $n - $test"
      echo "# clingo exited $code"
      printf '%s\n' "$output" | sed 's/^/# /'
      status=1
      ;;
  esac
done

exit $status
SH

# Grounding is the only static check ASP has, and it is a real one: an unsafe
# variable, a term that cannot be evaluated or a syntax error all stop it.
# --warn=all adds the quieter advice on top -- an atom that occurs in no rule
# head is usually a typo in a predicate name. The ground program itself is
# discarded, so this is non-mutating and tells you nothing about layout.
COPY --chmod=0755 <<'SH' /usr/local/bin/asp-check
#!/bin/sh
set -eu

for file in $(find src tests -name '*.lp' 2>/dev/null | sort); do
  echo "== $file"
  gringo --warn=all "$file" > /dev/null
done
SH

# Grounding and solving are separate phases, and this is the first of them:
# gringo turns the rules into a variable-free program that any ASP solver can
# read. It is a real artefact rather than a no-op, and the only one this
# toolchain produces. gringo writes to stdout, so the redirection lives here
# where there is a shell rather than in the Makefile.
COPY --chmod=0755 <<'SH' /usr/local/bin/asp-ground
#!/bin/sh
set -eu

build=/cache/build
mkdir -p "$build"

for file in $(find src -name '*.lp' 2>/dev/null | sort); do
  out="$build/$(basename "$file" .lp).aspif"
  gringo --warn=all "$file" > "$out"
  echo "== $file -> $out"
done
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
