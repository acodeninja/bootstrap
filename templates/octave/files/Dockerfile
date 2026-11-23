# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# MISS_HIT is both the linter and the formatter, and it is a Python package
# rather than anything Debian ships. The wheel is py3-none-any, so one pin
# covers both architectures.
# https://pypi.org/project/miss-hit/${MISS_HIT_VERSION}/
ARG MISS_HIT_VERSION=0.9.44

# octave-cli comes with the octave package and is the binary to call: plain
# `octave` looks for an X display, says so on stderr and disables itself, which
# would put two lines of noise in front of every test run.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         octave \
         python3 \
         python3-venv \
    && rm -rf /var/lib/apt/lists/*

# A venv rather than --break-system-packages: trixie marks its interpreter
# externally managed, and overriding that to install one tool is the thing the
# marker exists to stop.
RUN python3 -m venv /opt/miss_hit \
    && /opt/miss_hit/bin/pip install --no-cache-dir "miss_hit==${MISS_HIT_VERSION}" \
    && ln -s /opt/miss_hit/bin/mh_style /usr/local/bin/mh_style \
    && ln -s /opt/miss_hit/bin/mh_lint /usr/local/bin/mh_lint

# Octave's own runner is `oruntests`, which prints a summary and returns
# nothing -- so a red block would leave make test green. It is also the wrong
# name to reach for: `runtests` is MATLAB's and does not exist here.
#
# `test` is the one that answers: it takes a file, parses the %! blocks out of
# it and returns how many of them passed, so this sums those counts and exits
# on the total.
#
# Summing is what makes a red block red: `test` returns the blocks it ran and
# the blocks it found, and a module whose code stopped parsing reports 0 of 1
# rather than disappearing -- verified against a deliberately broken src/ file.
#
# What this cannot see is a file with no %! blocks at all that does not parse:
# `test` prints "has no tests available" on stdout, stderr stays empty, and
# zero of zero is exactly what an honestly empty file returns. `make lint` is
# what catches that one, because MISS_HIT parses every file whether it carries
# tests or not, and CI runs lint before test.
COPY --chmod=0755 <<'OCTAVE' /usr/local/bin/octave-test
#!/usr/bin/octave-cli -qf

dirs = {"src", "tests"};
here = {};
files = {};

for i = 1:numel (dirs)
  if (! isfolder (dirs{i}))
    continue;
  endif
  here{end+1} = dirs{i};
  found = dir (fullfile (dirs{i}, "*.m"));
  for j = 1:numel (found)
    files{end+1} = fullfile (dirs{i}, found(j).name);
  endfor
endfor

if (isempty (files))
  printf ("no tests found under src/ or tests/\n");
  exit (0);
endif

addpath (here{:});

passed = 0;
total = 0;
broken = 0;

for i = 1:numel (files)
  try
    [n, nmax] = test (files{i});
  catch err
    printf ("not ok %s: %s\n", files{i}, err.message);
    broken++;
    continue;
  end_try_catch

  passed += n;
  total += nmax;

  if (nmax == 0)
    printf ("     %s: no test blocks\n", files{i});
  elseif (n == nmax)
    printf ("ok   %s: %d of %d\n", files{i}, n, nmax);
  else
    printf ("not ok %s: %d of %d\n", files{i}, n, nmax);
  endif
endfor

printf ("%d of %d assertions passed in %d files\n", passed, total, numel (files));

if (broken > 0 || passed != total)
  exit (1);
endif
OCTAVE

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
