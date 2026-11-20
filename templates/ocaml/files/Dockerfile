# syntax=docker/dockerfile:1
FROM ocaml/opam:debian-13-ocaml-5.5@sha256:e718e33bc76fee9f8d712225757b848aaaeff47a3dbdb63cac7bf30cb6a14536

ARG DUNE_VERSION=3.25.0
ARG ALCOTEST_VERSION=1.10.1
ARG OCAMLFORMAT_VERSION=0.29.0

# `eval $(opam env)` lasts one RUN layer, so the switch is spelled out here
# instead and every later layer and make target sees the same toolchain.
ENV OPAMROOT=/home/opam/.opam
ENV OPAM_SWITCH_PREFIX=/home/opam/.opam/5.5
ENV PATH=/home/opam/.opam/5.5/bin:$PATH
ENV CAML_LD_LIBRARY_PATH=/home/opam/.opam/5.5/lib/stublibs:/home/opam/.opam/5.5/lib/ocaml/stublibs
ENV OCAMLPATH=/home/opam/.opam/5.5/lib
ENV OCAMLTOP_INCLUDE_PATH=/home/opam/.opam/5.5/lib/toplevel

# The image ships a frozen clone of the opam repository as `default`, so an
# update against it cannot see a release made since the image was built.
RUN opam repository set-url default https://opam.ocaml.org \
    && opam update --quiet \
    && opam install --yes dune.${DUNE_VERSION} alcotest.${ALCOTEST_VERSION} ocamlformat.${OCAMLFORMAT_VERSION} \
    && opam clean --all --yes

COPY --chmod=0755 <<'SH' /usr/local/bin/alcotest-discover
#!/bin/sh
# Writes the alcotest entry point from the *_test.ml files dune hands it, so
# neither test/dune nor the Makefile has to name a suite.
set -eu

printf 'let () =\n  match\n    [\n'
printf '%s\n' "$@" | sort | while read -r path; do
  [ -n "$path" ] || continue
  base=${path##*/}
  base=${base%.ml}
  initial=$(printf '%s' "$base" | cut -c1 | tr 'a-z' 'A-Z')
  printf '      ("%s", %s%s.suite);\n' "${base%_test}" "$initial" "${base#?}"
done
printf '    ]\n  with\n  | [] -> ()\n  | suites -> Alcotest.run "tests" suites\n'
SH

COPY --chmod=0755 <<'SH' /usr/local/bin/dune-fmt
#!/bin/sh
# `dune fmt` exits 1 whenever it reformats a file, which is the normal outcome
# of asking it to. The check that follows is what decides success.
dune fmt --display quiet
exec dune build @fmt
SH

# The image's own user owns a 0700 home with the opam switch inside it, so no
# other uid can even traverse to the compiler. This is what lets compose.yaml
# run the service as the host's uid.
RUN chmod 0755 /home/opam

ENV HOME=/cache/home
ENV DUNE_BUILD_DIR=/cache/build
ENV DUNE_CACHE_ROOT=/cache/dune
ENV XDG_CACHE_HOME=/cache/xdg

USER 0

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/build /cache/dune /cache/xdg \
    && chmod -R 777 /cache

USER 1000
WORKDIR /work
