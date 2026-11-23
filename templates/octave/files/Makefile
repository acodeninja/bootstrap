RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check style and lint rules)
	$(info make fmt     Reformat in place)
	$(info make build   Nothing to build: Octave runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) octave-test

lint:
	$(RUN) mh_style --octave latest .
	$(RUN) mh_lint --octave latest .

fmt:
	$(RUN) mh_style --octave latest --fix .

build:
	@echo "nothing to build: Octave runs from source"

shell:
	$(RUN) bash
