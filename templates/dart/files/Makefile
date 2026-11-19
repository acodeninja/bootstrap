RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Nothing to build: Dart runs from source"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) dart test

lint:
	$(RUN) dart analyze --fatal-infos
	$(RUN) dart format --output=none --set-exit-if-changed .

fmt:
	$(RUN) dart format .

build:
	@echo "nothing to build: Dart runs from source"

shell:
	$(RUN) bash
