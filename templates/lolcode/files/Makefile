RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Nothing to check: lci has no check mode"
	@echo "make fmt     Nothing to format: LOLCODE has no formatter"
	@echo "make build   Nothing to build: LOLCODE is interpreted"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) tap-run

lint:
	@echo "nothing to check: lci has no check mode"

fmt:
	@echo "nothing to format: LOLCODE has no formatter"

build:
	@echo "nothing to build: LOLCODE is interpreted"

shell:
	$(RUN) bash
