RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check every program compiles, warnings included)
	$(info make fmt     Nothing to format: GnuCOBOL ships no formatter)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tap-run

lint:
	$(RUN) cobc-check-all

fmt:
	@echo "nothing to format: GnuCOBOL ships no formatter"

build:
	$(RUN) cobc -m -Wall -o /cache/build/{{PROJECT_SLUG}}.so src/{{PROJECT_SLUG}}.cbl

shell:
	$(RUN) bash
