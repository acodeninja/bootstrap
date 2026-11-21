RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Nothing to check: Bywater BASIC ships no checker)
	$(info make fmt     Nothing to format: Bywater BASIC ships no formatter)
	$(info make build   Nothing to build: BASIC is interpreted)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	@echo "nothing to check: Bywater BASIC ships no checker"

fmt:
	@echo "nothing to format: Bywater BASIC ships no formatter"

build:
	@echo "nothing to build: BASIC is interpreted"

shell:
	$(RUN) bash
