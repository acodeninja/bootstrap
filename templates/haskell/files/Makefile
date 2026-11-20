RUN := docker compose run --rm dev
DIST := --builddir=/cache/dist

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the library and the executable"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) cabal test $(DIST) all

lint:
	$(RUN) hlint .
	$(RUN) ormolu-tree --mode check

fmt:
	$(RUN) ormolu-tree --mode inplace

build:
	$(RUN) cabal build $(DIST) all

shell:
	$(RUN) bash
