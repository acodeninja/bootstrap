RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the crate)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) cargo test

lint:
	$(RUN) cargo fmt --check
	$(RUN) cargo clippy -- -D warnings

fmt:
	$(RUN) cargo fmt

build:
	$(RUN) cargo build

shell:
	$(RUN) bash
