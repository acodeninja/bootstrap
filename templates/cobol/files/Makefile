RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check every program compiles, warnings included"
	@echo "make fmt     Nothing to format: GnuCOBOL ships no formatter"
	@echo "make build   Compile the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) tap-run

lint:
	$(RUN) cobc-check-all

fmt:
	@echo "nothing to format: GnuCOBOL ships no formatter"

build:
	$(RUN) cobc -m -Wall -o /cache/build/{{PROJECT_SLUG}}.so src/{{PROJECT_SLUG}}.cbl

shell:
	$(RUN) bash
