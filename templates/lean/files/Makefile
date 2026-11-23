RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Typecheck every module, warnings included)
	$(info make fmt     Nothing to format: Lean ships no formatter)
	$(info make build   Compile the library)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) lake test

lint:
	$(RUN) lake build {{PROJECT_SNAKE}} test

fmt:
	@echo "nothing to format: Lean ships no formatter"

build:
	$(RUN) lake build

shell:
	$(RUN) bash
