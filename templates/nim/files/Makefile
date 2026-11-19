RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Type-check the project"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) nimble test -y --nimcache:/cache/nimcache

lint:
	$(RUN) nim-check-all

fmt:
	$(RUN) nim-pretty-all

build:
	$(RUN) nim c --nimcache:/cache/nimcache --out:/cache/bin/{{PROJECT_SNAKE}} src/{{PROJECT_SNAKE}}.nim

shell:
	$(RUN) bash
