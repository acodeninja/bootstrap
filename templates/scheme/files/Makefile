RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every file and promote the warnings to failures)
	$(info make fmt     Nothing to format: Debian packages no Scheme formatter)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) guile-test

lint:
	$(RUN) guile-lint

fmt:
	@echo "nothing to format: Debian packages no Scheme formatter"

build:
	$(RUN) guile-build

shell:
	$(RUN) bash
