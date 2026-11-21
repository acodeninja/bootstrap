RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every word, which is the whole check)
	$(info make fmt     Nothing to format: Forth has no formatter)
	$(info make build   Nothing to build: Forth runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	$(RUN) forth-check

fmt:
	@echo "nothing to format: Forth has no formatter"

build:
	@echo "nothing to build: Forth runs from source"

shell:
	$(RUN) bash
