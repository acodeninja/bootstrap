RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Type-check the project)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the project into /cache)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) nimble test -y --nimcache:/cache/nimcache

lint:
	$(RUN) nim-check-all

fmt:
	$(RUN) nim-pretty-all

build:
	$(RUN) nim c --nimcache:/cache/nimcache --out:/cache/bin/{{PROJECT_SNAKE}} src/{{PROJECT_SNAKE}}.nim

shell:
	$(RUN) bash
