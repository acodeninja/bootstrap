RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every unit, warnings included)
	$(info make fmt     Nothing to format: Free Pascal ships no usable formatter)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) fpcunit-run

lint:
	$(RUN) fpc-check-all

fmt:
	@echo "nothing to format: Free Pascal ships no usable formatter"

build:
	$(RUN) fpc -Mobjfpc -Sh -Sew -Fusrc -FU/cache/build src/{{PROJECT_SNAKE}}.pas

shell:
	$(RUN) bash
