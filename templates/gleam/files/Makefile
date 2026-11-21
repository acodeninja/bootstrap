RUN := docker compose run --rm dev
SOURCES := src test

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting and types)
	$(info make fmt     Reformat in place)
	$(info make build   Compile to BEAM bytecode)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) gleam test

lint:
	$(RUN) gleam format --check $(SOURCES)
	$(RUN) gleam check

fmt:
	$(RUN) gleam format $(SOURCES)

build:
	$(RUN) gleam build

shell:
	$(RUN) bash
