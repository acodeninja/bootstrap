RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Nothing to build: Lua runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

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
