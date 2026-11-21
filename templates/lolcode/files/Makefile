RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Nothing to check: lci has no check mode)
	$(info make fmt     Nothing to format: LOLCODE has no formatter)
	$(info make build   Nothing to build: LOLCODE is interpreted)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	@echo "nothing to check: lci has no check mode"

fmt:
	@echo "nothing to format: LOLCODE has no formatter"

build:
	@echo "nothing to build: LOLCODE is interpreted"

shell:
	$(RUN) bash
