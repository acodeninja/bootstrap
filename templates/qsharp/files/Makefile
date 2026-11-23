RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every source and test file)
	$(info make fmt     Nothing to format: the released QDK ships no formatter)
	$(info make build   Nothing to build: the simulator compiles from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) qsharp-test

lint:
	$(RUN) qsharp-check

fmt:
	@echo "nothing to format: the released QDK ships no formatter"

build:
	@echo "nothing to build: the simulator compiles from source"

shell:
	$(RUN) bash
