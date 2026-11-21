RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Load every source file and check it)
	$(info make fmt     Nothing to format: SWI-Prolog ships no formatter)
	$(info make build   Compile the project into a saved state in /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) plunit-all

lint:
	$(RUN) prolog-check-all

fmt:
	@echo "nothing to format: SWI-Prolog ships no formatter"

build:
	$(RUN) swipl -o /cache/bin/{{PROJECT_SNAKE}} -c src/{{PROJECT_SNAKE}}.pl

shell:
	$(RUN) bash
