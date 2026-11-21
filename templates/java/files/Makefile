RUN := docker compose run --rm dev
GRADLE := gradle --no-daemon --project-cache-dir /cache/project-cache

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile and package into a jar)
	$(info make shell   Open a shell in the container)
	@cd .

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
