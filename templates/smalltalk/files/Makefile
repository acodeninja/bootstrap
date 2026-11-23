RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile every file, which is the whole check)
	$(info make fmt     Nothing to format: Smalltalk has no formatter)
	$(info make build   Snapshot an image with the project loaded)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) gst-test

lint:
	$(RUN) gst-check

fmt:
	@echo "nothing to format: Smalltalk has no formatter"

build:
	$(RUN) gst-build

shell:
	$(RUN) bash
