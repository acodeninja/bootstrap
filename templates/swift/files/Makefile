RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the library)
	$(info make shell   Open a shell in the container)
	@cd .

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
