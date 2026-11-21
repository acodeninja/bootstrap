RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Compile every word, which is the whole check"
	@echo "make fmt     Nothing to format: Forth has no formatter"
	@echo "make build   Nothing to build: Forth runs from source"
	@echo "make shell   Open a shell in the container"

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
