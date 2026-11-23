RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Nothing to check: every byte is a valid Befunge cell)
	$(info make fmt     Nothing to format: moving a cell changes the program)
	$(info make build   Nothing to build: Befunge is interpreted)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	@echo "nothing to check: every byte is a valid Befunge cell"

fmt:
	@echo "nothing to format: moving a cell changes the program"

build:
	@echo "nothing to build: Befunge is interpreted"

shell:
	$(RUN) bash
