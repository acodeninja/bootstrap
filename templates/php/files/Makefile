RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Nothing to build: PHP runs from source"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) phpunit

lint:
	$(RUN) phpstan analyse
	$(RUN) php-cs-fixer fix --dry-run --diff

fmt:
	$(RUN) php-cs-fixer fix

build:
	@echo "nothing to build: PHP runs from source"

shell:
	$(RUN) bash
