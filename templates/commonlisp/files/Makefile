RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Recompile every file, warnings included)
	$(info make fmt     Nothing to format: Common Lisp has no canonical formatter)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) sbcl-test

lint:
	$(RUN) sbcl-lint

fmt:
	@echo "nothing to format: Common Lisp has no canonical formatter"

build:
	$(RUN) sbcl-build

shell:
	$(RUN) bash
