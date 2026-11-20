RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Nothing to build: Lua runs from source"
	@echo "make shell   Open a shell in the container"

# Bare, with no path. Busted's default root is ./spec, which it walks itself
# -- so deleting spec/kitchen_sink_spec.lua still leaves make test green as
# long as another spec file exists.
test:
	$(RUN) busted

lint:
	$(RUN) luacheck .
	$(RUN) stylua --check .

fmt:
	$(RUN) stylua .

build:
	@echo "nothing to build: Lua runs from source"

shell:
	$(RUN) bash
