RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting and types)
	$(info make fmt     Reformat in place)
	$(info make build   Compile to .beam files)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) rebar3 eunit

lint:
	$(RUN) rebar3 fmt --check
	$(RUN) rebar3 dialyzer

fmt:
	$(RUN) rebar3 fmt --write

build:
	$(RUN) rebar3 compile

shell:
	$(RUN) bash
