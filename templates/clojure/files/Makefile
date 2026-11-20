RUN := docker compose run --rm dev
SOURCES := src test deps.edn

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check lint rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Resolve dependencies and cache the classpath"
	@echo "make shell   Open a shell in the container"

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
