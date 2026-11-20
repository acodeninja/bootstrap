# syntax=docker/dockerfile:1
FROM swift:6.4.2-trixie

# Not swift:6.4.2-trixie-slim. Swift's slim tags are runtime-only: they carry
# the shared libraries a built binary links against and no swift binary at all.

# SwiftPM reads its shared cache, configuration and security directories out of
# $HOME, which resolves to / for a uid with no passwd entry.
ENV HOME=/cache/home

WORKDIR /prime
COPY Package.swift ./

# A cold swift test costs twice a warm one, and almost none of that is the
# project's own code. Priming against the real manifest seeds /cache from the
# image, so a wiped volume comes back warm.
# SwiftPM guards the scratch path with a lock file in /tmp named after it, and
# the priming run leaves that one root-owned, which every other uid is then
# refused. /cache is world-writable for the same reason: the service runs as
# the host's uid. See docs/containers.md "File ownership".
#
# The cleanup and the chmods share this layer deliberately: run separately the
# chmod rewrites the mode of every file the prime just cached, and overlayfs
# then copies all of it again.
RUN mkdir -p src tests \
    && printf 'public func prime() {}\n' > src/prime.swift \
    && printf 'import XCTest\nfinal class PrimeTests: XCTestCase {}\n' > tests/prime.swift \
    && swift test --scratch-path /cache/build \
    && rm -rf /prime /tmp \
    && mkdir -p /tmp \
    && chmod 1777 /tmp \
    && chmod -R 777 /cache

WORKDIR /work
