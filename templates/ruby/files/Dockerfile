# syntax=docker/dockerfile:1
FROM ruby:4.0.10-slim-trixie

# gem install into the image's own GEM_HOME, not a Gemfile: bundler rebuilds
# the json and racc this image already ships, and slim carries no compiler.
RUN gem install --no-document rubocop:1.92.3

# The service runs as a uid with no passwd entry, so $HOME is / and rubocop
# has nowhere to put its cache.
ENV XDG_CACHE_HOME=/cache

# World-writable so the service runs as any host uid without needing a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership".
RUN mkdir -p /cache && chmod -R 777 /cache

WORKDIR /work
