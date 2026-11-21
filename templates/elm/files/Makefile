RUN := docker compose run --rm dev
SOURCES := src tests

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the module and its dependencies)
	$(info make shell   Open a shell in the container)
	@cd .

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
