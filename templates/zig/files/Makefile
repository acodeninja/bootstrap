RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the library into zig-out"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) zig build test --summary all

lint:
	$(RUN) zig fmt --check .

fmt:
	$(RUN) zig fmt .

build:
	$(RUN) zig build

shell:
	$(RUN) bash
