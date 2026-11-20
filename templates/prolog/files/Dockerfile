# syntax=docker/dockerfile:1
FROM swipl:11.0.0

# The image has no passwd entry for the calling uid, so $HOME would otherwise
# resolve to / and take SWI-Prolog's config and pack directories with it.
ENV HOME=/cache/home

# swipl pack install only ever considers the pack directories on this path,
# and the one the image ships belongs to root.
ENV SWIPL_PACK_PATH=/cache/packs

# World-writable so the service runs as any host uid. See
# docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/bin /cache/packs && chmod -R 777 /cache

# plunit has no directory discovery and swipl takes files rather than
# directories, so both tasks glob inside the container, where there is a real
# shell. Every .pl file stays covered as files come and go.
# hadolint ignore=SC2016
RUN printf '#!/bin/sh\nexec swipl -g run_tests -t halt $(find /work/tests -name "*.pl" 2>/dev/null | sort)\n' \
      > /usr/local/bin/plunit-all \
    && printf '#!/bin/sh\nexec swipl --on-error=status --on-warning=status -g check -t halt $(find /work/src /work/tests -name "*.pl" 2>/dev/null | sort)\n' \
      > /usr/local/bin/prolog-check-all \
    && chmod +x /usr/local/bin/plunit-all /usr/local/bin/prolog-check-all

WORKDIR /work
