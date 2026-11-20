RUN := docker compose run --rm dev
SOURCES := src tests

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the module and its dependencies"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) elm-test

lint:
	$(RUN) elm-format --validate $(SOURCES)

fmt:
	$(RUN) elm-format --yes $(SOURCES)

# A library module has no `main`, and elm make refuses to emit JavaScript
# without one. /dev/null is the compiler's own answer: compile, emit nothing.
build:
	$(RUN) elm make src/{{PROJECT_SNAKE}}/Greeter.elm --output=/dev/null

shell:
	$(RUN) bash
