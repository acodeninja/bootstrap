RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the library)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) make -f build.mk test

lint:
	$(RUN) make -f build.mk lint

fmt:
	$(RUN) make -f build.mk fmt

build:
	$(RUN) make -f build.mk build

shell:
	$(RUN) bash
