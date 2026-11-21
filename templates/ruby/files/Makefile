RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Nothing to build: Ruby runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) rake test

lint:
	$(RUN) rubocop

fmt:
	$(RUN) rubocop -a

build:
	@echo "nothing to build: Ruby runs from source"

shell:
	$(RUN) bash
