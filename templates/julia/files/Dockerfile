# syntax=docker/dockerfile:1
FROM julia:1.13.4-trixie

# Pkg installs by registry name, which carries no URL, so the upstream is named
# here: ${JULIAFORMATTER_VERSION} is at https://github.com/JuliaEditorSupport/JuliaFormatter.jl/releases
ARG JULIAFORMATTER_VERSION=2.14.12

# The trailing separator keeps the image's own depots on the path, so the
# pkgimages Julia ships for its stdlibs are read rather than rebuilt.
ENV JULIA_DEPOT_PATH=/cache/julia:

# Pkg has no command line, so the two targets that drive it get a script each.
COPY --chmod=0755 <<'JL' /usr/local/bin/julia-test
#!/usr/bin/env julia
using Pkg

Pkg.activate("."; io = devnull)
Pkg.test()
JL

COPY --chmod=0755 <<'JL' /usr/local/bin/julia-build
#!/usr/bin/env julia
using Pkg

Pkg.activate("."; io = devnull)
Pkg.precompile()
JL

# JuliaFormatter is both the lint and the fmt, and `julia -m` runs the same
# command line its jlfmt executable exposes without the separate app install
# that would need a pin of its own. It goes in the default shared environment
# rather than the project's, where it would be a dependency of the kata.
#
# Loading it once here is what fills the depot, and the named volume seeds from
# the image: make lint costs two seconds against that cache and fifty-six
# without it. The registry it pulls in is what every other Pkg call needs.
#
# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
# The chmod shares this layer with the install: run separately it rewrites the
# mode of every file in the depot, and overlayfs then copies all of it again.
RUN julia -e "using Pkg; Pkg.add(name=\"JuliaFormatter\", version=\"${JULIAFORMATTER_VERSION}\")" \
    && julia -e "using JuliaFormatter" \
    && chmod -R 777 /cache

WORKDIR /work
