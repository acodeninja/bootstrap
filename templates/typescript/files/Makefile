RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the kitchen sink suite)
	$(info make lint    Check types, lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile to JavaScript)
	$(info make shell   Open a shell in the container)
	@cd .

# Bare, with no path. `node --test kitchen-sink.test.ts` treats the argument
# as a module to load and exits 1 with MODULE_NOT_FOUND even when the suite
# is green. Bare, node walks the tree itself, exiting 0 when it finds none.
test:
	$(RUN) node --test

lint:
	$(RUN) tsc --noEmit
	$(RUN) eslint .
	$(RUN) prettier --check .

fmt:
	$(RUN) prettier --write .
	$(RUN) eslint --fix .

build:
	$(RUN) tsc --outDir /cache/dist

shell:
	$(RUN) bash
