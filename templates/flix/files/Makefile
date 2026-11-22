RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Type and effect check without writing anything)
	$(info make fmt     Reformat in place)
	$(info make build   Compile to class files in the build volume)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) flix test

lint:
	$(RUN) flix check

fmt:
	$(RUN) flix format

build:
	$(RUN) flix build-classes

shell:
	$(RUN) bash
