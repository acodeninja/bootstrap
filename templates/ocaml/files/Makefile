RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the library and the tests"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) dune test

lint:
	$(RUN) dune build @fmt

fmt:
	$(RUN) dune-fmt

build:
	$(RUN) dune build

shell:
	$(RUN) bash
