RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check syntax and politeness"
	@echo "make fmt     Nothing to format: INTERCAL has no formatter"
	@echo "make build   Compile the project into /cache"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) tap-run

lint:
	$(RUN) intercal-compile -c

fmt:
	@echo "nothing to format: INTERCAL has no formatter"

build:
	$(RUN) intercal-compile

shell:
	$(RUN) bash
