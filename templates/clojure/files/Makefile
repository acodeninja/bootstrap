RUN := docker compose run --rm dev
SOURCES := src test deps.edn

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Resolve dependencies and cache the classpath)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) clojure -M:test

lint:
	$(RUN) clj-kondo --lint $(SOURCES)
	$(RUN) cljfmt check $(SOURCES)

fmt:
	$(RUN) cljfmt fix $(SOURCES)

build:
	$(RUN) clojure -P -M:test

shell:
	$(RUN) bash
