RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the crate"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) cargo test

lint:
	$(RUN) cargo fmt --check
	$(RUN) cargo clippy -- -D warnings

fmt:
	$(RUN) cargo fmt

build:
	$(RUN) cargo build

shell:
	$(RUN) bash
