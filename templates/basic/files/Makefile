RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Nothing to check: Bywater BASIC ships no checker"
	@echo "make fmt     Nothing to format: Bywater BASIC ships no formatter"
	@echo "make build   Nothing to build: BASIC is interpreted"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) tap-run

lint:
	@echo "nothing to check: Bywater BASIC ships no checker"

fmt:
	@echo "nothing to format: Bywater BASIC ships no formatter"

build:
	@echo "nothing to build: BASIC is interpreted"

shell:
	$(RUN) bash
