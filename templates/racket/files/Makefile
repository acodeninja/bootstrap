RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Expand every module, which is the whole check)
	$(info make fmt     Nothing to format: Racket has no pinnable formatter)
	$(info make build   Compile every module to bytecode)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) raco test -y tests/

lint:
	$(RUN) racket-lint

fmt:
	@echo "nothing to format: Racket has no pinnable formatter"

build:
	$(RUN) racket-build

shell:
	$(RUN) bash
