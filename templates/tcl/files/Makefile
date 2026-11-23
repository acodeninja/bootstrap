RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Byte-compile every file and report the parse errors)
	$(info make fmt     Nothing to format: Tcl has no formatter)
	$(info make build   Nothing to build: Tcl runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) tcltest-all

lint:
	$(RUN) tcl-check

fmt:
	@echo "nothing to format: Tcl has no formatter"

build:
	@echo "nothing to build: Tcl runs from source"

shell:
	$(RUN) bash
