RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the kitchen sink suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Nothing to build: JavaScript runs from source"
	@echo "make shell   Open a shell in the container"

# Bare, with no path. `node --test kitchen-sink/` treats the argument as a
# module to load and exits 1 with MODULE_NOT_FOUND even when the suite is
# green. Bare, node walks the tree itself -- and exits 0 when it finds no
# tests, which is what lets you delete kitchen-sink/ and still run make test.
test:
	$(RUN) node --test

lint:
	$(RUN) eslint .
	$(RUN) prettier --check .

fmt:
	$(RUN) prettier --write .
	$(RUN) eslint --fix .

build:
	@echo "nothing to build: JavaScript runs from source"

shell:
	$(RUN) bash
