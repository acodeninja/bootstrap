RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the library"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) make -f build.mk test

lint:
	$(RUN) make -f build.mk lint

fmt:
	$(RUN) make -f build.mk fmt

build:
	$(RUN) make -f build.mk build

shell:
	$(RUN) bash
