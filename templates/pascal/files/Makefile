RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Compile every unit, warnings included"
	@echo "make fmt     Nothing to format: Free Pascal ships no usable formatter"
	@echo "make build   Compile the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) fpcunit-run

lint:
	$(RUN) fpc-check-all

fmt:
	@echo "nothing to format: Free Pascal ships no usable formatter"

build:
	$(RUN) fpc -Mobjfpc -Sh -Sew -Fusrc -FU/cache/build src/{{PROJECT_SNAKE}}.pas

shell:
	$(RUN) bash
