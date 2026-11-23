RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Type, mode and determinism check every module)
	$(info make fmt     Nothing to format: Mercury has no formatter)
	$(info make build   Compile src into a library in /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) mercury-tap

lint:
	$(RUN) mercury-check

fmt:
	@echo "nothing to format: Mercury has no formatter"

build:
	$(RUN) mercury-build

shell:
	$(RUN) bash
