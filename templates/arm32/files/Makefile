RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Boot each test on an emulated Cortex-M3"
	@echo "make lint    Assemble every file, warnings as errors"
	@echo "make fmt     Nothing to format: ARM assembly has no formatter"
	@echo "make build   Assemble the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) arm32-run

lint:
	$(RUN) arm32-check

fmt:
	@echo "nothing to format: ARM assembly has no formatter"

build:
	$(RUN) arm32-build

shell:
	$(RUN) bash
