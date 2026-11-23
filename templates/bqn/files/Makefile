RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every file without running it)
	$(info make fmt     Nothing to format: BQN has no formatter)
	$(info make build   Nothing to build: BQN runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	$(RUN) bqn-check

fmt:
	@echo "nothing to format: BQN has no formatter"

build:
	@echo "nothing to build: BQN runs from source"

shell:
	$(RUN) bash
