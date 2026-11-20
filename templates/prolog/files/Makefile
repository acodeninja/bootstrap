RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Load every source file and check it"
	@echo "make fmt     Nothing to format: SWI-Prolog ships no formatter"
	@echo "make build   Compile the project into a saved state in /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) plunit-all

lint:
	$(RUN) prolog-check-all

fmt:
	@echo "nothing to format: SWI-Prolog ships no formatter"

build:
	$(RUN) swipl -o /cache/bin/{{PROJECT_SNAKE}} -c src/{{PROJECT_SNAKE}}.pl

shell:
	$(RUN) bash
