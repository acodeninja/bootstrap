RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the project"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) mix test

lint:
	$(RUN) mix format --check-formatted
	$(RUN) mix credo --strict

fmt:
	$(RUN) mix format

build:
	$(RUN) mix compile

shell:
	$(RUN) bash
