# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# An official r-base image exists and this does not use it, which is the one
# place in the repo where that rule is broken on purpose. r-base is built on
# Debian testing, so its package set moves under the tag: pinning the R
# libraries there rots as testing rotates them out, and not pinning them means
# a template that scaffolds differently next month. A datestamped stable base
# fixes all four versions at once, which is the pin this repo is built on.
#
# The cost is R 4.5.0 rather than 4.6.2, and testthat, lintr and formatR one
# minor version back. None of them is close to the edge of what a kata needs.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         r-base-core \
         r-cran-formatr \
         r-cran-lintr \
         r-cran-testthat \
    && rm -rf /var/lib/apt/lists/*

# testthat finds its own tests, but this project is not an R package, so
# nothing loads src/ for them. Sourcing it first is what a package's NAMESPACE
# would otherwise do, and it keeps the suite from naming any file.
COPY --chmod=0755 <<'R' /usr/local/bin/r-test
#!/usr/bin/env Rscript
if (length(list.files("tests", pattern = "^test.*[.][Rr]$")) == 0) {
  cat("no tests found under tests/\n")
  quit(status = 0)
}

for (f in list.files("src", pattern = "[.][Rr]$", full.names = TRUE)) {
  source(f)
}

testthat::test_dir("tests", stop_on_failure = TRUE)
R

# lint_dir returns its findings rather than setting a status, so the exit code
# is this script's job.
COPY --chmod=0755 <<'R' /usr/local/bin/r-lint
#!/usr/bin/env Rscript
lints <- lintr::lint_dir(".")

if (length(lints) > 0) {
  print(lints)
  quit(status = 1)
}

cat("no lints found\n")
R

# formatR indents by four by default and lintr wants two, so a plain tidy_dir
# would write code that lint then rejects. Two is what .editorconfig says too.
COPY --chmod=0755 <<'R' /usr/local/bin/r-fmt
#!/usr/bin/env Rscript
for (f in list.files(c("src", "tests"), pattern = "[.][Rr]$", full.names = TRUE)) {
  formatR::tidy_source(f, file = f, indent = 2, width.cutoff = 80)
}
R

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
