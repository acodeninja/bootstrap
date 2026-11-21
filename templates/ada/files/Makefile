RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check every unit, warnings as errors)
	$(info make fmt     Nothing to format: Debian ships no gnatpp)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) aunit-run

lint:
	$(RUN) gnat-check-all

fmt:
	@echo "nothing to format: Debian ships no gnatpp"

build:
	$(RUN) gprbuild -q -P {{PROJECT_SNAKE}}.gpr

shell:
	$(RUN) bash
