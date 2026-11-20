RUN := docker compose run --rm dev
GRADLE := gradle --no-daemon --project-cache-dir /cache/project-cache

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile and package into a jar"
	@echo "make shell   Open a shell in the container"

# A daemon inside a --rm container outlives nothing, and --project-cache-dir
# keeps Gradle's .gradle/ out of the bind-mounted project.
test:
	$(RUN) $(GRADLE) test

lint:
	$(RUN) $(GRADLE) checkstyleMain checkstyleTest

fmt:
	$(RUN) $(GRADLE) spotlessApply

build:
	$(RUN) $(GRADLE) assemble

shell:
	$(RUN) bash
