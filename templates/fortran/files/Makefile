RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the project"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) fpm test

lint:
	$(RUN) fprettify-check

fmt:
	$(RUN) fprettify --recursive src test

build:
	$(RUN) fpm build

shell:
	$(RUN) bash
