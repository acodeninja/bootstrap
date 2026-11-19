# syntax=docker/dockerfile:1
FROM python:3.15.2-slim-trixie

ENV PIP_CACHE_DIR=/cache/pip
ENV PYTEST_ADDOPTS="-o cache_dir=/cache/pytest"
ENV PYTHONPYCACHEPREFIX=/cache/pycache
ENV RUFF_CACHE_DIR=/cache/ruff

RUN pip install --no-cache-dir pytest==9.2.0 ruff==0.17.6

# World-writable so the service runs as any host uid. See docs/containers.md
# "File ownership".
RUN mkdir -p /cache/pip /cache/pytest /cache/pycache /cache/ruff \
    && chmod -R 777 /cache

WORKDIR /work
