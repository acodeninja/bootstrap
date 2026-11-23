RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Typecheck every module and check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Typecheck the library on its own)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) utest-run

# --no-output is the typechecker: the suite compiles, including the tests, and
# nothing runs.
lint:
	$(RUN) utest-run --no-output
	$(RUN) haxelib run formatter --check -s src -s test

fmt:
	$(RUN) haxelib run formatter -s src -s test

build:
	$(RUN) haxe build.hxml

shell:
	$(RUN) bash
