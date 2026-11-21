RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Boot each test on an emulated Cortex-M3)
	$(info make lint    Assemble every file, warnings as errors)
	$(info make fmt     Nothing to format: ARM assembly has no formatter)
	$(info make build   Assemble the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) arm32-run

lint:
	$(RUN) arm32-check

fmt:
	@echo "nothing to format: ARM assembly has no formatter"

build:
	$(RUN) arm32-build

shell:
	$(RUN) bash
