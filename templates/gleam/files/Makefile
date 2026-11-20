RUN := docker compose run --rm dev
SOURCES := src test

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting and types"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile to BEAM bytecode"
	@echo "make shell   Open a shell in the container"

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
