RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run every test file through pg_prove)
	$(info make lint    Check every statement, and every function body)
	$(info make fmt     Reformat every statement with sqlfluff)
	$(info make build   Load src/ into a fresh schema)
	$(info make shell   Open a shell beside a running database)
	@cd .

test:
	$(RUN) with-pg pg_prove --ext .sql tests/

lint:
	$(RUN) sqlfluff lint .
	$(RUN) with-pg pg-check

fmt:
	$(RUN) sqlfluff format .

build:
	$(RUN) with-pg

shell:
	$(RUN) bash
