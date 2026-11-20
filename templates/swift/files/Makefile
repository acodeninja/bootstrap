RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the library"
	@echo "make shell   Open a shell in the container"

# SwiftPM writes .build beside Package.swift unless every invocation redirects
# it, which would put build artefacts in the bind mount instead of the cache.
test:
	$(RUN) swift test --scratch-path /cache/build

# Without --strict every finding is a warning and the target can never go red.
# Named paths rather than `.`, or a stray .build of generated sources is linted.
lint:
	$(RUN) swift format lint --strict --recursive src tests Package.swift

fmt:
	$(RUN) swift format --in-place --recursive src tests Package.swift

build:
	$(RUN) swift build --scratch-path /cache/build

shell:
	$(RUN) bash
