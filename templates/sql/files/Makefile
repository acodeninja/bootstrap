RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check every statement with sqlfluff)
	$(info make fmt     Reformat every statement with sqlfluff)
	$(info make build   Nothing to build: SQLite reads the schema as it runs)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	$(RUN) sqlfluff lint .

fmt:
	$(RUN) sqlfluff format .

build:
	@echo "nothing to build: SQLite reads the schema as it runs"

shell:
	$(RUN) bash
