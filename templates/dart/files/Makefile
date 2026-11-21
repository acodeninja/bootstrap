RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Nothing to build: Dart runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) dart test

lint:
	$(RUN) dart analyze --fatal-infos
	$(RUN) dart format --output=none --set-exit-if-changed .

fmt:
	$(RUN) dart format .

build:
	@echo "nothing to build: Dart runs from source"

shell:
	$(RUN) bash
