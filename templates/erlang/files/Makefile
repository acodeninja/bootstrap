RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting and types"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile to .beam files"
	@echo "make shell   Open a shell in the container"

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
