RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check every file compiles)
	$(info make fmt     Nothing to format: Raku has no working formatter)
	$(info make build   Precompile every module in src)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) prove6 -Isrc t

lint:
	$(RUN) raku-check-all

fmt:
	@echo "nothing to format: Raku has no working formatter"

build:
	$(RUN) raku-precompile

shell:
	$(RUN) bash
