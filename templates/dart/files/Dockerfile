# syntax=docker/dockerfile:1
FROM dart:3.14.1-sdk

ENV PUB_CACHE=/cache/pub
ENV HOME=/cache

# dart pub rewrites .dart_tool/package_config.json by touching its mtime, which
# needs ownership and not merely write permission. Seeding the directory empty
# rather than populated lets the first run create that file as the calling uid.
WORKDIR /work
COPY pubspec.yaml ./
RUN dart pub get \
    && chmod -R 777 /cache \
    && rm -rf /work/.dart_tool \
    && mkdir -p /work/.dart_tool \
    && chmod 777 /work/.dart_tool
