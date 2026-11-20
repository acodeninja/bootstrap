# syntax=docker/dockerfile:1
FROM gcc:16.2.0-trixie

RUN apt-get update \
    && apt-get install --no-install-recommends --yes clang-format=1:19.0-63 \
    && rm -rf /var/lib/apt/lists/*

# Unity has no test discovery: the idiom is a main that names every test. This
# writes that main from the test files build.mk globs, so nothing names a suite.
COPY --chmod=0755 <<'SH' /usr/local/bin/unity-discover
#!/bin/sh
set -eu

[ $# -gt 0 ] || set -- /dev/null
found=$(awk '/^void[\t ]+test_[A-Za-z0-9_]+\(void\)/ {
  name = $2
  sub(/\(void\).*/, "", name)
  print FILENAME, FNR, name
}' "$@")

printf '#include "unity.h"\n\nvoid setUp(void) {}\n\nvoid tearDown(void) {}\n\n'
echo "$found" | while read -r file line name; do
  [ -n "${name:-}" ] || continue
  printf 'void %s(void);\n' "$name"
done
printf '\nint main(void) {\n  UnityBegin("");\n'
echo "$found" | while read -r file line name; do
  [ -n "${name:-}" ] || continue
  printf '  UnitySetTestFile("%s");\n' "$file"
  printf '#line %s "%s"\n  RUN_TEST(%s);\n' "$line" "$file" "$name"
done
printf '  return UNITY_END();\n}\n'
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/build /cache/home && chmod -R 777 /cache

WORKDIR /work
