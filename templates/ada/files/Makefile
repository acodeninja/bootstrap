RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check every unit, warnings as errors"
	@echo "make fmt     Nothing to format: Debian ships no gnatpp"
	@echo "make build   Compile the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) aunit-run

lint:
	$(RUN) gnat-check-all

fmt:
	@echo "nothing to format: Debian ships no gnatpp"

build:
	$(RUN) gprbuild -q -P {{PROJECT_SNAKE}}.gpr

shell:
	$(RUN) bash
