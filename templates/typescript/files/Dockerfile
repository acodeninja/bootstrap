# syntax=docker/dockerfile:1
FROM node:26.13.1-trixie-slim

# The toolchain installs to /node_modules, outside /work, for the same reason
# templates/javascript does: npm refuses to run with cwd=/, and a bind mount
# over /work would otherwise shadow a volume there the moment package.json
# changes. Installing in /deps and moving the result sidesteps both.
WORKDIR /deps
COPY package.json ./
RUN npm install --no-audit --no-fund \
    && mv /deps/node_modules /node_modules \
    && rm -rf /deps /root/.npm

ENV PATH=/node_modules/.bin:$PATH
ENV NPM_CONFIG_CACHE=/cache/npm
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

# World-writable so the service runs as any host uid without needing a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership".
RUN mkdir -p /cache/npm && chmod -R 777 /cache

WORKDIR /work
