RUN := docker compose run --rm dev
DIST := --builddir=/cache/dist

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the library and the executable)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) cabal test $(DIST) all

lint:
	$(RUN) hlint .
	$(RUN) ormolu-tree --mode check

fmt:
	$(RUN) ormolu-tree --mode inplace

build:
	$(RUN) cabal build $(DIST) all

shell:
	$(RUN) bash
